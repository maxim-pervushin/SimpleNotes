//
// Created by Maxim Pervushin on 07/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import UIKit

class EditNoteViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var toggleFavoriteButton: UIBarButtonItem!
    @IBOutlet var textView: UITextView!

    @IBAction func toggleFavoriteButtonAction(sender: AnyObject) {
        if let isFavorite = validator.isFavorite {
            validator.isFavorite = !isFavorite
        } else {
            validator.isFavorite = true
        }
        updateUI()
    }

    var note: Note? {
        get {
            return validator.note
        }
        set {
            validator.originalNote = newValue
            validator.identifier = newValue?.identifier
            validator.text = newValue?.text
            validator.isFavorite = newValue?.isFavorite
            validator.notebookIdentifier = newValue?.notebookIdentifier
            updateUI()
        }
    }

    var notebook: Notebook? {
        didSet {
            validator.notebookIdentifier = notebook?.identifier
            updateUI()
        }
    }

    private let dataSource = EditNoteDataSource()
    private let validator = EditNoteValidator()

    private func updateUI() {
        if !isViewLoaded() {
            return
        }

        textView.text = validator.text

        if let isFavorite = validator.isFavorite {
            toggleFavoriteButton.image = UIImage(named: isFavorite ? "Star" : "StarEmpty")
        } else {
            toggleFavoriteButton.image = UIImage(named: "StarEmpty")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        // TODO: Move this logic to EditNoteValidator
        if validator.originalNote == validator.note {
        } else if validator.note != nil {
            if let note = validator.note {
                dataSource.saveNote(note)
            }
        } else {
            if let originalNote = validator.originalNote {
                dataSource.deleteNote(originalNote)
            }
        }
    }

    // MARK: - UITextViewDelegate

    func textViewDidChange(textView: UITextView) {
        validator.text = textView.text
    }
}
