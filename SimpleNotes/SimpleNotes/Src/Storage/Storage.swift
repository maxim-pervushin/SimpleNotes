//
// Created by Maxim Pervushin on 10/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Foundation

protocol Storage {

    var available: Bool { get }

    func postChanges(changes: ChangesEnvelope) -> Bool

    func getData() -> DataEnvelope?
}
