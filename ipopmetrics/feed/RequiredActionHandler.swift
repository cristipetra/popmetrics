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

class RequiredActionHandler: NSObject, CardActionHandler, GIDSignInUIDelegate, GIDSignInDelegate {

    func  handleRequiredAction(_ sender : UIButton, item: FeedItem) {
    
        if item.actionHandler == "connect_google_analytics" {
            connectGoogleAnalytics()
        }
    }
    
    
func connectGoogleAnalytics() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "15676396104-j0cma6ves7m66lkcp6mau2o62j6svo5l.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "15676396104-hr43d2rk9fg466ahofmb5fisbaqpjl5v.apps.googleusercontent.com"
    
        let driveScope = "https://www.googleapis.com/auth/analytics.readonly"
        
        GIDSignIn.sharedInstance().scopes = [driveScope]
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print ("Action failed")
            // self.showError(message: error.localizedDescription)
            return
        }
        
        let userId = user.userID
        let token = user.authentication.idToken
        let serverAuthCode = user.serverAuthCode
        
        let api = FeedApi()
        
        // self.showProgressIndicator()
        api.connectGoogleAnalytics(userId: userId!, token: token!, serverAuthCode: serverAuthCode!, authentication: user.authentication) { responseDict, error in
            //self.hideProgressIndicator()
            if error != nil {
                print("Error!")
                // self.showError()
            return
            } // error != nil
            //self.handleLogInSuccess(userDict: responseDict?["user"] as? [String: Any])
            print ("succeeded!")
        } // usersApi.logInWithGoogle()
    }
    
}
