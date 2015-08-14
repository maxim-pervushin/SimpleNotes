//
// Created by Maxim Pervushin on 10/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct ChangesEnvelope {

    let notebooksToCreate: [Notebook]
    let notebooksToDelete: [Notebook]
    let notebooksToUpdate: [Notebook]
    let notesToCreate: [Note]
    let notesToDelete: [Note]
    let notesToUpdate: [Note]

    init(notebooksToCreate: [Notebook], notebooksToDelete: [Notebook], notebooksToUpdate: [Notebook], notesToCreate: [Note], notesToDelete: [Note], notesToUpdate: [Note]) {
        self.notebooksToCreate = notebooksToCreate
        self.notebooksToDelete = notebooksToDelete
        self.notebooksToUpdate = notebooksToUpdate
        self.notesToCreate = notesToCreate
        self.notesToDelete = notesToDelete
        self.notesToUpdate = notesToUpdate
    }

    func printDescription() {
        println("ChangesEnvelope:")
        print("\tnotebooksToCreate: ")
        for i in notebooksToCreate {
            print("'\(i.name)'")
        }
        println()

        print("\tnotebooksToDelete: ")
        for i in notebooksToDelete {
            print("'\(i.name)'")
        }
        println()

        print("\tnotebooksToUpdate: ")
        for i in notebooksToUpdate {
            print("'\(i.name)'")
        }
        println()

        print("\tnotesToCreate: ")
        for i in notesToCreate {
            print("'\(i.text)'")
        }
        println()

        print("\tnotesToDelete: ")
        for i in notesToDelete {
            print("'\(i.text)'")
        }
        println()

        print("\tnotesToUpdate: ")
        for i in notesToUpdate {
            print("'\(i.text)'")
        }
        println()
    }
}
