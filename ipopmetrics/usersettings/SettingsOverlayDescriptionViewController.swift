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
        descriptionText.text = UserStore.currentBrand?.overlayDetails?.message
        initialDescription = UserStore.currentBrand?.overlayDetails?.message
    }

    override func doneHandler() {
        changeOverlayDescription()
    }
    
    private func changeOverlayDescription() {
        print("change overlay description")
        print("change overlay url")
        let overlay = UserStore.currentBrand?.overlayDetails
        overlay?.message = descriptionText.text
        
        SettingsApi().postOverlay( overlay!, brandId: (UserStore.currentBrand?.id)!) { brand in
            UserStore.currentBrand = brand
            self.closeWindow()
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
        if (descriptionText.text != UserStore.currentBrand?.overlayDetails?.message) {
            return true
        } else {
            return false
        }
    }

}
