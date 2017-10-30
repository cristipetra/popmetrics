//
//  VerifySocialViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import GTProgressBar
import GoogleSignIn
import TwitterKit
import FacebookCore
import FacebookLogin
import EZAlertController
import Hero

class VerifySocialViewController: UIViewController {
    
    @IBOutlet weak var progressBar: GTProgressBar!
    @IBOutlet weak var facebookConnectLabel: UILabel!
    @IBOutlet weak var linkedInConnectButton: TwoImagesButton!
    @IBOutlet weak var twitterConnectLabel: UILabel!
    @IBOutlet weak var linkedInConnectLabel: UILabel!
    @IBOutlet weak var twitterConnectButton: TwoImagesButton!
    @IBOutlet weak var facebookConnectButton: TwoImagesButton!
    @IBOutlet weak var progressViewWrapper: UIView!
    @IBOutlet weak var statusLabelStackView: UIStackView!
    @IBOutlet weak var footerView: OnboardingFooter!
    @IBOutlet weak var onboardingFooter: OnboardingFooter!
    @IBOutlet var collectionOflabels: Array<UILabel>?
    
    var actionsCompleted: Int = 0 {
        didSet {
            setProgressBar(actionsCompleted: actionsCompleted)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addDivider(view: progressViewWrapper)
        setProgressBar(actionsCompleted: actionsCompleted)
        twitterConnectButton.imageButtonType = .twitter
        facebookConnectButton.imageButtonType = .facebook
        linkedInConnectButton.imageButtonType = .linkedin
        progressBar.layer.cornerRadius = 5
        footerView.continueButton.addTarget(self, action: #selector(VerifySocialViewController.continueButtonPressed), for: .touchUpInside)
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
    }
    
    func addDivider(view: UIView) {
        let divider = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5))
        divider.backgroundColor = PopmetricsColor.dividerBorder
        view.addSubview(divider)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //self.dismissToDirection(direction: .left)
    }
    
    @IBAction func facebookConnectButtonPressed(_ sender: UIButton) {
        connectFacebook()
    }
    @IBAction func twitterConnectButtionPressed(_ sender: UIButton) {
        connectTwitter()
    }
    @IBAction func linkedInConnectButtonPressed(_ sender: UIButton) {
        actionsCompleted += 1
        setActionDisabled(actionType: .linkedIn, actionsCompleted: actionsCompleted)
    }
    
    internal func setProgressBar(actionsCompleted: Int) {
        switch actionsCompleted {
        case 0:
            progressBar.barFillColor = PopmetricsColor.salmondColor
            progressBar.animateTo(progress: 0.05)
        case 1:
            progressBar.barFillColor = PopmetricsColor.yellowBGColor
            setStatusText(actionsCompleted: actionsCompleted)
            onboardingFooter.enableContinueButton()
            progressBar.animateTo(progress: 0.33)
        case 2:
            progressBar.barFillColor = PopmetricsColor.yellowBGColor
            setStatusText(actionsCompleted: actionsCompleted)
            progressBar.animateTo(progress: 0.66)
        case 3:
            progressBar.barFillColor = PopmetricsColor.yellowBGColor
            setStatusText(actionsCompleted: actionsCompleted)
            //showBanner(bannerType: .completed)
            progressBar.animateTo(progress: 1)
        default:
            break
        }
    }
    
    internal func continueButtonPressed() {
        let notificationsVC = AppStoryboard.Notifications.instance.instantiateViewController(withIdentifier: ViewNames.SBID_PUSH_NOTIFICATIONS_VC)
        let finalOnboardingVC = OnboardingFinalView()
        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
        if notificationType == [] {
            self.present(notificationsVC, animated: true, completion: nil)
        } else {
            self.present(finalOnboardingVC, animated: true, completion: nil)
        }
    }
    
    private func setStatusText(actionsCompleted: Int) {
        for it in 0 ..< actionsCompleted {
            collectionOflabels?[it].textColor = PopmetricsColor.textGrey
        }
    }
    
    internal func setActionDisabled(actionType: ActionType, actionsCompleted: Int) {
        switch actionType {
        case .facebook:
            facebookConnectLabel.text = "Company Facebook Connected"
            facebookConnectLabel.alpha = 0.3
            facebookConnectButton.changeToDisabled()
        case .twitter:
            twitterConnectLabel.text = "Twitter Account Connected"
            twitterConnectLabel.alpha = 0.3
            twitterConnectButton.changeToDisabled()
        case .linkedIn:
            linkedInConnectLabel.text = "LinkedIn Account Connected"
            linkedInConnectLabel.alpha = 0.3
            linkedInConnectButton.changeToDisabled()
            if actionsCompleted < 3 {
                showBanner(title: "LinkedIn successfully connected!", subtitle: "Connect all 3 for best results. 👉")
            }
        default:
            break
        }
    }
}

enum ActionType {
    case facebook
    case twitter
    case linkedIn
}


extension VerifySocialViewController: ShowBanner {}


extension VerifySocialViewController/*: GIDSignInUIDelegate, GIDSignInDelegate*/ {
    func connectTwitter() {
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            if (session != nil) {
                FeedApi().connectTwitter(userId: (session?.userID)!, brandId: UsersStore.currentBrandId, token: (session?.authToken)!,
                                         tokenSecret: (session?.authTokenSecret)!) { responseDict, error in
                                            if error != nil {
                                                let nc = NotificationCenter.default
                                                nc.post(name:Notification.Name(rawValue:"CardActionNotification"),
                                                        object: nil,
                                                        userInfo: ["success":false, "title":"Action error", "message":"Connection with Twitter has failed.", "date":Date()])
                                                print("error: \(String(describing: error))")
                                                return
                                            } // error != nil
                                            else {
                                                UsersStore.isTwitterConnected = true
                                                print("connected")
                                                self.actionsCompleted += 1
                                                if self.actionsCompleted < 3 {
                                                    self.showBanner(title: "Twitter successfully connected!", subtitle: "Connect all 3 for best results. 👉")
                                                }
                                                self.setActionDisabled(actionType: .twitter, actionsCompleted: self.actionsCompleted)
                                            }
                } // usersApi.logInWithGoogle()
                
            } else {
                print("user cancelled")
                let nc = NotificationCenter.default
                nc.post(name:Notification.Name(rawValue:"CardActionNotification"),
                        object: nil,
                        userInfo: ["success":false, "title":"Action error", "message":"Connection with Twitter has failed... \(error!.localizedDescription)", "date":Date()])
            }
        }
        
    }
    
    // MARK: Facebook LogIn Process
    func connectFacebook() {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.loginBehavior = .browser
        
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: nil) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
                print("Logged in!")
                self.actionsCompleted += 1
                if self.actionsCompleted < 3 {
                    self.showBanner(title: "Facebook successfully connected!", subtitle: "Connect all 3 for best results. 👉")
                }
                self.setActionDisabled(actionType: .facebook, actionsCompleted: self.actionsCompleted)
                self.getFBUserData()
            }
        }
    }
    
    func getFBUserData(){
        let params = ["fields" : "email, name"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    
                    print(responseDictionary["name"] as Any)
                    print(responseDictionary["email"] as Any)
                }
            }
        }
    }
}
