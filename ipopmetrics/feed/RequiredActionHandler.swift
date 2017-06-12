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

class RequiredActionHandler: NSObject, CardActionHandler, GIDSignInUIDelegate, GIDSignInDelegate {

    var actionButtonSaved : SimpleButton?
    
    func  handleRequiredAction(_ sender : SimpleButton, item: FeedItem) {
    
        switch(item.actionHandler) {
            case "connect_google_analytics":
                connectGoogleAnalytics(sender, item:item)
            
            case "connect_twitter":
                connectTwitter(sender, item:item)
            
            default:
                print("Unexpected handler "+item.actionHandler)
        
        }//switch
    }
   
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    
    
   func connectGoogleAnalytics(_ sender:SimpleButton, item:FeedItem) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "850179116799-12c7gg09ar5eo61tvkhv21iisr721fqm.apps.googleusercontent.com"
    
        let driveScope = "https://www.googleapis.com/auth/analytics.readonly"
        
        GIDSignIn.sharedInstance().scopes = [driveScope]
        GIDSignIn.sharedInstance().signOut()
    
        actionButtonSaved = sender
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            self.actionButtonSaved!.isLoading = false
            let nc = NotificationCenter.default
            nc.post(name:Notification.Name(rawValue:"CardActionNotification"),
                    object: nil,
                    userInfo: ["success":false, "title":"Action error", "message":"Connection with Twitter has failed... \(error.localizedDescription)", "date":Date()])
            return
        }
        
        let userId = user.userID
        let token = user.authentication.idToken
        let serverAuthCode = user.serverAuthCode
        
        let api = FeedApi()
        
        // self.showProgressIndicator()
        api.connectGoogleAnalytics(userId: userId!, brandId:"5720d6a12f522134a29e3054", token: token!, serverAuthCode: serverAuthCode!, authentication: user.authentication) { responseDict, error in
            self.actionButtonSaved!.isLoading = false
            if error != nil {
               NotificationCenter.default.post(name:Notification.Name(rawValue:"CardActionNotification"),
                        object: nil,
                        userInfo: ["success":false, "title":"Action error", "message":"Connection with Google Analytics has failed.", "date":Date()])
            return
            } // error != nil
            self.actionButtonSaved!.setTitle("Connected.", for: .normal)
        } // usersApi.logInWithGoogle()
    }
        
        
    func connectTwitter(_ sender: SimpleButton, item:FeedItem) {
            Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
                if (session != nil) {
                    FeedApi().connectTwitter(userId: (session?.userID)!, brandId:"5720d6a12f522134a29e3054", token: (session?.authToken)!,
                                       tokenSecret: (session?.authTokenSecret)!) { responseDict, error in
                        sender.isLoading = false
                        if error != nil {
                            let nc = NotificationCenter.default
                            nc.post(name:Notification.Name(rawValue:"CardActionNotification"),
                                    object: nil,
                                    userInfo: ["success":false, "title":"Action error", "message":"Connection with Twitter has failed.", "date":Date()])
                            return
                        } // error != nil
                        else {
                            sender.setTitle("Connected.", for: .normal)
                            }
                    } // usersApi.logInWithGoogle()
                    
                } else {
                    sender.isLoading = false
                    let nc = NotificationCenter.default
                    nc.post(name:Notification.Name(rawValue:"CardActionNotification"),
                            object: nil,
                            userInfo: ["success":false, "title":"Action error", "message":"Connection with Twitter has failed... \(error?.localizedDescription)", "date":Date()])
                    
                }
            }
            
        }
    
}
