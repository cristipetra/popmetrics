//
//  WebsiteViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 06/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController
import ObjectMapper

class WebsiteViewController: BaseViewController {
    
    @IBOutlet weak var constraintCenterYcontainer: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    internal var registerBrand: RegisterBrand = RegisterBrand()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        websiteTextField.delegate = self
        
        let tapDismissKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismissKeyboard)
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        btnSubmit.isEnabled = false
        setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        websiteTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        websiteTextField.removeTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
    
    private func openNextScreen(_ registerBrand: RegisterBrand) {
        let loginVC = AppStoryboard.Boarding.instance.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.registerBrand = registerBrand
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    // MARK: handlers
    @objc internal func dismissKeyboard() {
        websiteTextField.resignFirstResponder()
    }
    
    @objc internal func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handlerSubmit(_ sender: UIButton) {
        guard let website = self.websiteTextField.text, !website.isEmpty else {
            self.btnSubmit.isEnabled = false
            return
        }
        
        self.registerBrand.website = website
        self.showProgressIndicator()
        
        BrandApi().valideBrandWebsite(website) { (response) in
            self.hideProgressIndicator()
            
            if response?.code == "success" {
                self.registerBrand.website = response?.data!
                self.openNextScreen(self.registerBrand)
                
            } else {
                let title = "Error"
                let message = response?.message ?? "An error has ocurred. Please try again later."
                
                self.notifyUser(title: title, message: message)
            }
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let website = self.websiteTextField.text, !website.isEmpty else {
            btnSubmit.isEnabled = false
            return
        }
        btnSubmit.isEnabled = true
        
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

// MARK: UITextFieldDelegate
extension WebsiteViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.constraintCenterYcontainer.constant = -100
            self.view.layoutIfNeeded()
            
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.4, animations: {
            self.constraintCenterYcontainer.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
}

struct RegisterBrand {
    var name: String?
    var website: String?
}
