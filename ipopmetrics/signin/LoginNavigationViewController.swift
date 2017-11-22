//
//  LoginNavigationViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class LoginNavigationViewController: UINavigationController {
    
    var loginVC: LoginViewController = LoginViewController();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.backgroundColor = UIColor.white
        
        self.pushViewController(loginVC, animated: false)
    }

}