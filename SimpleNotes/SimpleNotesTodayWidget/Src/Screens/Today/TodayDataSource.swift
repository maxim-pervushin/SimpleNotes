//
// Created by Maxim Pervushin on 27/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class TodayDataSource {

    var changed: (() -> ())? {
        didSet {
            changed?()
        }
    }

    var favoriteNotes: [Note] {
        return DataManager.shared.favoriteNotes
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
