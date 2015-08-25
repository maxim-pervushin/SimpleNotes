//
//  TodayViewController.swift
//  SimpleNotesTodayWidget
//
//  Created by Maxim Pervushin on 25/08/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var todayLabel: UILabel!
    private let dataSource = TodayDataSource()

    // MARK: - NCWidgetProviding

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        if isViewLoaded() {
           todayLabel.text = "Favorites: \(dataSource.favoriteNotes.count)"
        }

        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
}

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