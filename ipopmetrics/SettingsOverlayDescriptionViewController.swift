//
//  SettingsOverlayDescriptionViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsOverlayDescriptionViewController: SettingsBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        titleWindow = "Overlay Description"
    }

    override func cancelHandler() {
        self.navigationController?.popViewController(animated: true)
    }

}
