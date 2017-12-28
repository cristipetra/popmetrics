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


class UserStore {

    static func getInstance() -> UserStore {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.usersStore
    }
    
    var phoneNumber: String = ""
    
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
    
    func getLocalUserSettings() -> UserSettings {
        let jsonString = UserDefaults.standard.string(forKey: "userSettingsJson")
        let userSettings = UserSettings(JSONString: jsonString!)
        return userSettings!
    }
    
    func storeLocalUserSettings(_ userSettings: UserSettings) {
        let defaults = UserDefaults.standard
        defaults.set(userSettings.toJSONString(), forKey: "userSettingsJson")
    }
    
    func clearCredentials() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "currentBrandId")
        defaults.set(nil, forKey: "userAccountJson")
    }
    
    
    static var currentBrand: Brand? {
        get {
            guard let jsonString = UserDefaults.standard.string(forKey: "currentBrandJson")
                else {
                    return nil
                }
            let brand = Brand(JSONString: jsonString)
            return brand!
        }
        
        set {
            guard let jsonString = newValue?.toJSONString()
                else { return }
            UserDefaults.standard.set(jsonString, forKey:"currentBrandJson")
            UserStore.currentBrandId = (newValue?.id!)!
        }
    }
    
    static var iosDeviceToken: String? {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "iosDeviceToken")
        }
        get {
            let cbi = UserDefaults.standard.string(forKey: "iosDeviceToken")
            return cbi
        }
    }
        
    static var iosDeviceName: String? {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "iosDeviceName")
            }
        get {
            let cbi = UserDefaults.standard.string(forKey: "iosDeviceName")
            return cbi
            }
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
  
    static var didAskedForAllowingNotification: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "didAskedForAllowingNotifications")
        }
        
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "didAskedForAllowingNotifications")
            
        }
    }
    

    static var overlayIndex: IndexPath = IndexPath(row: 0, section: 0)
    
}

