//
//  RequiredActionHandler.swift
//  ipopmetrics
//
//  Created by Rares Pop on 18/05/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import TwitterKit
import FacebookCore
import FacebookLogin
import NotificationBannerSwift
import EZAlertController
import ObjectMapper


protocol InfoButtonDelegate {
    func sendInfo(_ sender: UIButton)
}


class RequiredActionHandler: NSObject, CardActionHandler, GIDSignInUIDelegate, GIDSignInDelegate {
   
    static func sharedInstance() -> RequiredActionHandler {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.requiredActionHandler
    }
    
    func  handleRequiredAction(_ item: FeedCard) {
        
        switch(item.name) {
            case "ganalytics.connect_with_brand":
                connectGoogleAnalytics(item)
            
            case "twitter.connect_with_brand":
                connectTwitter(item)
            
            case "facebook.connect_with_brand":
                connectFacebook(item)
            
            default:
                print("Unexpected name "+item.name)
        
        }//switch
    }
   
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
   func connectGoogleAnalytics(_ item:FeedCard?) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "850179116799-12c7gg09ar5eo61tvkhv21iisr721fqm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "850179116799-024u4fn5ddmkm3dnius3fq3l1gs81toi.apps.googleusercontent.com"
    
        let driveScope = "https://www.googleapis.com/auth/analytics.readonly"
        GIDSignIn.sharedInstance().scopes = [driveScope]
        GIDSignIn.sharedInstance().signOut()
    
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let _ = error {
            
            let notificationObj = ["alert":"Failed to connect with Google Analytics.",
                                   "subtitle":"No credentials have been provided",
                                   "type": "failure",
                                   "sound":"default"
                                   ]
            let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
            
            NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
                                            userInfo: pnotification.toJSON())
            return
        }
        
        let notificationObj = ["alert":"Connecting to Google Analytics.",
                               "subtitle":"Your credentials will be validated in relation with the tracker used in your site.",
                               "type": "info",
                               "sound":"default"
        ]
        let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
        NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
                                        userInfo: pnotification.toJSON())
        
        let brandId = UserStore.currentBrandId
        
        let params = [
            "task_name": "ganalytics.connect_with_brand",
            "user_id": UserStore().getLocalUserAccount().id,
            "client_id":GIDSignIn.sharedInstance().clientID,
            "token":user.authentication.idToken,
            "access_token": user.authentication.accessToken,
            "refresh_token": user.authentication.refreshToken,
            "server_auth_code": user.serverAuthCode,
            "scopes": GIDSignIn.sharedInstance().scopes
            ] as [String : Any]
        
        
        TodoApi().postRequiredAction(brandId, params: params) { requiredActionResponse in
            let store = FeedStore.getInstance()
            if let card = store.getFeedCardWithName("ganalytics.connect_with_brand") {
                store.updateCardSection(card, section: "None")
                NotificationCenter.default.post(name:Notification.Popmetrics.UiRefreshRequired, object:nil,
                                                userInfo: nil )
                NotificationCenter.default.post(name:Notification.Popmetrics.RequiredActionComplete, object:nil,
                                                userInfo: nil )
            }
        } // usersApi.logInWithGoogle()
    }
        
    
    func connectTwitter(_ item:FeedCard?) {
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            if (session != nil) {
                let notificationObj = ["alert":"Connecting to Twitter.",
                                       "subtitle":"Your credentials will be validated while establishing the connection.",
                                       "type": "info",
                                       "sound":"default"
                ]
                let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                
                NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
                                                userInfo: pnotification.toJSON())
                
                let params = [
                    "task_name": "twitter.connect_with_brand",
                    "user_id":UserStore.getInstance().getLocalUserAccount().id,
                    "twitter_user_id":session?.userID,
                    "access_token":session?.authToken,
                    "access_token_secret":session?.authTokenSecret
                    ]
                let brandId = UserStore.currentBrandId
                TodoApi().postRequiredAction(brandId, params: params) { requiredActionResponse in
                    let store = FeedStore.getInstance()
                    if let card = store.getFeedCardWithName("twitter.connect_with_brand") {
                        store.updateCardSection(card, section: "None")
                        NotificationCenter.default.post(name:Notification.Popmetrics.UiRefreshRequired, object:nil,
                                                        userInfo: nil )
                    }
                    NotificationCenter.default.post(name:Notification.Popmetrics.RequiredActionComplete, object:nil,
                                                    userInfo: nil )
                }
                
            } else {
                let notificationObj = ["alert":"Failed to connect with Twitter.",
                                       "subtitle":"None or bad credentials have been provided.",
                                       "type": "failure",
                                       "sound":"default"
                ]
                let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                
                NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
                                                userInfo: pnotification.toJSON())
                return
                
            }
        }
        
    }

    
    
    // MARK: Facebook LogIn Process
    func connectFacebook(_ item:FeedCard?) {
        let loginManager = LoginManager()
        let readPermissions = [ReadPermission.publicProfile, ReadPermission.email, ReadPermission.pagesShowList]
        let publishPermissions = [PublishPermission.managePages, PublishPermission.publishPages]
        
        loginManager.logOut()
        loginManager.logIn(readPermissions:readPermissions, viewController: nil) { result in
            switch result {
                case LoginResult.failed(let error):
                    let notificationObj = ["alert":"Failed to connect with Facebook.",
                                           "subtitle":"bad credentials have been provided.",
                                           "type": "failure",
                                           "sound":"default"
                    ]
                    let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                    
                    NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
                                                    userInfo: pnotification.toJSON())
                case LoginResult.cancelled:
                    let notificationObj = ["alert":"Failed to connect with Facebook.",
                                           "subtitle":"Authentication has been canceled.",
                                           "type": "failure",
                                           "sound":"default"
                    ]
                    let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                    
                    NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
                                                    userInfo: pnotification.toJSON())
                
                case LoginResult.success(let grantedPermissions, let declinedPermissions, let accessToken):
                    let notificationObj = ["alert":"Connecting to Facebook.",
                                           "subtitle":"Your credentials will be validated while establishing the connection.",
                                           "type": "info",
                                           "sound":"default"
                    ]
                    let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                    
                    NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
                                                    userInfo: pnotification.toJSON())
                    let params = [
                        "task_name": "facebook.connect_with_brand",
                        "access_token": accessToken.authenticationToken
                    ]
                    let brandId = UserStore.currentBrandId
                    TodoApi().postRequiredAction(brandId, params: params) { requiredActionResponse in
                        NotificationCenter.default.post(name:Notification.Popmetrics.RequiredActionComplete, object:nil,
                                                        userInfo: nil )
                        let store = FeedStore.getInstance()
                        if let card = store.getFeedCardWithName("facebook.connect_with_brand") {
                            store.updateCardSection(card, section: "None")
                            NotificationCenter.default.post(name:Notification.Popmetrics.UiRefreshRequired, object:nil,
                                                            userInfo: nil )
                        }
                    }
                    
                }
        }
        

//        loginManager.logIn(publishPermissions:publishPermissions, viewController: self.homeHubViewController) { result in
//            switch result {
//            case LoginResult.failed(let error):
//                print("failed")
//            case LoginResult.cancelled:
//                print("cancelled")
//            case LoginResult.success(let grantedPermissions, let declinedPermissions, let accessToken):
//                print("thank you")
//            }
//        }

        
    }
    
}
