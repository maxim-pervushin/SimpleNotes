//
// Created by Maxim Pervushin on 11/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    var note: Note? {
        didSet {
            if let note = note {
                textLabel?.text = note.text
                detailTextLabel?.text = note.identifier
            } else {
                textLabel?.text = ""
                detailTextLabel?.text = ""
            }
        }
    }
}
