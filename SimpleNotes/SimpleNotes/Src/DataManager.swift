//
// Created by Maxim Pervushin on 07/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class DataManager: CacheDelegate {

    static let shared = DataManager()
    static let changedNotification = "DataManagerChangedNotification"

    private var timer: NSTimer?
    private var postChangesRunning: Bool = false

    private var nextGetIn: Int = 0
    private let defaultGetInterval = 15
    private let failureGetInterval = 2

    private let storageProvider = ParseStorage()
    private let cacheProvider = PlistCache()

    private func changed() {
        NSNotificationCenter.defaultCenter().postNotificationName(DataManager.changedNotification, object: self)
    }

    private func postChanges() {
        if !storageProvider.available {
            return
        }
        if postChangesRunning {
            return
        } else {
            postChangesRunning = true
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            () -> Void in
            if self.cacheProvider.hasChanges {
                let startDate = NSDate()
                let changes = self.cacheProvider.changes
                println("Posting changes:")
                changes.printDescription()
                let postSucceed = self.storageProvider.postChanges(changes)
                if postSucceed {
                    self.cacheProvider.removeChanges(changes)
                    println("Posted changes in \(NSDate().timeIntervalSinceDate(startDate))")
                } else {
                    println("Posting changes failed")
                }
            }

            self.postChangesRunning = false
        })
    }

    private func getData() {
        if !storageProvider.available {
            return
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            () -> Void in

            if self.nextGetIn == 0 {
                self.nextGetIn = Int.max
                let startDate = NSDate()
                println("Getting data...")
                if let dataEnvelope = self.storageProvider.getData() {
                    self.cacheProvider.notebooks = dataEnvelope.notebooks
                    self.cacheProvider.notes = dataEnvelope.notes
                    self.changed()
                    self.nextGetIn = self.defaultGetInterval
                    println("Got data in \(NSDate().timeIntervalSinceDate(startDate))")
                    dataEnvelope.printDescription()
                } else {
                    self.nextGetIn = self.failureGetInterval
                    println("Getting data failed")
                }
            }
            self.nextGetIn--
        })
    }

    @objc private func timeout() {
        postChanges()
        getData()
    }

    init() {
        cacheProvider.delegate = self
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timeout"), userInfo: nil, repeats: true)
        timer!.fire()
    }

    // MARK: - CacheDelegate

    func cacheChanged(cache: Cache) {
        changed()
    }
}

extension DataManager {

    func saveNotebook(notebook: Notebook) -> Bool {
        return cacheProvider.saveNotebook(notebook)
    }

    func deleteNotebook(notebook: Notebook) -> Bool {
        return cacheProvider.deleteNotebook(notebook)
    }

    var notebooks: [Notebook] {
        return cacheProvider.notebooks
    }

    func saveNote(note: Note) -> Bool {
        return cacheProvider.saveNote(note)
    }

    func deleteNote(note: Note) -> Bool {
        return cacheProvider.deleteNote(note)
    }

    var notes: [Note] {
        return cacheProvider.notes
    }

    var favoriteNotes: [Note] {
        return cacheProvider.favoriteNotes
    }

    func clearCache() {
        cacheProvider.clear()
    }
}