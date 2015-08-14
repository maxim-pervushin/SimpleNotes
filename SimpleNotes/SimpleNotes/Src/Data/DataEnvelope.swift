//
// Created by Maxim Pervushin on 10/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

class DataEnvelope {

    let notebooks: [Notebook]
    let notes: [Note]

    init(notebooks: [Notebook], notes: [Note]) {
        self.notebooks = notebooks
        self.notes = notes
    }

    func printDescription() {
        println("DataEnvelope:")
        print("\tnotebooks: ")
        for i in notebooks {
            print("'\(i.name)'")
        }
        println()

        print("\tnotes: ")
        for i in notes {
            print("'\(i.text)'")
        }
        println()
    }
}
