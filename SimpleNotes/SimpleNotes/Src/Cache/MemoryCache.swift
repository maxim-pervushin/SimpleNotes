//
// Created by Maxim Pervushin on 07/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class MemoryCache: Cache {

    // MARK: - MemoryCache

    private var notebooksByIdentifier = [String: Notebook]()
    private var notesByIdentifier = [String: Note]()
    private var notebooksChanges = Changes<Notebook>()
    private var notesChanges = Changes<Note>()
    private var privateDelegate: CacheDelegate?

    private func changed() {
        delegate?.cacheChanged(self)
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
        changed()
    }
}
