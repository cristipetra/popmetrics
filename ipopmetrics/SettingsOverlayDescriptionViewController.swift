//
//  SettingsOverlayDescriptionViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsOverlayDescriptionViewController: SettingsBaseViewController {

    @IBOutlet weak var descriptionText: UITextView!
    
    let userSettings: UserSettings = UsersStore.getInstance().getLocalUserSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionText.text = ""
        setupNavigationBar()
        titleWindow = "Overlay Description"
        
        updateView()
    }
    
    private func updateView() {
        if let _ = userSettings.overlayDescription {
            descriptionText.text = userSettings.overlayDescription!
        }
    }

    override func cancelHandler() {
        self.navigationController?.popViewController(animated: true)
    }

}
