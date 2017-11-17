//
//  SettingsOverlayUrlViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsOverlayUrlViewController: SettingsBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        titleWindow = "Overlay Action URL"
    }
    
    override func cancelHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
