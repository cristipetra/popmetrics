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
    
    var socialActionHandler = SocialActionHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressIndexLbl.isHidden = true
        twitterView.setButton(title: .twitter)
        facebookView.setButton(title: .facebook)
        linkedInView.setButton(title: .linkedIn)
        addButtonAction()
        setNavigationBar()
        addSpace()
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
            
            constraintTopFacebook.constant = 10
            constraintTopLinkedin.constant = 10
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
        socialActionHandler.connectTwitter(viewController: self) {
            self.nextPage()
        }
    }
    
    @objc func loginFacebookHandler() {
        print("login facebook")
        socialActionHandler.connectFacebook(viewController: self) {
            self.nextPage()
        }
    }
    
    @objc func loginLinkedInHandler() {
        print("login linkedin")
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
        let finalOnboardingVC = OnboardingFinalView()
        self.present(finalOnboardingVC, animated: true)
    }
    
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
}

