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
   
    var homeHubViewController: HomeHubViewController?
    
    func  handleRequiredAction(_ item: FeedCard) {
        
        switch(item.name) {
            case "ganalytics.connect_with_brand":
                connectGoogleAnalytics(item)
            
            case "twitter.connect_with_brand":
                connectTwitter(item)
            
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
    
   func connectGoogleAnalytics(_ item:FeedCard) {
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
            
            self.homeHubViewController?.showBannerForNotification(pnotification)
            return
        }
        
        let notificationObj = ["alert":"Connecting to Google Analytics.",
                               "subtitle":"Your credentials will be validated in relation with the tracker used in your site.",
                               "type": "info",
                               "sound":"default"
        ]
        let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
        
        self.homeHubViewController?.showBannerForNotification(pnotification)
        
        let brandId = UserStore.currentBrandId
        
        let params = [
            "task_name": "ganalytics.connect_with_brand",
            "user_id":UserStore().getLocalUserAccount().id,
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
                self.homeHubViewController?.tableView.reloadData()
            }
        } // usersApi.logInWithGoogle()
    }
        
    
    func connectTwitter(_ item:FeedCard) {
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            if (session != nil) {
                let notificationObj = ["alert":"Connecting to Twitter.",
                                       "subtitle":"Your credentials will be validated while establishing the connection.",
                                       "type": "info",
                                       "sound":"default"
                ]
                let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                
                self.homeHubViewController?.showBannerForNotification(pnotification)
                
                let params = [
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
                        self.homeHubViewController?.tableView.reloadData()
                    }
                }
                
            } else {
                let notificationObj = ["alert":"Failed to connect with Twitter.",
                                       "subtitle":"None or bad credentials have been provided.",
                                       "type": "failure",
                                       "sound":"default"
                ]
                let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                
                self.homeHubViewController?.showBannerForNotification(pnotification)
                return
                
            }
        }
        
    }

    
    
    // MARK: Facebook LogIn Process
    func connectFacebookfunc(_ sender: SimpleButton, item:FeedCard) {
//        let loginManager = LoginManager()
//        let permissions = [.publicProfile, .email]
//        loginManager.logOut()
//        loginManager.logIn([.publicProfile, .email], viewController: self) { result in
//            switch result {
//            case .Failed(let error):
//                print("failed")
//            case .Cancelled:
//                print("cancelled")
//            case .Success(let grantedPermissions, let declinedPermissions, let accessToken):
//                
//                print("success")
////                let userId = result?.token.userID
////                let token = result?.token.tokenString
//                userId = ""
//                
//                callback(userId, token, nil)
//            }
//        }
    }
    
//    func getFacebookUserInfo(callback: @escaping (_ name: String?, _ email: String?, _ picture: String?, _ error: SocialLoginError?) -> Void) {
//        let params = ["fields": "name, email, picture"]
//        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)!
//        graphRequest.start { connection, result, error in
//            if error == nil, let result = result as? [String: Any] {
//                let name = result["name"] as? String
//                let email = result["email"] as? String
//                var picture: String? = nil
//                if let pictureData = result["picture"] as? [String: Any] {
//                    if let data = pictureData["data"] as? [String: Any] {
//                        picture = data["url"] as? String
//                    }
//                }
//                callback(name, email, picture, nil)
//                return
//            }
//            callback(nil, nil, nil, SocialLoginError.unknown)
//        }
//    }
    
}
