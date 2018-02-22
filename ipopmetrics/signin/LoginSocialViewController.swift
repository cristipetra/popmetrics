//
//  LoginSocialViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/12/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import FacebookLogin
import TwitterKit
import ObjectMapper
import LinkedinSwift
import UserNotifications

class LoginSocialViewController: BaseViewController {
    
    @IBOutlet weak var twitterView: SocialMediaLoginButtonsView!
    @IBOutlet weak var facebookView: SocialMediaLoginButtonsView!
    @IBOutlet weak var linkedInView: SocialMediaLoginButtonsView!
    @IBOutlet weak var progressIndexLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var topButtonHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var titleTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var constraintTopLinkedin: NSLayoutConstraint!
    
    @IBOutlet weak var constraintTopFacebook: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressIndexLbl.isHidden = true
        twitterView.setButton(title: .twitter)
        facebookView.setButton(title: .facebook)
        linkedInView.setButton(title: .linkedIn)
        
        linkedInView.isHidden = true
        
        addButtonAction()
        setNavigationBar()
     
        addSpace()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector:#selector(self.handlerNotification), name: Notification.Popmetrics.RemoteMessage, object:nil)
    }
    
    @objc private func handlerNotification(notification: Notification) {
        //needs to wait to be completed displaying banner message
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (timer) in
            self.nextPage()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addSpace() {
        
        if UIScreen.main.bounds.width > 375 {
            topButtonHeightAnchor.constant = 91
            titleTopAnchor.constant = 30
        } else if UIScreen.main.bounds.width == 320 {
            topButtonHeightAnchor.constant = 10
            titleTopAnchor.constant = 20
            
            //constraintTopFacebook.constant = 10
            //constraintTopLinkedin.constant = 10
        } else if UIScreen.main.bounds.width > 320 {
            topButtonHeightAnchor.constant = 51
            titleTopAnchor.constant = 20
        }
        
    }
    
    private func addButtonAction() {
        twitterView.socialButton.addTarget(self, action: #selector(loginTwitterHandler), for: .touchUpInside)
        facebookView.socialButton.addTarget(self, action: #selector(loginFacebookHandler), for: .touchUpInside)
        linkedInView.socialButton.addTarget(self, action: #selector(loginLinkedInHandler), for: .touchUpInside)
    }
    
    @objc func loginTwitterHandler() {
        RequiredActionHandler.sharedInstance().connectTwitter(nil)
    }
    
    @objc func loginFacebookHandler() {
        RequiredActionHandler.sharedInstance().connectFacebook(viewController: self, item:nil)
    }
    
    @objc func loginLinkedInHandler() {
        let linkedinClientId = "77tn2ar7gq6lgv"
        let linkedinClientSecret = "iqkDGYpWdhf7WKzA"
        let linkedinState = "DLKDJF46ikMMZADddfdfds"
        let linkedinRedirectUrl = "https://github.com/tonyli508/LinkedinSwift"
        
        let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: linkedinClientId, clientSecret: linkedinClientSecret, state: linkedinState, permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: linkedinRedirectUrl))
     
        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
            }, error: { [unowned self] (error) -> Void in
            }, cancel: { [unowned self] () -> Void in
        })
     
    }
    
    func setTitle(title: String) {
        titleLbl.text = title
    }
    
    func setMessage(message: String) {
        messageLbl.text = message
    }
    
    private func setNavigationBar() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        let logoImageView = UIImageView(image: UIImage(named: "logoPop"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        logoImageView.contentMode = .scaleAspectFill
        
        
        self.navigationItem.titleView = logoImageView
        let backButton = UIBarButtonItem(image: UIImage(named: "login_back"), style: .plain, target: self, action: #selector(dismissView))
        backButton.tintColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @IBAction func handlerMaybeLater(_ sender: UIButton) {
        nextPage()
    }
    
    private func nextPage() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .denied {
                self.showManualEnableNotifications()
            }
            if settings.authorizationStatus == .notDetermined {
                self.showPushNotificationsScreen()
            }
            if settings.authorizationStatus == .authorized {
                self.showOnboardingFinalScreen()
            }
        }
        
    }
    
    internal func showOnboardingFinalScreen() {
        let finalOnboardingVC = OnboardingFinalView()
        self.present(finalOnboardingVC, animated: true)
    }
    
    internal func showManualEnableNotifications() {
        let notificationsVC = AppStoryboard.Notifications.instance.instantiateViewController(withIdentifier: ViewNames.SBID_PUSH_MANUALLY_NOTIFCATIONS_VC)
        self.present(notificationsVC, animated: true, completion: nil)
    }
    
    internal func showPushNotificationsScreen() {
        let notificationsVC = AppStoryboard.Notifications.instance.instantiateViewController(withIdentifier: ViewNames.SBID_PUSH_NOTIFICATIONS_VC)
        self.present(notificationsVC, animated: true, completion: nil)
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func catchRequiredActionCompleteNotification(notification:Notification) -> Void {
        // this will only get called after authentication is complete
        self.nextPage()
        
    }
    
}

