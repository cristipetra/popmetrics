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
import Alamofire

class ConnectWizardGoogleMyBusinessVC: ConnectWizardBaseViewController, FlexibleSteppedProgressBarDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
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
    var accounts = [MyBusinessAcccount]()
    var remainingAccounts = 0
    
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
    
    private func add(asChildViewController viewController: UIViewController) {
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
        self.mainButton.titleLabel?.text = "Authenticate"
        let startVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ConnectWizardStartVC") as! ConnectWizardStartVC
        self.add(asChildViewController: startVC)
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

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "850179116799-12c7gg09ar5eo61tvkhv21iisr721fqm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().serverClientID = "850179116799-024u4fn5ddmkm3dnius3fq3l1gs81toi.apps.googleusercontent.com"

        let gmbScope = "https://www.googleapis.com/auth/plus.business.manage"
        GIDSignIn.sharedInstance().scopes = [gmbScope]
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
            
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            EZAlertController.alert("Authentication Error", message: "Authentication has failed. Please try again.")
            return
        }

        let url = "https://mybusiness.googleapis.com/v4/accounts"
        let params = [String:String]()
        let headers = createHeaders(authToken:user.authentication.accessToken)
        Alamofire.request(url, method: .get, parameters: params,
                          headers:headers).responseObject() { (response: DataResponse<MyBusinessAccountsResponse>) in

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
        
        let pickVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "GoogleMyBusinessPickerTableVC") as! GoogleMyBusinessPickerTableVC
        pickVC.configure(accounts: self.accounts)
        self.add(asChildViewController: pickVC)
        
        
    }
    
}



