//
//  User.swift
//  CogniChallenge-Will
//
//  Created by William Leahy on 2/5/19.
//  Copyright © 2019 William Leahy. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class User {
    // MARK: - Dev note - Singletons should not be used to manage state, in a normal case, I would use dependency injection; but this is quick and dirty. Singletons should really only be used to cache objects that are resource intensive to create, like NSFormatters
    
    
    static let authorizedUser = User()
    static let UserAuthorizedNotificationName = "UserAuthorizedNotification"
    
    private static let TokenKey = "UserToken"
    
    var authToken: String? {
        get {
            return KeychainWrapper.standard.string(forKey: User.TokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: User.TokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: User.TokenKey)
            }
        }
    }
    
    var UserIsLoggedIn: Bool {
        get {
            return authToken != nil
        }
    }
}
