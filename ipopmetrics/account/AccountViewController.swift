//
//  AccountViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//
import UIKit
import RSKImageCropper


class AccountViewController: BaseViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameTextField: TextFieldValidator!
    @IBOutlet weak var emailLabel: UILabel!
    
    fileprivate var imageCropVC: RSKImageCropViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = "Popmetrics "+version
        }
        nameTextField.addTarget(self, action: #selector(didChangeNameValue), for: .editingDidEnd)
        nameTextField.placeholder = "Name"
        // nameTextField.title = "Name"
        nameTextField.textColor = UIColor.black
        nameTextField.keyboardType = .emailAddress
        
        
        // Style elements
        imageButton.layer.cornerRadius = imageButton.bounds.size.height / 2
        imageButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let localUser = UsersStore.getInstance().getLocalUserAccount()
        nameTextField.text = localUser.name
        emailLabel.text = localUser.email
        let imageUrl = ApiUrls.getAccountThumbnailUrl(localUser.id!)
        UsersApi().getImageWithUrl(imageUrl) { image, error in
            if error != nil { return }
            DispatchQueue.main.async(execute: {
                self.imageButton.setImage(image, for: UIControlState())
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageCropVC != nil {
            present(imageCropVC!, animated: true, completion: nil)
        }
    }
    
    fileprivate func changeProfileImage(_ image: UIImage) {
        let usersApi = UsersApi()
        
        showProgressIndicator()
        usersApi.updateUserAccount(nameTextField.text!, image: image) { error in
            self.hideProgressIndicator()
            if let err = error {
                self.handleApiError(err) {}
                return
            }
            DispatchQueue.main.async(execute: {
                self.imageButton.setImage(image, for: UIControlState())
            })
            
            // Call getAccountInfo to re-load account information to local storage
            usersApi.getAccountInfo { details, error in}
        }
    }
    
    @IBAction func didPressChangeImage(_ sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func didChangeNameValue(_ sender: TextFieldValidator) {
        let localUser = UsersStore.getInstance().getLocalUserAccount()
        if let name = nameTextField.text {
            localUser.name = name
            UsersStore.getInstance().storeLocalUserAccount(localUser)
        }
    }
    
    
    @IBAction func didPressLogOut(_ sender: AnyObject) {
//        UsersStore.getInstance().clearCredentials()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.setInitialViewController()
        print("Not implemented yet!")
    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        nameTextField.endEditing(true)
    }
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let cropVC = RSKImageCropViewController(image: image, cropMode: .square)
        cropVC.delegate = self
        imageCropVC = cropVC
        dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        imageCropVC = nil
        changeProfileImage(croppedImage)
        dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        imageCropVC = nil
        changeProfileImage(croppedImage)
        dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        imageCropVC = nil
        dismiss(animated: true, completion: nil)
    }
}
