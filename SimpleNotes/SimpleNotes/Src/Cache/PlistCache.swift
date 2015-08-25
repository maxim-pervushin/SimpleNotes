//
// Created by Maxim Pervushin on 11/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class PlistCache: Cache {

    // MARK: - PlistCache

    private var notebooksByIdentifier = [String: Notebook]()
    private var notesByIdentifier = [String: Note]()
    private var notebooksChanges = Changes<Notebook>()
    private var notesChanges = Changes<Note>()
    private var privateDelegate: CacheDelegate?

    private func packNotebook(notebook: Notebook) -> [String:String]? {
        return [
                "identifier": notebook.identifier,
                "name": notebook.name,
        ]
    }

    private func packNote(note: Note) -> [String:String]? {
        var result = [
                "identifier": note.identifier,
                "text": note.text,
                "isFavorite": note.isFavorite ? "true" : "false"
        ]
        if let notebookIdentifier = note.notebookIdentifier {
            result["notebookIdentifier"] = notebookIdentifier
        }
        return result
    }

    private func unpackNotebook(object: [String:String]) -> Notebook? {
        if let
        identifier = object["identifier"],
        name = object["name"] {
            return Notebook(identifier: identifier, name: name)
        }
        return nil
    }

    private func unpackNote(object: [String:String]) -> Note? {
        if let
        identifier = object["identifier"],
        text = object["text"],
        isFavoriteString = object["isFavorite"] {
            return Note(identifier: identifier, text: text, isFavorite: isFavoriteString == "true" ? true : false , notebookIdentifier: object["notebookIdentifier"])
        }
        return nil
    }

    private var documentsDirectory: NSString {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
    }

    private var contentFilePath: String {
        return documentsDirectory.stringByAppendingPathComponent("/cache.plist")
    }

    private func save() {
        var content = [String: [[String: String]]]()

        var packedNotebooksByIdentifier = [[String: String]]()
        for (_, value) in notebooksByIdentifier {
            if let packed = packNotebook(value) {
                packedNotebooksByIdentifier.append(packed)
            }
        }
        content["notebooksByIdentifier"] = packedNotebooksByIdentifier

        var packedNotebooksToSave = [[String: String]]()
        for (_, value) in notebooksChanges.toSave {
            if let packed = packNotebook(value) {
                packedNotebooksToSave.append(packed)
            }
        }
        content["notebooksToSave"] = packedNotebooksToSave

        var packedNotebooksToDelete = [[String: String]]()
        for (_, value) in notebooksChanges.toDelete {
            if let packed = packNotebook(value) {
                packedNotebooksToDelete.append(packed)
            }
        }
        content["notebooksToDelete"] = packedNotebooksToDelete

        var packedNotesByIdentifier = [[String: String]]()
        for (_, value) in notesByIdentifier {
            if let packed = packNote(value) {
                packedNotesByIdentifier.append(packed)
            }
        }
        content["notesByIdentifier"] = packedNotesByIdentifier

        var packedNotesToSave = [[String: String]]()
        for (_, value) in notesChanges.toSave {
            if let packed = packNote(value) {
                packedNotesToSave.append(packed)
            }
        }
        content["notesToSave"] = packedNotesToSave

        var packedNotesToDelete = [[String: String]]()
        for (_, value) in notesChanges.toDelete {
            if let packed = packNote(value) {
                packedNotesToDelete.append(packed)
            }
        }
        content["notesToDelete"] = packedNotesToDelete

        println("contentFilePath: \(contentFilePath)")
        if !NSDictionary(dictionary: content).writeToFile(contentFilePath, atomically: true) {
            println("Error: unable to write file")
        }
    }

    private func load() {
        if let content = NSDictionary(contentsOfFile: contentFilePath) as? [String:[[String:String]]] {

            var unpackedNotebooksByIdentifier = [String: Notebook]()
            if let packedNotebooksByIdentifier = content["notebooksByIdentifier"] {
                for packed in packedNotebooksByIdentifier {
                    if let unpacked = unpackNotebook(packed) {
                        unpackedNotebooksByIdentifier[unpacked.identifier] = unpacked
                    }
                }
            }
            notebooksByIdentifier = unpackedNotebooksByIdentifier

            var unpackedNotebooksToSave = [String: Notebook]()
            if let packedNotebooksToSave = content["notebooksToSave"] {
                for packed in packedNotebooksToSave {
                    if let unpacked = unpackNotebook(packed) {
                        unpackedNotebooksToSave[unpacked.identifier] = unpacked
                    }
                }
            }
            notebooksChanges.toSave = unpackedNotebooksToSave

            var unpackedNotebooksToDelete = [String: Notebook]()
            if let packedNotebooksToDelete = content["notebooksToDelete"] {
                for packed in packedNotebooksToDelete {
                    if let unpacked = unpackNotebook(packed) {
                        unpackedNotebooksToDelete[unpacked.identifier] = unpacked
                    }
                }
            }
            notebooksChanges.toDelete = unpackedNotebooksToDelete

            var unpackedNotesByIdentifier = [String: Note]()
            if let packedNotesByIdentifier = content["notesByIdentifier"] {
                for packed in packedNotesByIdentifier {
                    if let unpacked = unpackNote(packed) {
                        unpackedNotesByIdentifier[unpacked.identifier] = unpacked
                    }
                }
            }
            notesByIdentifier = unpackedNotesByIdentifier

            var unpackedNotesToSave = [String: Note]()
            if let packedNotesToSave = content["notesToSave"] {
                for packed in packedNotesToSave {
                    if let unpacked = unpackNote(packed) {
                        unpackedNotesToSave[unpacked.identifier] = unpacked
                    }
                }
            }
            notesChanges.toSave = unpackedNotesToSave

            var unpackedNotesToDelete = [String: Note]()
            if let packedNotesToDelete = content["notesToDelete"] {
                for packed in packedNotesToDelete {
                    if let unpacked = unpackNote(packed) {
                        unpackedNotesToDelete[unpacked.identifier] = unpacked
                    }
                }
            }
            notesChanges.toDelete = unpackedNotesToDelete
        }
    }

    private func changed() {
        save()
        delegate?.cacheChanged(self)
    }

    init() {
        load()
        // TODO: Remove later
        println("Favorites: \(favoriteNotes)")
    }

    // MARK: - Cache

    var delegate: CacheDelegate? {
        get {
            return privateDelegate
        }
        set {
            privateDelegate = newValue
        }
    }

    func saveNotebook(notebook: Notebook) -> Bool {
        notebooksByIdentifier[notebook.identifier] = notebook
        notebooksChanges.toSave[notebook.identifier] = notebook
        notebooksChanges.toDelete[notebook.identifier] = nil
        changed()
        return true
    }

    func deleteNotebook(notebook: Notebook) -> Bool {
        if let _ = notebooksByIdentifier[notebook.identifier] {
            notebooksByIdentifier[notebook.identifier] = nil
            notebooksChanges.toDelete[notebook.identifier] = notebook
            notebooksChanges.toSave[notebook.identifier] = nil
            for note in notes {
                if note.notebookIdentifier == notebook.identifier {
                    deleteNote(note)
                }
            }
            changed()
            return true
        }
        return false
    }

    var notebooks: [Notebook] {
        get {
            return notebooksByIdentifier.values.array
        }
        set {
            var newNotebooksByIdentifier = [String: Notebook]()
            for notebook in newValue {
                newNotebooksByIdentifier[notebook.identifier] = notebook
            }
            for (_, notebook) in notebooksChanges.toSave {
                newNotebooksByIdentifier[notebook.identifier] = notebook
            }
            for (_, notebook) in notebooksChanges.toDelete {
                if let _ = notebooksByIdentifier[notebook.identifier] {
                    newNotebooksByIdentifier[notebook.identifier] = nil
                }
            }
            notebooksByIdentifier = newNotebooksByIdentifier
            changed()
        }
    }

    func saveNote(note: Note) -> Bool {
        notesByIdentifier[note.identifier] = note
        notesChanges.toSave[note.identifier] = note
        notesChanges.toDelete[note.identifier] = nil
        changed()
        return true
    }

    func deleteNote(note: Note) -> Bool {
        if let _ = notesByIdentifier[note.identifier] {
            notesByIdentifier[note.identifier] = nil
            notesChanges.toDelete[note.identifier] = note
            notesChanges.toSave[note.identifier] = nil
            changed()
            return true
        }
        return false
    }

    var notes: [Note] {
        get {
            return notesByIdentifier.values.array
        }
        set {
            var newNotesByIdentifier = [String: Note]()
            for note in newValue {
                newNotesByIdentifier[note.identifier] = note
            }
            for (_, note) in notesChanges.toSave {
                newNotesByIdentifier[note.identifier] = note
            }
            for (_, note) in notesChanges.toDelete {
                if let _ = notesByIdentifier[note.identifier] {
                    newNotesByIdentifier[note.identifier] = nil
                }
            }
            notesByIdentifier = newNotesByIdentifier
            changed()
        }
    }

    var favoriteNotes: [Note] {
        var result = [Note]()
        for (_, note) in notesByIdentifier {
            if note.isFavorite {
                result.append(note)
            }
        }
        return result
    }

    var hasChanges: Bool {
        return notebooksChanges.hasChanges || notesChanges.hasChanges
    }

    var changes: ChangesEnvelope {
        return ChangesEnvelope(notebooksChanges: notebooksChanges, notesChanges: notesChanges)
    }

    func removeChanges(changes: ChangesEnvelope) {

        for (_, notebook) in changes.notebooksChanges.toSave {
            notebooksChanges.toSave[notebook.identifier] = nil
        }

        for (_, notebook) in changes.notebooksChanges.toDelete {
            notebooksChanges.toDelete[notebook.identifier] = nil
        }

        for (_, note) in changes.notesChanges.toSave {
            notesChanges.toSave[note.identifier] = nil
        }

        for (_, note) in changes.notesChanges.toDelete {
            notesChanges.toDelete[note.identifier] = nil
        }
    }

    func clear() {
        notebooksByIdentifier = [String: Notebook]()
        notesByIdentifier = [String: Note]()
        notebooksChanges = Changes<Notebook>()
        notesChanges = Changes<Note>()
        save()
        changed()
    }
}
