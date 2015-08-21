//
// Created by Maxim Pervushin on 11/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class NoteListDataSource {

    var changed: (() -> ())? {
        didSet {
            changed?()
        }
    }

    var notebook: Notebook? {
        didSet {
            changed?()
        }
    }

    func saveNote(note: Note) -> Bool {
        return DataManager.shared.saveNote(note)
    }

    func deleteNote(note: Note) -> Bool {
        return DataManager.shared.deleteNote(note)
    }

    var notes: [Note] {
        if let notebook = notebook {
            return DataManager.shared.notes.filter {
                (note: Note) -> Bool in
                return note.notebookIdentifier == notebook.identifier
            }
        } else {
            return DataManager.shared.notes
        }
    }

    private func subscribe() {
        NSNotificationCenter.defaultCenter().addObserverForName(DataManager.changedNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
            (_: NSNotification!) -> Void in
            self.changed?()
        }
    }

    private func unsubscribe() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DataManager.changedNotification, object: nil)
    }

    init() {
        subscribe()
    }

    deinit {
        unsubscribe()
    }
}
