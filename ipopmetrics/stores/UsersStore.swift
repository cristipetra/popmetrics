//
//  UsersStore.swift
//  ipopmetrics
//
//  Created by Rares Pop on 09/06/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class User {
    var id: String!
    var name: String!
    var email: String!
    var authToken: String!
    
}

class UsersStore {

    static func getInstance() -> UsersStore {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.usersStore
    }
    
    func getLocalUser() -> User {
        let user = User()
        user.name = UserDefaults.standard.string(forKey:"userName")
        user.email = UserDefaults.standard.string(forKey:"userEmail")
        user.id = UserDefaults.standard.string(forKey:"userId")
        user.authToken = UserDefaults.standard.string(forKey:"userAuthToken")
        return user
    }
    
    func storeLocalUser(_ user:User) {
        let defaults = UserDefaults.standard
        defaults.set(user.name, forKey: "userName")
        defaults.set(user.email, forKey: "userEmail")
        defaults.set(user.id, forKey: "userId")
        defaults.set(user.authToken, forKey:"userAuthToken")
        
    }
    
    func clearCredentials() {
        
    }
    
    static var isTwitterConnected: Bool {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "isTwitterConnected")
        }
        get {
            return UserDefaults.standard.bool(forKey: "isTwitterConnected")
        }
    }
    
}
