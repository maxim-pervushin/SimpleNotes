//
// Created by Maxim Pervushin on 10/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation
import Parse

class ParseStorage: Storage {

    // MARK: - ParseStorageProvider

    private let notebookClassName = "Notebook"
    private let noteClassName = "Note"

    private func packNotebook(notebook: Notebook) -> PFObject? {
        if let currentUser = PFUser.currentUser() {
            var object = PFObject(className: notebookClassName)
            // Try to get existing object with identifier
            let query = PFQuery(className: notebookClassName)
            query.whereKey("identifier", equalTo: notebook.identifier)
            query.whereKey("user", equalTo: currentUser)
            if let fetched = query.getFirstObject() {
                object = fetched
            }
            object["identifier"] = notebook.identifier
            object["name"] = notebook.name
            object["user"] = currentUser
            return object
        }
        return nil
    }

    private func packNote(note: Note) -> PFObject? {
        if let currentUser = PFUser.currentUser() {
            var object = PFObject(className: noteClassName)
            // Try to get existing object with identifier
            let query = PFQuery(className: noteClassName)
            query.whereKey("identifier", equalTo: note.identifier)
            query.whereKey("user", equalTo: currentUser)
            if let fetched = query.getFirstObject() {
                object = fetched
            }
            object["identifier"] = note.identifier
            object["text"] = note.text
            object["isFavorite"] = note.isFavorite ? "true" : "false"
            if let notebookIdentifier = note.notebookIdentifier {
                object["notebookIdentifier"] = notebookIdentifier
            } else {
                object["notebookIdentifier"] = ""
            }
            object["user"] = currentUser
            return object
        }
        return nil
    }

    private func unpackNotebook(object: PFObject) -> Notebook? {
        if let
        identifier = object["identifier"] as? String,
        name = object["name"] as? String {
            return Notebook(identifier: identifier, name: name)
        }
        return nil
    }

    private func unpackNote(object: PFObject) -> Note? {
        if let
        identifier = object["identifier"] as? String,
        text = object["text"] as? String,
        isFavoriteString = object["isFavorite"] as? String {
            return Note(identifier: identifier, text: text, isFavorite: isFavoriteString == "true" ? true : false, notebookIdentifier: object["notebookIdentifier"] as? String)
        }
        return nil
    }

    // MARK: - Object

    init() {
        Parse.checkEnabled()
    }

    // MARK: - StorageProvider

    var available: Bool {
        return Parse.authenticated
    }

    func postChanges(changes: ChangesEnvelope) -> Bool {
        if !available {
            return false
        }

        var objectsToSave = [PFObject]()
        var objectsToDelete = [PFObject]()

        for (_, i) in changes.notebooksChanges.toSave {
            if let object = packNotebook(i) {
                objectsToSave.append(object)
            }
        }

        for (_, i) in changes.notebooksChanges.toDelete {
            if let object = packNotebook(i) {
                objectsToDelete.append(object)
            }
        }

        for (_, i) in changes.notesChanges.toSave {
            if let object = packNote(i) {
                objectsToSave.append(object)
            }
        }

        for (_, i) in changes.notesChanges.toDelete {
            if let object = packNote(i) {
                objectsToDelete.append(object)
            }
        }

        var result = true

        result = result && PFObject.saveAll(objectsToSave)
        result = result && PFObject.deleteAll(objectsToDelete)

        return result
    }

    func getData() -> DataEnvelope? {
        if let currentUser = PFUser.currentUser() {

            var unpackedNotebooks = [Notebook]()
            let notebooksQuery = PFQuery(className: notebookClassName)
            notebooksQuery.whereKey("user", equalTo: currentUser)
            if let packedNotebooks = notebooksQuery.findObjects() as? [PFObject] {
                for packedNotebook in packedNotebooks {
                    if let unpackedNotebook = unpackNotebook(packedNotebook) {
                        unpackedNotebooks.append(unpackedNotebook)
                    }
                }
            }

            var unpackedNotes = [Note]()
            let notesQuery = PFQuery(className: noteClassName)
            notesQuery.whereKey("user", equalTo: currentUser)
            if let packedNotes = notesQuery.findObjects() as? [PFObject] {
                for packedNote in packedNotes {
                    if let unpackedNote = unpackNote(packedNote) {
                        unpackedNotes.append(unpackedNote)
                    }
                }
            }

            return DataEnvelope(notebooks: unpackedNotebooks, notes: unpackedNotes)
        }

        return nil
    }
}
