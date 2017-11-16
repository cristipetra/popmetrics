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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc override func doneHandler() {
        
    }
}

