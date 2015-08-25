//
// Created by Maxim Pervushin on 07/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct Note: Equatable {

    let identifier: String
    let text: String
    let isFavorite: Bool
    let notebookIdentifier: String?

    init(identifier: String, text: String, isFavorite: Bool, notebookIdentifier: String? = nil) {
        self.identifier = identifier
        self.isFavorite = isFavorite
        self.text = text
        self.notebookIdentifier = notebookIdentifier
    }
}

func ==(lhs: Note, rhs: Note) -> Bool {
    return lhs.identifier == rhs.identifier
            && lhs.text == rhs.text
            && lhs.isFavorite == rhs.isFavorite
            && lhs.notebookIdentifier == rhs.notebookIdentifier
}
