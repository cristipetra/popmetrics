//
//  SettingsSocialViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 20/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsSocialViewController: SettingsBaseViewController {
    
    @IBOutlet weak var brandURLLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //titleWindow = "FACEBOOK ACCOUNT"
        setupNavigationWithBackButton()
    }
    
    func displayTwitter() {
        titleWindow = "TWITTER ACCOUNT"
    }
    
    func displayLinkedin() {
        titleWindow = "LINKEDIN ACCOUNT"
    }
    
    func displayFacebook() {
        titleWindow = "FACEBOOK ACCOUNT"
    }
}

