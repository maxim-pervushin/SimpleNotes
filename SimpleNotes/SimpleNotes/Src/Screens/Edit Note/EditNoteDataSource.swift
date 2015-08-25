//
// Created by Maxim Pervushin on 25/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class EditNoteDataSource {

    func saveNote(note: Note) -> Bool {
        return DataManager.shared.saveNote(note)
    }

    func deleteNote(note: Note) -> Bool {
        return DataManager.shared.deleteNote(note)
    }
}
