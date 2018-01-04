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
        if let url = UserStore.currentBrand?.domainURL {
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
        SettingsApi().changeOverlayURL(url: textUrl.text! ) { (error) in
            if error == nil {
                self.closeWindow()
            } else {
                let message = "Something went wrong. Please try again later."
                EZAlertController.alert("Error", message: message)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
