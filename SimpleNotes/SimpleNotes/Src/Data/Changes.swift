//
// Created by Maxim Pervushin on 20/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

struct Changes<T> {

    var toSave = [String: T]()
    var toDelete = [String: T]()

    var hasChanges: Bool {
        return toSave.count > 0 || toDelete.count > 0
    }
}
