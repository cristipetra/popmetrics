//
//  EmailViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController

protocol EmailProtocol {
    func didSetEmail(_ email: String)
}

class EmailViewController: SettingsBaseTableViewController {
    
    private var didDisplayAlert: Bool = false
    internal var isValuesChanged: Bool = false
    
    var emailDelegate: EmailProtocol!

    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        emailTxt.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    private func shouldDisplayAlert() -> Bool {
        if !didDisplayAlert && isValuesChanged {
            return true
        } else {
            return false
        }
        return true
    }
    
    @objc override func cancelHandler() {
        if shouldDisplayAlert() {
            didDisplayAlert = true
            Alert.showAlertDialog(parent: self, action: { (action) -> (Void) in
                switch action {
                case .cancel:
                    self.navigationController?.popViewController(animated: true)
                    break
                case .save:
                    self.changeEmail()
                    break
                default:
                    break
                }
            })
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func doneHandler() {
        changeEmail()
    }

    @IBAction func textFieldDidChange(_ textField: UITextField) {
        isValuesChanged =  textField.text != "" ? true : false
    }
    
    func changeEmail() {
        if !Validator.isValidEmail(emailTxt.text!) {
            EZAlertController.alert("Enter a valid email address!")
            return
        }
        
        emailDelegate.didSetEmail(emailTxt.text!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc internal func dismissKeyboard() {
        emailTxt.resignFirstResponder()
    }
}

extension EmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

