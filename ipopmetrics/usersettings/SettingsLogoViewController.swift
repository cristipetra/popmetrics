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
    
    var imagePicker: UIImagePickerController!
    
    private var imageChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(chooseImageHandler))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(imageViewTap)
        
        
        titleWindow = "Brand Logo"
        setupNavigationBar()
        
        displayEmptyImage()
    }
    
    func displayImage() {
        if isSocialMediConnected() {
            displayImageFromSocialMedia()
        } else {
            displayEmptyImage()
        }
    }
    
    func isSocialMediConnected() -> Bool{
        return false
    }
    
    
    func displayImageFromSocialMedia() {
        
    }
    
    func displayEmptyImage() {
        logoImageView.image = UIImage(named: "logo_placeholder_settings")
        logoImageView.contentMode = .scaleAspectFit
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            imageChanged = true
        }
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
        guard let resizedImage = resizeImage(image: image)  else {
            return
        }
        logoImageView.image = resizedImage
        dismiss(animated: true, completion: nil)
    }
    
    func saveImageLogo() {
        print("save image logo")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc override func cancelHandler() {
        if shouldDisplayAlert() {
            Alert.showAlertDialog(parent: self, action: { (action) -> (Void) in
                switch action {
                case .cancel:
                    self.navigationController?.popViewController(animated: true)
                    break
                case .save:
                    self.saveImageLogo()
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
        if imageChanged {
            saveImageLogo()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func handlerReplaceLogo(_ sender: Any) {
        showAlertDialog()
    }
    
    func showAlertDialog() {
        Alert.showActionSheet(parent: self) { (action) -> (Void) in
            switch action {
            case .openGallery:
                self.openGallery()
            case .takePicture:
                self.takePicture()
                break
            default:
                break
            }
        }
    }
    
    private func takePicture() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // 1 x 1 ratio resize
    func resizeImage(image: UIImage) -> UIImage? {
        
        let widthRatio = image.size.height / image.size.width
        let heightRation: CGFloat = 1
        
        var newSize: CGSize = CGSize.zero
        
        newSize = CGSize(width: image.size.width * widthRatio, height: image.size.height * heightRation)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
}
