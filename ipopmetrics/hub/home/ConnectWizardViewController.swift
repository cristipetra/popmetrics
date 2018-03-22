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
            self.steps = ["Auth", "Approve", "Verify", "Done"]
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
        switch (self.currentStep) {
        case 0:
            authenticate()
            break
        default:
            if self.currentStep == steps.count-1 {
                self.navigationController?.popViewController(animated: true)
                return
            }
        }
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
            let loginManager = LoginManager()
            let readPermissions = [ReadPermission.publicProfile, ReadPermission.email, ReadPermission.pagesShowList]
            loginManager.logIn(readPermissions:readPermissions, viewController: self) { result in
                 switch result {
                 case LoginResult.failed(let error):
                    // Show fail read permissions message
                    self.presentAlertWithTitle("Failure", message:"Failed to connect with Facebook.")
                 case LoginResult.cancelled:
                    //Show declined read permissions message
                    self.presentAlertWithTitle("Failure", message: "You need to grant all the requested permissions to continue.")
                 case LoginResult.success(let grantedPermissions, let declinedPermissions, let accessToken):
                    // check if all requested permissions were granted
                    if !declinedPermissions.isEmpty {
                        //Show declined read permissions message
                        self.presentAlertWithTitle("Failure", message: "You need to grant all the requested permissions to continue.")
                        return
                    }
                    self.stepApproveFacebook(loginManager:loginManager)
                    break
                }
            }
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
                                            self.stepDoneTwitter()
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
        self.progressBar.currentIndex = self.steps.count-1
        self.mainButton.titleLabel?.text = "Done"
    }
    
    
    func stepApproveFacebook(loginManager: LoginManager) {
        self.progressBar.currentIndex = 1
        
        
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me/accounts", parameters: ["fields": "id, name, perms, username, picture"])) { httpResponse, result in
            switch result {
            case .failed( _):
                // Show fail gettting pages
                self.presentAlertWithTitle("Failure", message: "Failed to get your Facebook Pages.")
            case .success(let response):
                guard let facebookAccounts = self.parseFacebookAccounts(response.dictionaryValue), facebookAccounts.count > 0 else{
                    // Show no pages message
                    self.presentAlertWithTitle("Failure", message: "You don't have any Facebook Pages.")
                    return
                }
                self.stepPickFacebook(facebookAccounts, loginManager: loginManager)
            
            }//switch
                
                
            
        }//connection.add
        connection.start()
        
    }//step
    
    func stepPickFacebook(_ facebookAccounts:[FacebookAccount], loginManager:LoginManager) {
        let pickFacebookPageController = FacebookPagePickerViewController(facebookPages: facebookAccounts){
            selectedFacebookAccount in
            guard let selectedFacebookAccount = selectedFacebookAccount else {
                self.presentAlertWithTitle("Message", message: "Please select a Facebook Page.")
                return
            }
            
            if !selectedFacebookAccount.canCreateContent {
                self.presentAlertWithTitle("Message", message: "You must be an Administrator or an Editor to post content as this Page.")
                return
            }
            let publishPermissions = [PublishPermission.managePages, PublishPermission.publishPages]
            loginManager.logIn(publishPermissions:publishPermissions, viewController: self) { result in
                switch result {
                case LoginResult.failed( _):
                    // Show fail request publish permissions
                    self.presentAlertWithTitle("Failure", message: "Failed to connect with Facebook.")
                    
                case LoginResult.cancelled:
                    //Show declined publish permissions message
                    self.presentAlertWithTitle("Failure", message: "You need to grant all the requested permissions to continue.")
                    
                case LoginResult.success( _, let declinedPermissions, let accessToken):
                    if !declinedPermissions.isEmpty {
                        //Show declined publish permissions message
                        self.presentAlertWithTitle("Failure", message: "You need to grant all the requested permissions to continue.")
                        return
                    }
                    
                    /*
                     UserStore.currentBrand?.facebookDetails?.accessToken = accessToken.authenticationToken
                     UserStore.currentBrand?.facebookDetails?.selectedAccountId = facebookAccounts[itemSelected].id!
                     */
                    self.stepVerifyFacebook(accessToken: accessToken.authenticationToken,
                                             facebookPageId: selectedFacebookAccount.id)
                    
                }//switch
            }//logIn
            
        }///controller
        pickFacebookPageController.modalPresentationStyle =  UIModalPresentationStyle.pageSheet
        pickFacebookPageController.modalTransitionStyle =  UIModalTransitionStyle.coverVertical
        
    }//stepPickFacebook
    
    func stepVerifyFacebook(accessToken: String, facebookPageId: String){
        
        self.progressBar.currentIndex = self.steps.count-2
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
    
    func parseFacebookAccounts(_ responseDict: [String: Any]?) -> [FacebookAccount]? {
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

final class FacebookPageTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: FacebookPageTableViewCell.self)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String, details: String, imageUrl: String?, placeholderImage: UIImage?) {
        if let picture = imageUrl {
            imageView?.af_setImage(
                withURL: URL(string: picture)!,
                placeholderImage: placeholderImage
            )
        }else{
            imageView?.image = placeholderImage
        }
        textLabel?.text = text
        detailTextLabel?.text = details
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.af_cancelImageRequest()
        imageView?.layer.removeAllAnimations()
        imageView?.image = nil
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
}

final class FacebookPageTableDataSourceAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let facebookPages: [FacebookAccount]
    var selectedFacebookPage: FacebookAccount?
    
    required init(facebookPages: [FacebookAccount]) {
        self.facebookPages = facebookPages
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facebookPages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FacebookPageTableViewCell.identifier) as! FacebookPageTableViewCell
        
        let facebookPage = facebookPages[indexPath.row]
        
        if let selectedFacebookPage = selectedFacebookPage, selectedFacebookPage.id == facebookPage.id {
            cell.setSelected(true, animated: true)
        }
        
        cell.configure(text: facebookPage.name, details: facebookPage.username, imageUrl: facebookPage.picture  , placeholderImage: UIImage(named: "iconFacebookSocial"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let facebookPage = facebookPages[indexPath.row]
        selectedFacebookPage = facebookPage
        
    }
    
    
}

