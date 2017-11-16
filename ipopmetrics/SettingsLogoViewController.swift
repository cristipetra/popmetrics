//
//  SettingsLogoViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsLogoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var imagePlaceholderLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViewTap = UITapGestureRecognizer(target: self, action: #selector(chooseImageHandler))
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(imageViewTap)
        
        setUpNavigationBar()
        
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
    
    private func setUpNavigationBar() {
        
        let titleLabel = UILabel()
        titleLabel.text  = "Professional Email"
        let sideBtnFont: UIFont!
        
        titleLabel.textColor = UIColor.black
        let titleView = UIView()
        
        if UIScreen.main.bounds.width < 375 {
            titleLabel.font = UIFont(name: FontBook.semibold, size: 14)
            sideBtnFont = UIFont(name: FontBook.semibold, size: 14)
            titleLabel.frame = CGRect(x: 0, y: 0, width: 130, height: 20)
            titleView.frame = CGRect(x: 0, y: 0, width: 130, height: 20)
        } else {
            titleLabel.font = UIFont(name: FontBook.semibold, size: 17)
            sideBtnFont = UIFont(name: FontBook.semibold, size: 17)
            titleLabel.frame = CGRect(x: 0, y: 0, width: 170, height: 20)
            titleView.frame = CGRect(x: 0, y: 0, width: 170, height: 20)
        }
        
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelHandler))
        cancelButton.tintColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: sideBtnFont], for: .normal)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneHandler))
        doneButton.tintColor = UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1)
        doneButton.setTitleTextAttributes([NSAttributedStringKey.font: sideBtnFont], for: .normal)
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    
    @objc private func cancelHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneHandler() {
        showAlertDialog()
    }
    
    func showAlertDialog() {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let messageFont = [NSAttributedStringKey.font: UIFont(name: FontBook.regular, size: 15)]
        let messageColor = [NSAttributedStringKey.foregroundColor: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)]
        
        let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontBook.bold, size: 16), NSAttributedStringKey.foregroundColor: UIColor(red: 49/255, green: 63/255, blue: 72/255, alpha: 1)]
        
        let messageAttributes : [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontBook.regular, size: 15), NSAttributedStringKey.foregroundColor: UIColor(red: 49/255, green: 63/255, blue: 72/255, alpha: 1)]
        
        let titleAttrString = NSMutableAttributedString(string: "There are unsaved changes.", attributes: titleAttributes)
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        
        let messageAttrString = NSMutableAttributedString(string: "Are you sure you would like to leave them?", attributes: messageAttributes)
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save Changes", style: .default) { (save) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

