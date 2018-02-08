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

class SignUpWebsiteViewController: BaseViewController {
    
    @IBOutlet weak var constraintCenterYcontainer: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var btnSubmitWebsite: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        websiteTextField.delegate = self
        
        let tapDismissKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismissKeyboard)
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        btnSubmitWebsite.isEnabled = false
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
    
    // MARK: handlers
    @objc internal func dismissKeyboard() {
        websiteTextField.resignFirstResponder()
    }
    
    @objc internal func dismissView() {
        
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
        // self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func unwindToNameVC(segue:UIStoryboardSegue) { }
    
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let website = self.websiteTextField.text, !website.isEmpty else {
            btnSubmitWebsite.isEnabled = false
            return
        }
        btnSubmitWebsite.isEnabled = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterPhoneNumberForSignUp" {
            if let destinationVC = segue.destination as? LoginViewController {
                destinationVC.isSignupFlow = true
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

// MARK: UITextFieldDelegate
extension SignUpWebsiteViewController: UITextFieldDelegate {
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


