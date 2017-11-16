//
//  SettingsLogoViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsLogoViewController: SettingsBaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var imagePlaceholderLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(chooseImageHandler))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(imageViewTap)
        
        
        titleWindow = "Brand Logo"
        setupNavigationBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func chooseImageHandler() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        logoImageView.image = image
        imagePlaceholderLbl.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    @objc override func cancelHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc override func doneHandler() {
        showAlertDialog()
    }
    
    func showAlertDialog() {
        //Alert.showAlertDialog(parent: self)
        Alert.showActionSheet(parent: self)
    }
    
}

