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
    
    func getLocalUserAccount() -> UserAccount {

        let jsonString = UserDefaults.standard.string(forKey: "userAccountJson")
        let userAccount = UserAccount(JSONString: jsonString!)
        return userAccount!
        
    }
    
    func storeLocalUserAccount(_ user: UserAccount) {
        let defaults = UserDefaults.standard
        defaults.set(user.toJSONString(), forKey:"userAccountJson")
    }
    
    
    func clearCredentials() {
        
    }
    
    static var currentBrandId: String {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "currentBrandId")
        }
        get {
            return UserDefaults.standard.string(forKey: "currentBrandId")!
        }
    }

    
    
    static var isTwitterConnected: Bool {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "isTwitterConnected")
            NotificationCenter.default.post(name: Notification.Name("didChangeTwitterConnected"), object: nil);
        }
        get {
            return UserDefaults.standard.bool(forKey: "isTwitterConnected")
        }
    }
    
    static var isInsightShowed: Bool {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "isDisplayedInsight")
            
        }
        get {
            //return false
            return UserDefaults.standard.bool(forKey: "isDisplayedInsight")
        }
    }
 
    
    static var isNotificationsAllowed: Bool {
        get {
            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
            return notificationType == [] ? false : true
        }
    }
    
}

