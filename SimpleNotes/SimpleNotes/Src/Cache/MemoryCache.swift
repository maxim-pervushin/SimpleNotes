//
// Created by Maxim Pervushin on 07/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class MemoryCache: Cache {

    // MARK: - MemoryCache

    private var notebooksByIdentifier = [String: Notebook]()
    private var notesByIdentifier = [String: Note]()
    private var notebooksToCreate = [String: Notebook]()
    private var notebooksToDelete = [String: Notebook]()
    private var notebooksToUpdate = [String: Notebook]()
    private var notesToCreate = [String: Note]()
    private var notesToDelete = [String: Note]()
    private var notesToUpdate = [String: Note]()
    private var privateDelegate: CacheDelegate?

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
        delegate?.cacheChanged(self)
        return true
    }

    func deleteNotebook(notebook: Notebook) -> Bool {
        if let _ = notebooksByIdentifier[notebook.identifier] {
            notebooksByIdentifier[notebook.identifier] = nil
            notebooksToDelete[notebook.identifier] = notebook
            delegate?.cacheChanged(self)
            return true
        }
        return false
    }

    func updateNotebook(notebook: Notebook) -> Bool {
        if let _ = notebooksByIdentifier[notebook.identifier] {
            notebooksByIdentifier[notebook.identifier] = notebook
            notebooksToUpdate[notebook.identifier] = notebook
            delegate?.cacheChanged(self)
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
        }
    }

    func createNote(note: Note) -> Bool {
        notesByIdentifier[note.identifier] = note
        notesToCreate[note.identifier] = note
        delegate?.cacheChanged(self)
        return true
    }

    func deleteNote(note: Note) -> Bool {
        if let existingNote = notesByIdentifier[note.identifier] {
            notesByIdentifier[note.identifier] = nil
            notesToDelete[note.identifier] = note
            delegate?.cacheChanged(self)
            return true
        }
        return false
    }

    func updateNote(note: Note) -> Bool {
        if let existingNote = notesByIdentifier[note.identifier] {
            notesByIdentifier[note.identifier] = note
            notesToUpdate[note.identifier] = note
            delegate?.cacheChanged(self)
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
        delegate?.cacheChanged(self)
    }
}
