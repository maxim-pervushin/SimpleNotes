//
// Created by Maxim Pervushin on 07/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class NoteListViewController: UITableViewController {

    var notebook: Notebook? {
        didSet {
            dataSource.notebook = notebook
            if let notebook = notebook {
                title = notebook.name
            } else {
                title = ""
            }
        }
    }

    private let dataSource = NoteListDataSource()

    private func dataSourceChanged() {
        tableView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let
        noteViewController = segue.destinationViewController as? EditNoteViewController {
            noteViewController.notebook = notebook
            if let indexPath = tableView.indexPathForSelectedRow() {
                noteViewController.note = dataSource.notes[indexPath.row]
            }
        }
        super.prepareForSegue(segue, sender: sender)
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.notes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteCell
        cell.note = dataSource.notes[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete", handler: deleteActionHandler)
        deleteAction.backgroundColor = UIColor.redColor()
        return [deleteAction]
    }

    func deleteActionHandler(action: UITableViewRowAction!, indexPath: NSIndexPath!) {
        let note = dataSource.notes[indexPath.row]
        let alertController = UIAlertController(title: "Notes", message: "Delete \(note.text)", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {
            (action) in
            self.dataSource.deleteNote(note)
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changed = dataSourceChanged
    }
}
