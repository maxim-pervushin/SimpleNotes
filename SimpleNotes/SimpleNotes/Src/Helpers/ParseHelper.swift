//
// Created by Maxim Pervushin on 11/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Parse

extension Parse {

    private static let applicationId = "wTVLsEA3GGCKokahZCf5ANwDZnzTOoG7uumRzebf"
    private static let clientKey = "UIvzQ7l1bINgWErjfx9SeprodWq7S2U97cKBGapY"
    private static var onceToken: dispatch_once_t = 0

    static var authenticated: Bool {
        checkEnabled()
        return PFUser.currentUser() != nil
    }

    static func checkEnabled() {
        dispatch_once(&onceToken) {
            Parse.enableLocalDatastore()
            Parse.setApplicationId(self.applicationId, clientKey: self.clientKey)
        }
    }

    static func logOut() {
        PFUser.logOut()
    }
}
