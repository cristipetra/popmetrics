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
import EZLoadingActivity
import GoogleSignIn
import Alamofire

class ConnectWizardGoogleMyBusinessVC: ConnectWizardBaseViewController, FlexibleSteppedProgressBarDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var progressBar: FlexibleSteppedProgressBar!
    @IBOutlet weak var connectionTargetLabel: UILabel!
    @IBOutlet weak var connectionImageView: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    var steps: [String] = ["None"]
    var connectionTarget: String = ""
    var imageURL: String?
    var actionCard: FeedCard?
    var accounts = [MyBusinessAcccount]()
    var remainingAccounts = 0
    var signedUser:GIDGoogleUser?
    var pickedAccount: MyBusinessAcccount?
    
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
    
    override func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        containerView.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }

    
    public func configure(_ card:FeedCard) {
        self.actionCard = card
        self.imageURL = "http://blog.popmetrics.io/wp-content/uploads/sites/13/2017/12/nofacebookpage.png"
        self.connectionTarget = "Google My Business"
        self.steps = ["Auth", "Approve", "Verify", "Done"]
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if position == FlexibleSteppedProgressBarTextLocation.bottom {
            return self.steps[index]
        }
        return ""
    }
    
    func start() {
        let startVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ConnectWizardStartVC") as! ConnectWizardStartVC
        self.add(asChildViewController: startVC)
    }
    
    @IBAction func mainButtonTouched(_ sender: Any) {
        switch (self.progressBar.currentIndex) {
        case 0:
            authenticate()
        case 2:
            confirmAccount()
        default:
            if self.progressBar.currentIndex == steps.count-1 {
                self.navigationController?.popViewController(animated: true)
                return
            }
        }
    }
    
    @IBAction func cancelButtonTouched(_ sender: UIButton) {
        self.hideProgressIndicator()
        self.navigationController?.popViewController(animated: true)
    }
    
    func authenticate() {

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "850179116799-12c7gg09ar5eo61tvkhv21iisr721fqm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "850179116799-024u4fn5ddmkm3dnius3fq3l1gs81toi.apps.googleusercontent.com"

        let gmbScope = "https://www.googleapis.com/auth/plus.business.manage"
        let profileScope = "https://www.googleapis.com/auth/plus.profiles.read"
        
        GIDSignIn.sharedInstance().scopes = [gmbScope, profileScope]
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
            
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            EZAlertController.alert("Authentication Error", message: "Authentication has failed. Please try again.")
            return
        }
        self.signedUser = user
        let url = "https://mybusiness.googleapis.com/v4/accounts"
        let params = [String:String]()
        let headers = createHeaders(authToken:user.authentication.accessToken)
        self.showProgressIndicator()
        Alamofire.request(url, method: .get, parameters: params,
                          headers:headers).responseObject() { (response: DataResponse<MyBusinessAccountsResponse>) in
                            self.accounts = [MyBusinessAcccount]()
                            let accounts = response.result.value?.accounts
                            self.remainingAccounts = (accounts?.count)!
                            for account in accounts! {
                                self.accounts.append(account)
                            }
                            for account in accounts! {
                                self.getLocationsForAccount(account, headers:headers)
                            }
        }
        
    }
    
    func getLocationsForAccount(_ account:MyBusinessAcccount, headers:HTTPHeaders) {
        
        let url = "https://mybusiness.googleapis.com/v4/"+account.name!+"/locations"
        let params = [String:String]()
        Alamofire.request(url, method: .get, parameters: params,
                          headers:headers).responseObject() { (response: DataResponse<MyBusinessLocationsResponse>) in
                            
                            if let locations = response.result.value?.locations {
                                for location in (response.result.value?.locations)! {
                                    account.locations.append(location)
                                }
                            }
                            self.remainingAccounts = self.remainingAccounts - 1
                            if self.remainingAccounts == 0 {
                                self.hideProgressIndicator()
                                self.showAccountPicker()
                            }
        }
        
    }
    
    func getProfileForAccount(_ account:MyBusinessAcccount, headers:HTTPHeaders) {
        let url = "https://www.googleapis.com/plusDomains/v1/people/{userId}"
        let params = [String:String]()
        Alamofire.request(url, method: .get, parameters: params,
                          headers:headers).responseObject() { (response: DataResponse<MyBusinessLocationsResponse>) in
                            for location in (response.result.value?.locations)! {
                                account.locations.append(location)
                            }
                            self.remainingAccounts = self.remainingAccounts - 1
                            if self.remainingAccounts == 0 {
                                self.showAccountPicker()
                            }
        }
        
    }
    
    func showAccountPicker() {
        self.mainButton.isEnabled = false
        var locatedAccounts = [MyBusinessAcccount]()
        for account in self.accounts {
            if account.locations.count > 0 {
                locatedAccounts.append(account)
            }
        }
        
        if locatedAccounts.count < 1 {
            showError("The account you have authenticated with is not authorized for Google My Business", instruction: "Please check your account then retry or use another account.")
            return
        }
        
        self.progressBar.currentIndex = 1
        let pickVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "GoogleMyBusinessPickerTableVC") as! GoogleMyBusinessPickerTableVC
        pickVC.configure(accounts: self.accounts)
        self.add(asChildViewController: pickVC)
        
        
    }
    
    func didPickAccount(_ account:MyBusinessAcccount) {
        self.progressBar.currentIndex = self.steps.count - 2
        let confirmVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ConnectWizardGoogleMyBusinessAccountConfirmation") as! ConnectWizardGoogleMyBusinessAccountConfirmationVC
        confirmVC.configure(account:account, signedUser:self.signedUser!)
        self.add(asChildViewController: confirmVC)
        self.mainButton.isEnabled = true
        self.mainButton.titleLabel?.textAlignment = .center
        self.mainButton.titleLabel?.text = "Confirm"

        self.pickedAccount = account
    }
    
    func confirmAccount() {
        self.showProgressIndicator()
        let brandId = UserStore.currentBrandId
        let url = ApiUrls.composedBaseUrl(String(format:"/api/actions/brand/%@/wizard-required-action", brandId))
        
        let params = [
            "action_name": "gmybusiness.connect_with_brand",
            "user_id": UserStore().getLocalUserAccount().id ?? "",
            "client_id":GIDSignIn.sharedInstance().clientID,
            "token":signedUser?.authentication.idToken ?? "",
            "access_token": signedUser?.authentication.accessToken ?? "",
            "refresh_token": signedUser?.authentication.refreshToken ?? "",
            "server_auth_code": signedUser?.serverAuthCode ?? "",
            "scopes": GIDSignIn.sharedInstance().scopes
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<RequiredActionResponse>>) in
                            self.hideProgressIndicator()
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                if response.value?.getCode() != "success" {
                                    self.showError("There was an error connecting your account with Popmetrics",
                                                   instruction:"Please try again.")
                                    return
                                }
                                self.progressBar.currentIndex = self.steps.count-1
                                self.cancelButton.isHidden = true
                                self.showOk("We have successfully connected Popmetrics with your Google My Business account", instruction:"Stay tuned for more insights")
                                self.mainButton.titleLabel?.text = "Done"
                                FeedStore.getInstance().archiveCard(self.actionCard!)
                            }

        }
    }
    
}



