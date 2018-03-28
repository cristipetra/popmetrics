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
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        setNavigationBar()
        
        btnSubmit.isEnabled = false
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        constraintCenterYcontainer.constant = 0
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
        guard let email = self.emailTextField.text else { return }
        if !Validator.isValidEmail(self.emailTextField.text!) {
            EZAlertController.alert("Invalid email", message: "Please enter a valid email address.")
            return
        }
        self.showProgressIndicator()
        
        BrandApi().validateUserEmail(email) { (response) in
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let email = self.emailTextField.text, !email.isEmpty else {
            btnSubmit.isEnabled = false
            return
        }
        btnSubmit.isEnabled = true
    }
    
    @objc internal func dismissKeyboard() {
        emailTextField.resignFirstResponder()
    }
    
}

// MARK: UITextFieldDelegate
extension SignUpEmailViewController: UITextFieldDelegate {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
