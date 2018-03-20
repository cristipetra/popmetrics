//
//  SignUpEmailViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController
import ObjectMapper

class SignUpEmailViewController: BaseViewController {
    
    @IBOutlet weak var constraintCenterYcontainer: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var btnSubmitWebsite: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
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
        
        self.navigationItem.titleView = logoImageView
        let backButton = UIBarButtonItem(image: UIImage(named: "login_back"), style: .plain, target: self, action: #selector(dismissView))
        backButton.tintColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 15
        
        self.navigationItem.leftBarButtonItems = [leftSpace, backButton]
    }
    
    @objc internal func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handlerSubmit(_ sender: UIButton) {
        guard let website = self.websiteTextField.text, !website.isEmpty else {
            self.btnSubmitWebsite.isEnabled = false
            return
        }
        self.showProgressIndicator()
        BrandApi().valideBrandWebsite(website) { (response) in
            self.hideProgressIndicator()
            
            if response?.code == "success" {
                (self.navigationController as! BoardingNavigationController).registerBrand.website = response?.data!
                self.performSegue(withIdentifier: "enterPhoneNumberForSignUp", sender: self)
            } else {
                let title = "Error"
                let message = response?.message ?? "An error has ocurred. Please try again later."
                
                self.notifyUser(title: title, message: message)
            }
        }

    }
    
    func notifyUser(title: String, message: String, type: String = "info"){
        let notificationObj = [
            "title": title,
            "subtitle": message,
            "type": type,
            "sound": "default"
        ]
        
        let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
        self.showBannerForNotification(pnotification)
    }
    
}
