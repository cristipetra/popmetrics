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
import Alamofire

class ConnectWizardViewController: BaseViewController, FlexibleSteppedProgressBarDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
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
    
    
    public func configure(_ card:FeedCard) {
        self.actionCard = card
        self.imageURL = card.imageUri
        switch(card.name) {
        case "ganalytics.connect_with_brand":
            self.connectionTarget = "Google Analytics"
            self.steps = ["Auth", "Approve", "Verify", "Done"]
            
        case "twitter.connect_with_brand":
            self.connectionTarget = "Twitter"
            self.steps = ["Auth", "Verify", "Done"]
            
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
        self.progressBar.currentIndex = 1
        if (session != nil) {
             // success
            
            let params = [
                "action_name": "twitter.connect_with_brand",
                "user_id":UserStore.getInstance().getLocalUserAccount().id,
                "twitter_user_id":session?.userID,
                "access_token":session?.authToken,
                "access_token_secret":session?.authTokenSecret
            ]
            let brandId = UserStore.currentBrandId
            let url = ApiUrls.composedBaseUrl(String(format:"/api/actions/brand/%@/required-action", brandId))
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,
                              headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<RequiredActionResponse>>) in
                                
                                let levelOneHandled = self.handleNotOkCodes(response: response.response)
                                if !levelOneHandled {
                                    let handled = self.handleResponseWrap(response.value!)
                                    if !handled {
                                        let store = FeedStore.getInstance()
                                        if let card = store.getFeedCardWithName("twitter.connect_with_brand") {
                                            store.updateCardSection(card, section: "None")
                                        }
                                    }
                                }
                                
            }
            
        } else {
            
            // failed
            EZAlertController.alert("Authentication Error", message: "Authentication has failed. Please try again.")
            return
        }
    }
    
    func stepDoneTwitter() {
        self.progressBar.currentIndex = 2
        EZAlertController.alert("Success")
    }
    
    internal func createHeaders( authToken:String = "" ) -> HTTPHeaders {
        var headers = [String: String]()
        if authToken != "" {
            headers["Authorization"] = "Bearer "+authToken
        }
        else {
            let localUser = UserStore.getInstance().getLocalUserAccount()
            if localUser.authToken != nil { headers["Authorization"] = "Bearer "+localUser.authToken! }
        }
        return headers
    }
    
    internal func handleNotOkCodes(response: HTTPURLResponse?) -> Bool {
        if response?.statusCode == 404 {
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiResponseUnsuccessfull, object: nil,
                                            userInfo: ["title": "Cloud communication error.",
                                                       "subtitle":"The requested resource does not exist",
                                                       "type":"failure"])
            return true
        }
        if response?.statusCode == 401 {
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiClientNotAuthenticated, object: nil,
                                            userInfo: ["title": "Cloud communication error.",
                                                       "subtitle":"User is not authorized.",
                                                       "type":"failure"])
            return true
        }
        if response?.statusCode != 200 {
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiFailure, object: nil,
                                            userInfo: ["title": "Cloud communication error.",
                                                       "subtitle":"",
                                                       "type":"failure"])
            return true
        }
        return false
    }
    
    internal func handleResponseWrap(_ responseWrap: ResponseWrap) -> Bool{
        let value = responseWrap
        if value.getCode() != "success" && value.getCode() != "silent_error" {
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiResponseUnsuccessfull, object: nil,
                                            userInfo: ["title": "Cloud communication error.",
                                                       "subtitle":"Operation was unsuccessfull",
                                                       "type":"failure"])
            return true
        }
        return false
    }
    
    
}
