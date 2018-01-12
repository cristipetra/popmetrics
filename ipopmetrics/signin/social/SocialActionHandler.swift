//
//  SocialActionHandler.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 11/01/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
import ObjectMapper
import FacebookLogin

class SocialActionHandler: NSObject {
    
    func connectTwitter(viewController: BaseViewController?, completion: @escaping ()-> ()) {
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            if (session != nil) {
                let notificationObj = ["alert":"Connecting to Twitter.",
                                       "subtitle":"Your credentials will be validated while establishing the connection.",
                                       "type": "info",
                                       "sound":"default"
                ]
                let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                viewController?.showBannerForNotification(pnotification)
                
                let params = [
                    "task_name": "twitter.connect_with_social",
                    //"user_id":UserStore.getInstance().getLocalUserAccount().id,
                    "twitter_user_id":session?.userID,
                    "access_token":session?.authToken,
                    "access_token_secret":session?.authTokenSecret
                ]
                
            } else {
                let notificationObj = ["alert":"Failed to connect with Twitter.",
                                       "subtitle":"None or bad credentials have been provided.",
                                       "type": "failure",
                                       "sound":"default"
                ]
                let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                viewController?.showBannerForNotification(pnotification)
                if error == nil {
                    completion()
                }
            }
        }
        
    }
    
    func connectFacebook(viewController: UIViewController?, completion: @escaping () -> ()) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: viewController) { (loginResult) in
            print("login result")
            switch loginResult {
            case .failed(let error):
                print("failed to login facebook \(error)")
            case .cancelled:
                print("cancelled facebook")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("success \(accessToken.userId)  \(accessToken.authenticationToken) ")
                let userId = accessToken.userId
                let token = accessToken.authenticationToken
                
                completion()
            }
        }
    }
    
    func connectLinkedin() {
        print("connect linkedin")

    }
 
    
}
