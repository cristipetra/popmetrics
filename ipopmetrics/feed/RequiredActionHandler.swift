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

class RequiredActionHandler: NSObject, CardActionHandler, GIDSignInUIDelegate, GIDSignInDelegate {

    var actionButtonSaved : SimpleButton?
    
    func  handleRequiredAction(_ sender : SimpleButton, item: FeedCard) {
    
        switch(item.actionHandler) {
            case "required_actions.brand_not_connected_with_google_analytics":
                connectGoogleAnalytics(sender, item:item)
            
            case "required_actions.brand_not_connected_with_twitter":
                connectTwitter(sender, item:item)
            
            default:
                print("Unexpected name "+item.type)
        
        }//switch
    }
   
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    
    
   func connectGoogleAnalytics(_ sender:SimpleButton, item:FeedCard) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "850179116799-12c7gg09ar5eo61tvkhv21iisr721fqm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "850179116799-024u4fn5ddmkm3dnius3fq3l1gs81toi.apps.googleusercontent.com"
    
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
        api.connectGoogleAnalytics(userId: userId!, brandId:"58fe437ac7631a139803757e", token: token!, serverAuthCode: serverAuthCode!, authentication: user.authentication) { responseDict, error in
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
        
    
    func connectTwitter(_ sender: SimpleButton, item:FeedCard) {
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            if (session != nil) {
                let params = [
                    "user_id":UsersStore.getInstance().getLocalUserAccount().id,
                    "twitter_user_id":session?.userID,
                    "access_token":session?.authToken,
                    "access_token_secret":session?.authTokenSecret
                    ]
                ProgressHUD.showProgressIndicator()
                FeedApi().postRequiredAction(feedItemId: item.cardId!, params: params) { responseDict, error in
                                            //sender.isLoading = false
                                            if error != nil {
                                                let nc = NotificationCenter.default
                                                nc.post(name:Notification.Name(rawValue:"CardActionNotification"),
                                                        object: nil,
                                                        userInfo: ["success":false, "title":"Action error", "message":"Connection with Twitter has failed.", "date":Date()])
                                                return
                                            } // error != nil
                                            else {
                                                ProgressHUD.hideProgressIndicator()
                                                sender.setTitle("Connected.", for: .normal)
                                                UsersStore.isTwitterConnected = true
                                                self.showBanner(bannerType: .success)
                                            }
                } // usersApi.logInWithGoogle()
                
            } else {
                ProgressHUD.hideProgressIndicator()
                //sender.isLoading = false
                let nc = NotificationCenter.default
                nc.post(name:Notification.Name(rawValue:"CardActionNotification"),
                        object: nil,
                        userInfo: ["success":false, "title":"Action error", "message":"Connection with Twitter has failed... \(error!.localizedDescription)", "date":Date()])
                
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

extension RequiredActionHandler: InfoButtonDelegate {
    func sendInfo(_ sender: UIButton) {
        print("hello")
        showBanner(bannerType: .failed)
    }
}

protocol ShowBanner {
    func showBanner(bannerType: BannerType)
}

extension RequiredActionHandler: ShowBanner {}

extension ShowBanner {    
    internal func showBanner(bannerType: BannerType) {
        let banner: NotificationBanner!
        switch bannerType {
        case .success:
            let title = "Authentication Success!"
            let titleAttribute = [
                NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 12),
                NSForegroundColorAttributeName: PopmetricsColor.darkGrey]
            let attributedTitle = NSAttributedString(string: title, attributes: (titleAttribute as Any as! [String : Any]))
            let subtitle = "Twitter Connected"
            let subtitleAttribute = [
                NSFontAttributeName: UIFont(name: "OpenSans-SemiBold", size: 12),
                NSForegroundColorAttributeName: UIColor.white]
            let attributedSubtitle = NSAttributedString(string: subtitle, attributes: (subtitleAttribute as Any as! [String : Any]))
            banner = NotificationBanner(attributedTitle: attributedTitle, attributedSubtitle: attributedSubtitle, leftView: nil, rightView: nil, style: BannerStyle.none, colors: nil)
            banner.backgroundColor = PopmetricsColor.greenMedium
            break
        case .failed:
            let title = "Authentication Failed"
            let titleAttribute = [
                NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 12),
                NSForegroundColorAttributeName: PopmetricsColor.notificationBGColor]
            let attributedTitle = NSAttributedString(string: title, attributes: (titleAttribute as Any as! [String : Any]))
            let subtitle = "Twitter failed to connect! Try again"
            let subtitleAttribute = [
                NSFontAttributeName: UIFont(name: "OpenSans-SemiBold", size: 12),
                NSForegroundColorAttributeName: UIColor.white]
            let attributedSubtitle = NSAttributedString(string: subtitle, attributes: (subtitleAttribute as Any as! [String : Any]))
            banner = NotificationBanner(attributedTitle: attributedTitle, attributedSubtitle: attributedSubtitle, leftView: nil, rightView: nil, style: BannerStyle.none, colors: nil)
            banner.backgroundColor = PopmetricsColor.salmondColor
            break
        default:
            break
        }
        banner.duration = TimeInterval(exactly: 7.0)!
        banner.show()
        
        banner.onTap = {
            banner.dismiss()
        }
    }
    
    internal func showBanner(title: String, subtitle: String) {
        let banner: NotificationBanner!
        let titleAttribute = [
            NSFontAttributeName: UIFont(name: "OpenSans-SemiBold", size: 12),
            NSForegroundColorAttributeName: PopmetricsColor.bannerSuccessText]
        let attributedTitle = NSAttributedString(string: title, attributes: (titleAttribute as Any as! [String : Any]))
        let subtitleAttribute = [
            NSFontAttributeName: UIFont(name: "OpenSans", size: 12),
            NSForegroundColorAttributeName: UIColor.white]
        let attributedSubtitle = NSAttributedString(string: subtitle, attributes: (subtitleAttribute as Any as! [String : Any]))
        banner = NotificationBanner(attributedTitle: attributedTitle, attributedSubtitle: attributedSubtitle, leftView: nil, rightView: nil, style: BannerStyle.none, colors: nil)
        banner.backgroundColor = PopmetricsColor.greenMedium
        banner.duration = TimeInterval(exactly: 7.0)!
        banner.show()
        
        banner.onTap = {
            banner.dismiss()
        }
    }
    
}
