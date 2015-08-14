//
// Created by Maxim Pervushin on 07/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate {

    func noteViewController(noteViewController: NoteViewController, createdNote note: Note)

    func noteViewController(noteViewController: NoteViewController, updatedNote note: Note)

    func noteViewController(noteViewController: NoteViewController, deletedNote note: Note)
}

class NoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var textView: UITextView!

    var delegate: NoteViewControllerDelegate?

    var note: Note? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        if isViewLoaded() {
            if let note = note {
                textView.text = note.text
            } else {
                textView.text = ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if let note = note {
            if !textView.text.isEmpty {
                if textView.text != note.text {
                    delegate?.noteViewController(self, updatedNote: Note(identifier: note.identifier, text: textView.text, notebookIdentifier: note.notebookIdentifier))
                }
            } else {
                delegate?.noteViewController(self, deletedNote: note)
            }
        } else {
            if !textView.text.isEmpty {
                delegate?.noteViewController(self, createdNote: Note(identifier: NSUUID().UUIDString, text: textView.text, notebookIdentifier: nil))
            }
        }
    }

    // MARK: - UITextViewDelegate

    func textViewDidChange(textView: UITextView) {

        title = "Nothing"
        if let note = note {
            if !textView.text.isEmpty {
                if textView.text != note.text {
                    title = "Update"
                }
            } else {
                title = "Delete"
            }
        } else {
            if !textView.text.isEmpty {
                title = "Create"
            }
        }
    }
}
