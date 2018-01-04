//
//  SettingsOverlayDescriptionViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController

class SettingsOverlayDescriptionViewController: SettingsBaseViewController, UITextViewDelegate {

    @IBOutlet weak var descriptionText: UITextView!
    private var isDescriptionChanged: Bool = false
    private var initialDescription: String?
    
    let userSettings: UserSettings = UserStore.getInstance().getLocalUserSettings()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionText.delegate = self
        descriptionText.text = ""
        setupNavigationBar()
        titleWindow = "Overlay Description"
        doneButton.isEnabled = false
        
        updateView()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == initialDescription {
            isDescriptionChanged = false
            doneButton.isEnabled = false
        } else {
            isDescriptionChanged = true
            doneButton.isEnabled = true
            
        }
    }
    
    private func updateView() {
        if let _ = userSettings.overlayDescription {
            descriptionText.text = userSettings.overlayDescription!
            initialDescription = userSettings.overlayDescription!
        }
    }

    override func doneHandler() {
        changeOverlayDescription()
    }
    
    private func changeOverlayDescription() {
        print("change overlay description")
        SettingsApi().changeOverlayDescription(description: descriptionText.text ) { (error) in
            if error == nil {
                self.closeWindow()
            } else {
                let message = "Something went wrong. Please try again later."
                EZAlertController.alert("Error", message: message)
            }
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
                    self.changeOverlayDescription()
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
