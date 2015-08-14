//
// Created by Maxim Pervushin on 07/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct Notebook: Equatable {

    let identifier: String
    let name: String

    init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }
}

func ==(lhs: Notebook, rhs: Notebook) -> Bool {
    return lhs.identifier == rhs.identifier
            && lhs.name == rhs.name
}
