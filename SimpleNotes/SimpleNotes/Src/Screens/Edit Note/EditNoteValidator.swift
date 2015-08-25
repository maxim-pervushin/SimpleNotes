//
// Created by Maxim Pervushin on 25/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

// TODO: rename to EditNoteLogic?
class EditNoteValidator {

    var identifier: String?
    var text: String?
    var isFavorite: Bool?
    var notebookIdentifier: String?
    var originalNote: Note?

    var note: Note? {
        if let text = text {
            // There is no note if note.text is empty.
            if text.isEmpty {
                return nil
            }

            // Generate new identifier if identifier missing.
            var id = NSUUID().UUIDString
            if let identifier = identifier {
                id = identifier
            }

            var isFav = false
            if let isFavorite = isFavorite {
                isFav = isFavorite
            }

            return Note(identifier: id, text: text, isFavorite: isFav, notebookIdentifier: notebookIdentifier)
        }

        return nil
    }
}
