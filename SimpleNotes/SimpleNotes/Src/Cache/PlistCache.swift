//
// Created by Maxim Pervushin on 11/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class PlistCache: Cache {

    // MARK: - PlistCache

    private var notebooksByIdentifier = [String: Notebook]()
    private var notebooksToCreate = [String: Notebook]()
    private var notebooksToDelete = [String: Notebook]()
    private var notebooksToUpdate = [String: Notebook]()
    private var notesByIdentifier = [String: Note]()
    private var notesToCreate = [String: Note]()
    private var notesToDelete = [String: Note]()
    private var notesToUpdate = [String: Note]()
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
        text = object["text"] {
            return Note(identifier: identifier, text: text, notebookIdentifier: object["notebookIdentifier"])
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

        var packedNotebooksToCreate = [[String: String]]()
        for (_, value) in notebooksToCreate {
            if let packed = packNotebook(value) {
                packedNotebooksToCreate.append(packed)
            }
        }
        content["notebooksToCreate"] = packedNotebooksToCreate

        var packedNotebooksToDelete = [[String: String]]()
        for (_, value) in notebooksToDelete {
            if let packed = packNotebook(value) {
                packedNotebooksToDelete.append(packed)
            }
        }
        content["notebooksToDelete"] = packedNotebooksToDelete

        var packedNotebooksToUpdate = [[String: String]]()
        for (_, value) in notebooksToUpdate {
            if let packed = packNotebook(value) {
                packedNotebooksToUpdate.append(packed)
            }
        }
        content["notebooksToUpdate"] = packedNotebooksToUpdate

        var packedNotesByIdentifier = [[String: String]]()
        for (_, value) in notesByIdentifier {
            if let packed = packNote(value) {
                packedNotesByIdentifier.append(packed)
            }
        }
        content["notesByIdentifier"] = packedNotesByIdentifier

        var packedNotesToCreate = [[String: String]]()
        for (_, value) in notesToCreate {
            if let packed = packNote(value) {
                packedNotesToCreate.append(packed)
            }
        }
        content["notesToCreate"] = packedNotesToCreate

        var packedNotesToDelete = [[String: String]]()
        for (_, value) in notesToDelete {
            if let packed = packNote(value) {
                packedNotesToDelete.append(packed)
            }
        }
        content["notesToDelete"] = packedNotesToDelete

        var packedNotesToUpdate = [[String: String]]()
        for (_, value) in notesToUpdate {
            if let packed = packNote(value) {
                packedNotesToUpdate.append(packed)
            }
        }
        content["notesToUpdate"] = packedNotesToUpdate

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

            var unpackedNotebooksToCreate = [String: Notebook]()
            if let packedNotebooksToCreate = content["notebooksToCreate"] {
                for packed in packedNotebooksToCreate {
                    if let unpacked = unpackNotebook(packed) {
                        unpackedNotebooksToCreate[unpacked.identifier] = unpacked
                    }
                }
            }
            notebooksToCreate = unpackedNotebooksToCreate

            var unpackedNotebooksToDelete = [String: Notebook]()
            if let packedNotebooksToDelete = content["notebooksToDelete"] {
                for packed in packedNotebooksToDelete {
                    if let unpacked = unpackNotebook(packed) {
                        unpackedNotebooksToDelete[unpacked.identifier] = unpacked
                    }
                }
            }
            notebooksToDelete = unpackedNotebooksToDelete

            var unpackedNotebooksToUpdate = [String: Notebook]()
            if let packedNotebooksToUpdate = content["notebooksToUpdate"] {
                for packed in packedNotebooksToUpdate {
                    if let unpacked = unpackNotebook(packed) {
                        unpackedNotebooksToUpdate[unpacked.identifier] = unpacked
                    }
                }
            }
            notebooksToUpdate = unpackedNotebooksToUpdate

            var unpackedNotesByIdentifier = [String: Note]()
            if let packedNotesByIdentifier = content["notesByIdentifier"] {
                for packed in packedNotesByIdentifier {
                    if let unpacked = unpackNote(packed) {
                        unpackedNotesByIdentifier[unpacked.identifier] = unpacked
                    }
                }
            }
            notesByIdentifier = unpackedNotesByIdentifier

            var unpackedNotesToCreate = [String: Note]()
            if let packedNotesToCreate = content["notesToCreate"] {
                for packed in packedNotesToCreate {
                    if let unpacked = unpackNote(packed) {
                        unpackedNotesToCreate[unpacked.identifier] = unpacked
                    }
                }
            }
            notesToCreate = unpackedNotesToCreate

            var unpackedNotesToDelete = [String: Note]()
            if let packedNotesToDelete = content["notesToDelete"] {
                for packed in packedNotesToDelete {
                    if let unpacked = unpackNote(packed) {
                        unpackedNotesToDelete[unpacked.identifier] = unpacked
                    }
                }
            }
            notesToDelete = unpackedNotesToDelete

            var unpackedNotesToUpdate = [String: Note]()
            if let packedNotesToUpdate = content["notesToUpdate"] {
                for packed in packedNotesToUpdate {
                    if let unpacked = unpackNote(packed) {
                        unpackedNotesToUpdate[unpacked.identifier] = unpacked
                    }
                }
            }
            notesToUpdate = unpackedNotesToUpdate
        }
    }

    private func changed() {
        save()
        delegate?.cacheChanged(self)
    }

    init() {
        load()
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

    func createNotebook(notebook: Notebook) -> Bool {
        notebooksByIdentifier[notebook.identifier] = notebook
        notebooksToCreate[notebook.identifier] = notebook
        changed()
        return true
    }

    func deleteNotebook(notebook: Notebook) -> Bool {
        if let _ = notebooksByIdentifier[notebook.identifier] {
            notebooksByIdentifier[notebook.identifier] = nil
            notebooksToDelete[notebook.identifier] = notebook
            for note in notes {
                if note.notebookIdentifier == notebook.identifier {
                    notesToDelete[note.identifier] = note
                }
            }
            changed()
            return true
        }
        return false
    }

    func updateNotebook(notebook: Notebook) -> Bool {
        if let _ = notebooksByIdentifier[notebook.identifier] {
            notebooksByIdentifier[notebook.identifier] = notebook
            notebooksToUpdate[notebook.identifier] = notebook
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
            for notebook in notebooksToCreate.values.array {
                newNotebooksByIdentifier[notebook.identifier] = notebook
            }
            for notebook in notebooksToDelete.values.array {
                if let _ = notebooksByIdentifier[notebook.identifier] {
                    newNotebooksByIdentifier[notebook.identifier] = nil
                }
            }
            for notebook in notebooksToUpdate.values.array {
                if let _ = notebooksByIdentifier[notebook.identifier] {
                    newNotebooksByIdentifier[notebook.identifier] = notebook
                }
            }
            notebooksByIdentifier = newNotebooksByIdentifier
            changed()
        }
    }

    func createNote(note: Note) -> Bool {
        notesByIdentifier[note.identifier] = note
        notesToCreate[note.identifier] = note
        changed()
        return true
    }

    func deleteNote(note: Note) -> Bool {
        if let existingNote = notesByIdentifier[note.identifier] {
            notesByIdentifier[note.identifier] = nil
            notesToDelete[note.identifier] = note
            changed()
            return true
        }
        return false
    }

    func updateNote(note: Note) -> Bool {
        if let existingNote = notesByIdentifier[note.identifier] {
            notesByIdentifier[note.identifier] = note
            notesToUpdate[note.identifier] = note
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
            for note in notesToCreate.values.array {
                newNotesByIdentifier[note.identifier] = note
            }
            for note in notesToDelete.values.array {
                if let _ = notesByIdentifier[note.identifier] {
                    newNotesByIdentifier[note.identifier] = nil
                }
            }
            for note in notesToUpdate.values.array {
                if let _ = notesByIdentifier[note.identifier] {
                    newNotesByIdentifier[note.identifier] = note
                }
            }
            notesByIdentifier = newNotesByIdentifier
            changed()
        }
    }

    var hasChanges: Bool {
        return notebooksToCreate.count > 0 ||
                notebooksToDelete.count > 0 ||
                notebooksToUpdate.count > 0 ||
                notesToCreate.count > 0 ||
                notesToDelete.count > 0 ||
                notesToUpdate.count > 0
    }

    var changes: ChangesEnvelope {
        let changes = ChangesEnvelope(notebooksToCreate: notebooksToCreate.values.array,
                notebooksToDelete: notebooksToDelete.values.array,
                notebooksToUpdate: notebooksToUpdate.values.array,
                notesToCreate: notesToCreate.values.array,
                notesToDelete: notesToDelete.values.array,
                notesToUpdate: notesToUpdate.values.array
        )
        return changes
    }

    func removeChanges(changes: ChangesEnvelope) {

        for notebook in changes.notebooksToCreate {
            notebooksToCreate[notebook.identifier] = nil
        }

        for notebook in changes.notebooksToDelete {
            notebooksToDelete[notebook.identifier] = nil
        }

        for notebook in changes.notebooksToUpdate {
            notebooksToUpdate[notebook.identifier] = nil
        }

        for note in changes.notesToCreate {
            notesToCreate[note.identifier] = nil
        }

        for note in changes.notesToDelete {
            notesToDelete[note.identifier] = nil
        }

        for note in changes.notesToUpdate {
            notesToUpdate[note.identifier] = nil
        }
    }

    func clear() {
        notebooksByIdentifier = [String: Notebook]()
        notesByIdentifier = [String: Note]()
        notebooksToCreate = [String: Notebook]()
        notebooksToDelete = [String: Notebook]()
        notebooksToUpdate = [String: Notebook]()
        notesToCreate = [String: Note]()
        notesToDelete = [String: Note]()
        notesToUpdate = [String: Note]()
        save()
        changed()
    }
}
