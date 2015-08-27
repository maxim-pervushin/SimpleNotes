//
//  TodayViewController.swift
//  SimpleNotesTodayWidget
//
//  Created by Maxim Pervushin on 25/08/15.
//  Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!

    private let dataSource = TodayDataSource()

    // MARK: - NCWidgetProviding

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        if isViewLoaded() {
            tableView.reloadData()
            tableViewHeightConstraint.constant = tableView.contentSize.height
            view.layoutIfNeeded()
        }

        completionHandler(NCUpdateResult.NewData)
    }

    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.favoriteNotes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteCell
        cell.note = dataSource.favoriteNotes[indexPath.row]
        return cell
    }

}
