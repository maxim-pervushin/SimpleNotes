//
// Created by Maxim Pervushin on 11/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class NotebookListDataSource {

    var changed: (() -> ())? {
        didSet {
            changed?()
        }
    }

    func createNotebookWithName(name: String) -> Bool {
        return DataManager.shared.createNotebook(Notebook(identifier: NSUUID().UUIDString, name: name))
    }

    func deleteNotebook(notebook: Notebook) -> Bool {
        return DataManager.shared.deleteNotebook(notebook)
    }

    func updateNotebook(notebook: Notebook) -> Bool {
        return DataManager.shared.updateNotebook(notebook)
    }

    var notebooksCount: Int {
        return DataManager.shared.notebooks.count
    }

    func notebookAtIndexPath(indexPath: NSIndexPath) -> Notebook {
        return DataManager.shared.notebooks[indexPath.row]
    }

    func clearCache() {
        DataManager.shared.clearCache()
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
