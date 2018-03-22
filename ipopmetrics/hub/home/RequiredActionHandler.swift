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
    
    func  handleRequiredAction(viewController: UIViewController, item: FeedCard) {
        
        switch(item.name) {
            case "ganalytics.connect_with_brand":
                connectGoogleAnalytics(item)
            
            case "twitter.connect_with_brand":
                connectTwitter(item)
            
            case "facebook.connect_with_brand":
                connectFacebook(viewController:viewController, item: item)
                break
            case "payment.subscription.upgrade":
                displayPaymentSubscription(viewController)
                break
            case "payment.subscription.update_payment":
                displayPaymentConfirmation(viewController)
                break
            default:
                print("Unexpected name "+item.name)
        
        }//switch
    }
    
    func displayPaymentSubscription(_ viewController: UIViewController) {
        let vc = UIStoryboard.init(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "TrialViewController") as! TrialViewController
        let navigation = UINavigationController(rootViewController: vc)
        viewController.present(navigation, animated: true, completion: nil)
    }
    
    func displayPaymentConfirmation(_ viewController: UIViewController) {
        let vc = UIStoryboard.init(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "PaymentTableViewController") as! PaymentTableViewController
        
        let brandId = UserStore.currentBrandId
        let planId = Config.sharedInstance.environment.stripeBasicPlanId
        let amount = Config.sharedInstance.environment.stripeBasicPlanAmount
        vc.configure(brandId:brandId, amount:amount, planId:planId)
        
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
   
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
   func connectGoogleAnalytics(_ item:FeedCard?) {
    
//        navigator.push("vnd.popmetrics://required_action/"+(item?.name)!)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "850179116799-12c7gg09ar5eo61tvkhv21iisr721fqm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "850179116799-024u4fn5ddmkm3dnius3fq3l1gs81toi.apps.googleusercontent.com"

        let gaScope = "https://www.googleapis.com/auth/analytics.readonly"
        GIDSignIn.sharedInstance().scopes = [gaScope]
        GIDSignIn.sharedInstance().signOut()

        GIDSignIn.sharedInstance().signIn()
    
    }
    
    func connectGoogle(_ item:FeedCard?) {
        
//        navigator.push("vnd.popmetrics://required_action/"+(item?.name)!)
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "850179116799-12c7gg09ar5eo61tvkhv21iisr721fqm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "850179116799-024u4fn5ddmkm3dnius3fq3l1gs81toi.apps.googleusercontent.com"

        let gaScope = "https://www.googleapis.com/auth/analytics.readonly"
        let gmbScope = "https://www.googleapis.com/auth/plus.business.manage"
        GIDSignIn.sharedInstance().scopes = [gaScope, gmbScope]
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
//        navigator.push("vnd.popmetrics://required_action/"+(item?.name)!)
        let storeTwitter = Twitter.sharedInstance().sessionStore
        if let userID = storeTwitter.session()?.userID {
            storeTwitter.logOutUserID(userID)
        }
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            if (session != nil) {
                let notificationObj = ["title": "Twitter successfully connected!",
                                       "subtitle":"Automated social posting now available.",
                                       "type": "success",
                                       "sound":"default"
                ]
                let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
                
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
                    NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
                                                    userInfo: pnotification.toJSON())
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
    
    func parseFacebookAccounts(_ responseDict: [String: Any]?) -> [FacebookAccount]?{
        guard let accounts = responseDict?["data"] as? NSArray, accounts.count > 0 else {
            return nil
        }

        var facebookAccounts: [FacebookAccount] = []
        
        for account in accounts {
            guard let accountData = account as? [String: Any],
                let id = accountData["id"] as? String,
                let name = accountData["name"] as? String,
                let username = accountData["username"] as? String,
                let perms = accountData["perms"] as? [String] else {
                continue
            }

            var fbAccount = FacebookAccount(id: id, name: name, username: username, perms:perms)
            
            if let picture = accountData["picture"] as? [String: Any],
                let pictureData = picture["data"] as? [String: Any],
                let pictureUrl = pictureData["url"] as? String {

                fbAccount.picture = pictureUrl
            }
            
            facebookAccounts.append(fbAccount)
            
        }
        
        return facebookAccounts
    }
    
    internal func showAlertMessage(_ viewController: UIViewController, message: String) {
        let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okButton)
        viewController.present(alertController, animated: true, completion: nil)
    }

    // MARK: Facebook LogIn Process
    func connectFacebook(viewController: UIViewController, item: FeedCard?) {
//      navigator.push("vnd.popmetrics://required_action/"+(item?.name)!)
        let loginManager = LoginManager()
        loginManager.logOut()
        
        let readPermissions = [ReadPermission.publicProfile, ReadPermission.email, ReadPermission.pagesShowList]
        let publishPermissions = [PublishPermission.managePages, PublishPermission.publishPages]

        loginManager.logIn(readPermissions:readPermissions, viewController: viewController) { result in
            switch result {
            case LoginResult.failed(let error):
                // Show fail read permissions message
                self.showAlertMessage(viewController, message: "Failed to connect with Facebook.")
            case LoginResult.cancelled:
                //Show declined read permissions message
                self.showAlertMessage(viewController, message: "You need to grant all the requested permissions to continue.")
                
            case LoginResult.success(let grantedPermissions, let declinedPermissions, let accessToken):
                // check if all requested permissions were granted
                if !declinedPermissions.isEmpty {
                    //Show declined read permissions message
                    self.showAlertMessage(viewController, message: "You need to grant all the requested permissions to continue.")
                    return
                }
                
                // request list of Facebook Pages
                let connection = GraphRequestConnection()
                connection.add(GraphRequest(graphPath: "/me/accounts", parameters: ["fields": "id, name, perms, username, picture"])) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        guard let facebookAccounts = self.parseFacebookAccounts(response.dictionaryValue), facebookAccounts.count > 0 else{
                            // Show no pages message
                            self.showAlertMessage(viewController, message: "You don't have any Facebook Pages.")
                            return
                        }
                        
                        let pickFacebookPageController = FacebookPagePickerViewController(facebookPages: facebookAccounts){
                            selectedFacebookAccount in
                            guard let selectedFacebookAccount = selectedFacebookAccount else {
                                self.showAlertMessage(viewController, message: "Please select a Facebook Page.")
                                return
                            }
                            
                            if !selectedFacebookAccount.canCreateContent {
                                self.showAlertMessage(viewController, message: "You must be an Administrator or an Editor to post content as this Page.")
                                
                                return
                            }
                            
                            loginManager.logIn(publishPermissions:publishPermissions, viewController: viewController) { result in
                                switch result {
                                case LoginResult.failed( _):
                                    // Show fail request publish permissions
                                    self.showAlertMessage(viewController, message: "Failed to connect with Facebook.")
                                    
                                case LoginResult.cancelled:
                                    //Show declined publish permissions message
                                    self.showAlertMessage(viewController, message: "You need to grant all the requested permissions to continue.")
                                    
                                case LoginResult.success( _, let declinedPermissions, let accessToken):
                                    if !declinedPermissions.isEmpty {
                                        //Show declined publish permissions message
                                        self.showAlertMessage(viewController, message: "You need to grant all the requested permissions to continue.")
                                        return
                                    }
                                    
                                    /*
                                     UserStore.currentBrand?.facebookDetails?.accessToken = accessToken.authenticationToken
                                     UserStore.currentBrand?.facebookDetails?.selectedAccountId = facebookAccounts[itemSelected].id!
                                     */
                                    self.connectFacebookPage(accessToken: accessToken.authenticationToken,
                                                             facebookPageId: selectedFacebookAccount.id)
                                    
                                }
                            }

                        }
                        pickFacebookPageController.modalPresentationStyle =  UIModalPresentationStyle.pageSheet
                        pickFacebookPageController.modalTransitionStyle =  UIModalTransitionStyle.coverVertical

                        let navController  = UINavigationController()
                        navController.pushViewController(pickFacebookPageController, animated: true)
                        viewController.present(navController, animated: true, completion: nil)
                        
                    case .failed( _):
                        // Show fail gettting pages
                        self.showAlertMessage(viewController, message: "Failed to get your Facebook Pages.")
                    }
                }
                connection.start()
                
            }
            
        }
    }
    
    func connectFacebookPage(accessToken: String, facebookPageId: String){
        let notificationObj = ["title": "Facebook successfully connected!",
                               "subtitle":"Automated social posting now available.",
                               "type": "success",
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
    let id: String
    let name: String
    let username: String
    var picture: String?
    let perms: [String]
    
    init(id: String, name: String, username: String, perms: [String]){
        self.id = id
        self.name = name
        self.username = username
        self.perms = perms
    }
    
    var canCreateContent: Bool {
        get {
            return perms.contains("CREATE_CONTENT")
        }
    }
}
