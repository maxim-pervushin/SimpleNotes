//
// Created by Maxim Pervushin on 10/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

protocol CacheDelegate {
    func cacheChanged(cache: Cache)
}

protocol Cache {

    var delegate: CacheDelegate? { get set }

    func createNotebook(notebook: Notebook) -> Bool

    func deleteNotebook(notebook: Notebook) -> Bool

    func updateNotebook(notebook: Notebook) -> Bool

    var notebooks: [Notebook] { get set }

    func createNote(note: Note) -> Bool

    func deleteNote(note: Note) -> Bool

    func updateNote(note: Note) -> Bool

    var notes: [Note] { get set }

    var hasChanges: Bool { get }

    var changes: ChangesEnvelope { get }

    func removeChanges(changes: ChangesEnvelope)

    func clear()
}
