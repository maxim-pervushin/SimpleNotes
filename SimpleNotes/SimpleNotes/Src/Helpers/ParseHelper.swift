//
// Created by Maxim Pervushin on 11/08/15.
// Copyright (c) 2015 Maxim Pervushin. All rights reserved.
//

import Parse

extension Parse {

    // TODO: Set Parse application id here 
    private static let applicationId = ""
    // TODO: Set Parse client key here 
    private static let clientKey = ""

    static var authenticated: Bool {
        return PFUser.currentUser() != nil
    }

    static func checkEnabled() {
        Parse.setApplicationId(applicationId, clientKey: clientKey)
    }

    static func logOut() {
        PFUser.logOut()
    }
}
