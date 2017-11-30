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
    private var isDescriptionChanged: Bool = false
    
    let userSettings: UserSettings = UserStore.getInstance().getLocalUserSettings()
    
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
        if shouldDisplayAlert() {
            Alert.showAlertDialog(parent: self, action: { (action) -> (Void) in
                switch action {
                case .cancel:
                    self.navigationController?.popViewController(animated: true)
                    break
                case .save:
                    
                    break
                }
            })
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func shouldDisplayAlert() -> Bool {
        if (descriptionText.text != userSettings.overlayDescription!) {
            return true
        } else {
            return false
        }
    }

}
