//
//  SettingsEmailViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsEmailViewController: SettingsBaseViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    let user = UsersStore.getInstance().getLocalUserAccount()
    
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
        if emailTextfield.text != user.email {
            Alert.showAlertDialog(parent: self, action: { (action) -> (Void) in
                switch action {
                case .cancel:
                    self.navigationController?.popViewController(animated: true)
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
    
    @objc override func doneHandler() {
        changeEmail()
    }
    
    private func changeEmail() {
        self.navigationController?.popViewController(animated: true)
    }
}

