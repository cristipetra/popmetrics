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
    
    private var imageChanged: Bool = false
    
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
            imageChanged = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        logoImageView.image = image
        imagePlaceholderLbl.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    @objc override func cancelHandler() {
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
        return imageChanged
    }
    
    @objc override func doneHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handlerReplaceLogo(_ sender: Any) {
        showAlertDialog()
    }
    
    func showAlertDialog() {
        //Alert.showAlertDialog(parent: self)
        Alert.showActionSheet(parent: self)
    }
    
}

