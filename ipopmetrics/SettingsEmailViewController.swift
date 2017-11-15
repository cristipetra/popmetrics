//
//  SettingsEmailViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    let user = UsersStore.getInstance().getLocalUserAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        updateView()
    }
    
    private func updateView() {
        emailTextfield.text = user.email
    }
    
    @IBAction func handlerConfirmEmail(_ sender: UIButton) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUpNavigationBar() {
        
        let titleLabel = UILabel()
        titleLabel.text  = "Professional Email"
        let sideBtnFont: UIFont!
        
        titleLabel.textColor = UIColor.black
        let titleView = UIView()
        
        if UIScreen.main.bounds.width < 375 {
            titleLabel.font = UIFont(name: FontBook.semibold, size: 14)
            sideBtnFont = UIFont(name: FontBook.semibold, size: 14)
            titleLabel.frame = CGRect(x: 0, y: 0, width: 130, height: 20)
            titleView.frame = CGRect(x: 0, y: 0, width: 130, height: 20)
        } else {
            titleLabel.font = UIFont(name: FontBook.semibold, size: 17)
            sideBtnFont = UIFont(name: FontBook.semibold, size: 17)
            titleLabel.frame = CGRect(x: 0, y: 0, width: 170, height: 20)
            titleView.frame = CGRect(x: 0, y: 0, width: 170, height: 20)
        }
        
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelHandler))
        cancelButton.tintColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: sideBtnFont], for: .normal)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneHandler))
        doneButton.tintColor = UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1)
        doneButton.setTitleTextAttributes([NSAttributedStringKey.font: sideBtnFont], for: .normal)
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func cancelHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneHandler() {
        
    }
}

