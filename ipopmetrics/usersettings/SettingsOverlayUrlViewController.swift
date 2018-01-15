//
//  SettingsOverlayUrlViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController

class SettingsOverlayUrlViewController: SettingsBaseViewController {
    
    @IBOutlet weak var textUrl: UITextField!
    
    private var isUrlChanged: Bool = false
    private var initialURL: String?
    
    let userSettings: UserSettings = UserStore.getInstance().getLocalUserSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        titleWindow = "Overlay Action URL"
        doneButton.isEnabled = false
        
        textUrl.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        updateView()
    }
    
    private func updateView() {
        if let url = UserStore.currentBrand?.overlayDetails?.ctaLink {
            textUrl.text = url
            initialURL = url
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textUrl.text == initialURL {
            isUrlChanged = false
            doneButton.isEnabled = false
        } else {
            isUrlChanged = true
            doneButton.isEnabled = true
        }
    }
    
    override func cancelHandler() {
        if isUrlChanged {
            Alert.showAlertDialog(parent: self, action: { (action) -> (Void) in
                switch action {
                case .cancel:
                    self.navigationController?.popViewController(animated: true)
                    break
                case .save:
                    self.changeOverlayURL()
                    break
                }
            })
            return
        }
        self.navigationController?.popViewController(animated: true)
    
    }
    
    override func doneHandler() {
        changeOverlayURL()
    }
    
    private func changeOverlayURL() {
        print("change overlay url")
        let overlay = UserStore.currentBrand?.overlayDetails
        overlay?.ctaLink = self.textUrl.text
        
        SettingsApi().postOverlay( overlay!, brandId: (UserStore.currentBrand?.id)!) { brand in
            UserStore.currentBrand = brand
            self.closeWindow()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
