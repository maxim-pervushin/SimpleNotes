//
// Created by Maxim Pervushin on 10/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct ChangesEnvelope {

    let notebooksChanges: Changes<Notebook>
    let notesChanges: Changes<Note>

    init(notebooksChanges: Changes<Notebook>, notesChanges: Changes<Note>) {
        self.notebooksChanges = notebooksChanges
        self.notesChanges = notesChanges
    }

    func printDescription() {
        println("ChangesEnvelope:")
        print("\tnotebooksToDelete: ")
        for i in notebooksChanges.toDelete.values.array {
            print("'\(i.name)'")
        }
        println()

        print("\tnotebooksToSave: ")
        for i in notebooksChanges.toSave.values.array {
            print("'\(i.name)'")
        }
        println()

        print("\tnotesToDelete: ")
        for i in notesChanges.toDelete.values.array {
            print("'\(i.text)'")
        }
        println()

        print("\tnotesToSave: ")
        for i in notesChanges.toSave.values.array {
            print("'\(i.text)'")
        }
        println()
    }
}
