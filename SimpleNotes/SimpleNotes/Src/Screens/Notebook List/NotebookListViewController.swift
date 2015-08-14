//
// Created by Maxim Pervushin on 07/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit
import Parse

class NotebookListViewController: UITableViewController, UITableViewDataSource {

    // MARK: - NotebookListViewController @IB

    @IBOutlet weak var authenticationButton: UIBarButtonItem!

    @IBAction func authenticationButtonAction(sender: AnyObject) {
        if Parse.authenticated {
            Parse.logOut()

            // Ask user if we should to delete all cached data
            let alertController = UIAlertController(title: "Notebooks", message: "Delete local content?", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Keep", style: .Cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {
                (action) in
                self.dataSource.clearCache()
            }))
            presentViewController(alertController, animated: true, completion: nil)

            updateUI()
        } else {
            if let rootNavigationController = navigationController as? RootNavigationController {
                rootNavigationController.logIn()
            }
        }
    }

    @IBAction func addNotebookButtonAction(sender: AnyObject?) {
        let alertController = UIAlertController(title: "Notebooks", message: "Create New Notebook", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Create", style: .Default, handler: {
            (action) in
            if let textField = alertController.textFields?[0] as? UITextField {
                self.dataSource.createNotebookWithName(textField.text)
            }
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - NotebookListViewController

    private let dataSource = NotebookListDataSource()

    private func updateUI() {
        if !isViewLoaded() {
            // Nothing to update. View is not loaded yet
            return
        }

        if Parse.authenticated {
            authenticationButton.title = "Log Out"
        } else {
            authenticationButton.title = "Log In"
        }
    }

    private func dataSourceChanged() {
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.notebooksCount
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NotebookCell.defaultIdentifier, forIndexPath: indexPath) as! NotebookCell
        cell.notebook = dataSource.notebookAtIndexPath(indexPath)
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
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit", handler: editActionHandler)
        editAction.backgroundColor = UIColor.blueColor()
        return [deleteAction, editAction]
    }

    func editActionHandler(action: UITableViewRowAction!, indexPath: NSIndexPath!) {
        let notebook = dataSource.notebookAtIndexPath(indexPath)
        let alertController = UIAlertController(title: "Notebooks", message: "Rename \(notebook.name)", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Rename", style: .Default, handler: {
            (action) in
            if let textField = alertController.textFields?[0] as? UITextField {
                self.dataSource.updateNotebook(Notebook(identifier: notebook.identifier, name: textField.text))
            }
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }

    func deleteActionHandler(action: UITableViewRowAction!, indexPath: NSIndexPath!) {
        let notebook = dataSource.notebookAtIndexPath(indexPath)
        let alertController = UIAlertController(title: "Notebooks", message: "Delete \(notebook.name)", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {
            (action) in
            self.dataSource.deleteNotebook(notebook)
        }))
        presentViewController(alertController, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let
        noteListViewController = segue.destinationViewController as? NoteListViewController,
        indexPath = tableView.indexPathForSelectedRow() {
            noteListViewController.notebook = dataSource.notebookAtIndexPath(indexPath)
        }
        super.prepareForSegue(segue, sender: sender)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.changed = dataSourceChanged
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
}
