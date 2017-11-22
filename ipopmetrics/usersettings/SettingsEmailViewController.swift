//
//  SettingsEmailViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController

class SettingsEmailViewController: SettingsBaseViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    let user = UsersStore.getInstance().getLocalUserAccount()
    
    private var didDisplayAlert: Bool = false
    private var didChangedEmail: Bool {
        get {
            return emailTextfield.text != user.email
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateView()
        
        titleWindow = "Professional Email"
        setupNavigationBar()
    }
    
    private func updateView() {
        emailTextfield.text = user.email
    }
    
    @IBAction func handlerConfirmEmail(_ sender: UIButton) {
    }    

    @objc override func cancelHandler() {
        if shouldDisplayAlert() {
            didDisplayAlert = true
            Alert.showAlertDialog(parent: self, action: { (action) -> (Void) in
                switch action {
                case .cancel:
                    //self.navigationController?.popViewController(animated: true)
                    break
                case .save:
                    self.changeEmail()
                    break
                }
            })
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func shouldDisplayAlert() -> Bool {
        if !didDisplayAlert && didChangedEmail {
            return true
        } else {
            return false
        }
        return true
    }
    
    @objc override func doneHandler() {
        changeEmail()
    }
    
    private func changeEmail() {
        if !Validator.isValidEmail(emailTextfield.text!) {
            EZAlertController.alert("Error", message: "Your email address is invalid. Please enter a valid address.")
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
}
