//
//  SettingsFacebookViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsFacebookViewController: SettingsBaseViewController {

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

}
