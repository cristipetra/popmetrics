//
//  UsersStore.swift
//  Popmetrics
//
//  Created by Rares Pop
//  Copyright © 2016 Popmetrics. All rights reserved.
//

import UIKit
import CoreData

class UsersStore: Store {
    
    static func getInstance() -> UsersStore {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.usersStore
    }
    
    func getLocalUserInstance() -> LocalUser? {
        if let fetchRequest: NSFetchRequest<LocalUser> = createFetchRequest() {
            if let result = executeFetchRequest(fetchRequest: fetchRequest) {
                return result.first
            }
        }
        return nil
    }
    
    func hasCredentials() -> Bool {
        return (getLocalUserInstance() != nil)
    }
    
    func createCredentials(userID: String, authToken: String,
                           name: String? = nil,
                           email: String? = nil,
                           imageURL: String? = nil,
                           uploadOnlyOnWiFi: Bool = false) -> LocalUser {
        // Make sure to remove the existing user first
        clearCredentials()
        let user = createEntityWithName("LocalUser") as! LocalUser
        user.id = userID
        user.authToken = authToken
        user.name = name
        user.email = email
        user.imageURL = imageURL
        user.uploadOnlyOnWiFi = NSNumber(value: uploadOnlyOnWiFi)
        return user
    }
    
    func getCredentials() -> LocalUser? {
        return getLocalUserInstance()
    }
    
    func clearCredentials() {
        if let localUser = getLocalUserInstance() {
            context.delete(localUser)
        }
    }
}
