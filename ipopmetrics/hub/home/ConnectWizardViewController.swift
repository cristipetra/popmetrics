//
//  ConnectWizardStartVC.swift
//  ipopmetrics
//
//  Created by Rares Pop on 19/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import EZAlertController
import GoogleSignIn
import TwitterKit
import FacebookCore
import FacebookLogin

class ConnectWizardViewController: UIViewController, FlexibleSteppedProgressBarDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var progressBar: FlexibleSteppedProgressBar!
    @IBOutlet weak var connectionTargetLabel: UILabel!
    @IBOutlet weak var connectionImageView: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var currentStep = 0
    var steps: [String] = ["None"]
    var connectionTarget: String = ""
    var imageURL: String?
    var actionCard: FeedCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        self.progressBar.delegate = self
        self.progressBar.lineHeight = 5
        self.progressBar.radius = 7
        self.progressBar.progressRadius = 15
        self.progressBar.progressLineHeight = 3
        self.progressBar.backgroundColor = UIColor(named:"venice_winter")
        self.progressBar.currentSelectedCenterColor = UIColor(named:"customer_impact")!
        self.progressBar.lastStateOuterCircleStrokeColor = UIColor(named:"blue_bottle")
        
        addShadowToView(mainButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.connectionTargetLabel.text = self.connectionTarget
        self.progressBar.numberOfPoints = self.steps.count
        if self.imageURL != nil {
                self.connectionImageView.af_setImage(withURL: URL(string:self.imageURL!)!)
        }
        start()
    }
    
    internal func addShadowToView(_ toView: UIView) {
        toView.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        toView.layer.shadowOpacity = 0.3;
        toView.layer.shadowRadius = 2
        toView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    public func configure(_ card:FeedCard) {
        self.actionCard = card
        self.imageURL = card.imageUri
        switch(card.name) {
        case "ganalytics.connect_with_brand":
            self.connectionTarget = "Google Analytics"
            self.steps = ["Auth", "Approve", "Verify", "Done"]
            
        case "twitter.connect_with_brand":
            self.connectionTarget = "Twitter"
            self.steps = ["Auth", "Approve", "Verify", "Done"]
            
        case "facebook.connect_with_brand":
            self.connectionTarget = "Facebook Page"
            break
            
        default:
            print("Unexpected name "+card.name)
        }//switch
        
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if position == FlexibleSteppedProgressBarTextLocation.bottom {
            return self.steps[index]
        }
        return ""
    }
    
    func start() {
        self.mainButton.titleLabel?.text = "Authenticate"
    }
    
    @IBAction func mainButtonTouched(_ sender: Any) {
        authenticate()
    }
    
    @IBAction func cancelButtonTouched(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func authenticate() {
        switch(actionCard?.name)! {
        case "ganalytics.connect_with_brand":
                GIDSignIn.sharedInstance().delegate = self
                GIDSignIn.sharedInstance().clientID = "850179116799-12c7gg09ar5eo61tvkhv21iisr721fqm.apps.googleusercontent.com"
                GIDSignIn.sharedInstance().serverClientID = "850179116799-024u4fn5ddmkm3dnius3fq3l1gs81toi.apps.googleusercontent.com"
        
                let gaScope = "https://www.googleapis.com/auth/analytics.readonly"
                GIDSignIn.sharedInstance().scopes = [gaScope]
                GIDSignIn.sharedInstance().signOut()
                GIDSignIn.sharedInstance().signIn()
            
        case "gmybusiness.connect_with_brand":
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().clientID = "850179116799-12c7gg09ar5eo61tvkhv21iisr721fqm.apps.googleusercontent.com"
            GIDSignIn.sharedInstance().serverClientID = "850179116799-024u4fn5ddmkm3dnius3fq3l1gs81toi.apps.googleusercontent.com"
            
            let gmbScope = "https://www.googleapis.com/auth/plus.business.manage"
            GIDSignIn.sharedInstance().scopes = [gmbScope]
            GIDSignIn.sharedInstance().signOut()
            GIDSignIn.sharedInstance().signIn()
            
        case "twitter.connect_with_brand":
            Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
                self.stepVerifyTwitter(session: session, error: error)
            }
            
        case "facebook.connect_with_brand":
            self.connectionTarget = "Facebook Page"
            break
            
        default:
            print("Unexpected name "+(actionCard?.name)!)
        }//switch
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            EZAlertController.alert("Authentication Error", message: "Authentication has failed. Please try again.")
            return
        }
      
        
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
    
    func stepVerifyTwitter(session:TWTRSession?, error: Error?) {
        if (session != nil) {
             // success
            
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
//                NotificationCenter.default.post(name:Notification.Popmetrics.RemoteMessage, object:nil,
//                                                userInfo: pnotification.toJSON())
            }
            
        } else {
            
            // failed
            EZAlertController.alert("Authentication Error", message: "Authentication has failed. Please try again.")
            return
        }
    }
    
    
    
}
