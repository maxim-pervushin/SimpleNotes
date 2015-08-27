//
// Created by Maxim Pervushin on 27/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet private weak var noteTextLabel: UILabel!

    var note: Note? {
        didSet {
            if let note = note {
                noteTextLabel.text = note.text
            } else {
                noteTextLabel.text = ""
            }
        }
    }
}
