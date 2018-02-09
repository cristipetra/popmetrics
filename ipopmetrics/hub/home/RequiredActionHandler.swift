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
import SwiftyJSON

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
                //connectFacebook(item)
                break
            
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
            let notificationObj = ["title":"Failed to connect with Google Analytics.",
                                   "subtitle":"No credentials have been provided",
                                   "type": "info",
                                   "sound":"default"
                                   ]
            let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
            
//            NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
//                                            userInfo: pnotification.toJSON())
            return
        }
        
        let notificationObj = ["title": "Connecting Google Analytics.",
                               "subtitle":"This may take a few minutes.",
                               "type": "success",
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
                let notificationObj = ["title": "Twitter successfully connected!",
                                       "subtitle":"Automated social posting now available.",
                                       "type": "success",
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
                let notificationObj = ["title":"Failed to connect with Twitter.",
                                       "subtitle":"None or bad credentials have been provided.",
                                       "type": "failure",
                                       "sound":"default"
                ]
                let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                
//                NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
//                                                userInfo: pnotification.toJSON())
                return
                
            }
        }
        
    }
    
    // MARK: Disconnect twitter
    func disconnectTwitter() {
        let storeTwitter = Twitter.sharedInstance().sessionStore
        if let userID = storeTwitter.session()?.userID {
            storeTwitter.logOutUserID(userID)
        }
        // TODO: add api for disconnect twitter
        
    }
    

    // MARK: Facebook LogIn Process
    func connectFacebook(viewController: UIViewController, _ item: FeedCard?) {
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
                //TODO: validate that all read permissions requested were granted (readPermissions == grantedPermissions)
                //self.accesToken = accessToken.authenticationToken
                let connection = GraphRequestConnection()
                connection.add(GraphRequest(graphPath: "/me/accounts")) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        //print("Graph Request Succeeded: \(response)")
                        
                        if let responseDict = response.dictionaryValue {
                            let accounts: NSArray = responseDict["data"] as! NSArray
                            
                            var options: [String] = []
                            var facebookAccounts: [FacebookAccount] = []
                            
                            for account in accounts {
                                let accountJson = JSON(account)
                                var facebookAccount: FacebookAccount = FacebookAccount(id: accountJson["id"].string, name: accountJson["name"].string)
                                options.append(accountJson["name"].description)
                                facebookAccounts.append(facebookAccount)
                            }
                            
                            Alert.showActionSheetOptions(parent: viewController, options: options, action: { (itemSelected) -> (Void) in
                                print(options[itemSelected])
                                print(accessToken)
                                UserStore.currentBrand?.facebookDetails?.accessToken = accessToken.authenticationToken
                                UserStore.currentBrand?.facebookDetails?.selectedAccountId = facebookAccounts[itemSelected].id!
                                self.connectFacebookPage(accessToken: accessToken.authenticationToken, facebookPageId: facebookAccounts[itemSelected].id!)
                            })
                        }
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
                
            }
            
        }
    }
    
    func connectFacebookPage(accessToken: String, facebookPageId: String){
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
            "access_token": accessToken,
            "facebook_page_id": facebookPageId
            
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

struct Facebook {
    var accessToken: String?
    var accountSelectedName: String?
}

struct FacebookAccount {
    var id: String?
    var name: String?
}

