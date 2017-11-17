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
    
    func isUserDefined() -> Bool {
        if let cbi = UserDefaults.standard.string(forKey: "currentBrandId") {
            return true
        }
        else {
            return false
        }        
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
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "currentBrandId")
        defaults.set(nil, forKey: "userAccountJson")
    }
    
    static var currentBrandId: String {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "currentBrandId")
        }
        get {
            if let cbi = UserDefaults.standard.string(forKey: "currentBrandId") {
                return cbi
            }
            else {
                return ""
            }
        }
    }
    
    static var currentBrandName: String {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "currentBrandName")
        }
        get {
            if let cbi = UserDefaults.standard.string(forKey: "currentBrandName") {
                return cbi
            }
            else {
                return "Unset"
            }
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
    
    /*
     * On first time when user press add to task action should displayed transition
     * to Todo tab
     */
    static var didShowedTransitionAddToTask: Bool {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "didShowedTransitionAddToTask")
            
        }
        get {
            return UserDefaults.standard.bool(forKey: "didShowedTransitionAddToTask")
        }
    }
    
    /*
     * On first time when user approved a post from todo will show
     * that it goes to calendar
     */
    static var didShowedTransitionFromTodo: Bool {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "didShowedTransitionFromTodo")
        }
        get {
            return UserDefaults.standard.bool(forKey: "didShowedTransitionFromTodo")
        }
    }
 
    
    static var isNotificationsAllowed: Bool {
        get {
            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
            return notificationType == [] ? false : true
        }
    }
    
    
    static var brandIndex: Int  = 0
    static var overlayIndex: Int = 0
    
}

