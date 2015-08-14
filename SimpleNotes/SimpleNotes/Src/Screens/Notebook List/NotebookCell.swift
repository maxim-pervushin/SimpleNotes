//
// Created by Maxim Pervushin on 11/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class NotebookCell: UITableViewCell {

    static let defaultIdentifier = "NotebookCell"

    var notebook: Notebook? {
        didSet {
            if let notebook = notebook {
                textLabel?.text = notebook.name
                detailTextLabel?.text = notebook.identifier
            } else {
                textLabel?.text = ""
                detailTextLabel?.text = ""
            }
        }
    }
}
