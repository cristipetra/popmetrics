//
//  LoginViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 16/01/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit
import Crashlytics
import EZAlertController
import SwiftRichString
import NotificationBannerSwift
import SafariServices

class LoginViewController: UIViewController {
    
    fileprivate let progressHUD = ProgressHUD(text: "Loading...")
    
    var phoneView: PhoneView = PhoneView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let digitCodeView = DigitCodeView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneView.numberTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        phoneView.sendCodeBtn.addTarget(self, action: #selector(didPressSendPhoneNumber), for: .touchUpInside)
        addPhoneView();
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        view.addSubview(progressHUD)
        progressHUD.hide()
        
    }
    
    func rotated() {
        if self.digitCodeView.isDescendant(of: self.view) {
            self.digitCodeView.reloadSubViews()
        } else {
            self.phoneView.reloadSubViews()
        }
        
    }
    
    func addPhoneView() {
        self.view.addSubview(phoneView);
        phoneView.translatesAutoresizingMaskIntoConstraints = false
        phoneView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        phoneView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        phoneView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        phoneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    func addDigitCodeView() {
        self.view.addSubview(digitCodeView)
        digitCodeView.translatesAutoresizingMaskIntoConstraints = false
        digitCodeView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        digitCodeView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        digitCodeView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        digitCodeView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    internal func setProgressIndicatorText(_ text: String?) {
        progressHUD.text = text
    }
    
    internal func showProgressIndicator() {
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = false
            self.progressHUD.show()
        })
    }
    
    internal func hideProgressIndicator() {
        DispatchQueue.main.async(execute: {
            self.view.isUserInteractionEnabled = true
            self.progressHUD.hide()
        })
    }
    
    internal func presentAlertWithTitle(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    internal func didPressSendPhoneNumber() {
        let phoneNumber = phoneView.numberTextField.text!
        showProgressIndicator()
        UsersApi().sendCodeBySms(phoneNumber: phoneNumber) {userDict, error in
            self.hideProgressIndicator()
            if error != nil {
                var message = "An error has occurred. Please try again later."
                if error == ApiError.userMismatch || error == ApiError.userNotAuthenticated {
                    message = "User /Password combination not found."
                }
                EZAlertController.alert("Error", message: message)
                return
            } else {
                if let code = userDict?["code"] as? String {
                    if code == "invalid_input" {
                        self.sendInAppNotification()
                        return
                    }
                }
                
                let codeVC = CodeViewController();
                codeVC.phoneNo = phoneNumber;
                self.present(codeVC, animated: true, completion: nil)
            }
        }
    }
    
    internal func showViewControllerWithStoryboardID(_ sbID: String) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: sbID)
        DispatchQueue.main.async(execute: {
            self.present(vc, animated: true, completion: nil)
        })
    }
    
    internal func showMainNavigationController() {
        showViewControllerWithStoryboardID("FEED_VC")
    }
    
    internal func dismissKeyboard() {
        if phoneView.numberTextField.text?.characters.count == 0 {
            phoneView.sendCodeBtn.isUserInteractionEnabled = false
            phoneView.sendCodeBtn.layer.backgroundColor = UIColor(red: 255/255, green: 210/255, blue: 55/255, alpha: 1.0).cgColor
            phoneView.sendCodeBtn.setTitleColor(UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0), for: .normal)
        }
        phoneView.numberTextField.resignFirstResponder()
    }
    
}

// MARK: - Notification
extension LoginViewController {
    internal func sendInAppNotification() {
        let first = Style.default {
            $0.font = FontAttribute.init("OpenSans", size: 12)
            $0.color = UIColor.white
        }
        
        let second = Style.default {
            $0.font = FontAttribute.init("OpenSans-Bold", size: 12)
            $0.underline = UnderlineAttribute.init(color: SRColor.white, style: NSUnderlineStyle.styleSingle)
            $0.color = UIColor.white
        }
        
        let title = Style.default {
            $0.font = FontAttribute.init("OpenSans-Semibold", size: 12)
            $0.color = UIColor(red: 179/255, green: 50/255, blue: 39/255, alpha: 1.0)
        }
        
        let fullStr = "Haven't spoken with Aimee yet? 👋 ".set(style: first) + "Click here.".set(style: second)
        let attrTitle = "Unrecognized Number".set(style: title)
        
        let banner = NotificationBanner(attributedTitle: attrTitle, attributedSubtitle: fullStr, leftView: nil, rightView: nil, style: BannerStyle.none, colors: nil)
        banner.backgroundColor = PopmetricsColor.notificationBGColor
        banner.duration = TimeInterval(exactly: 7.0)!
        banner.show()
        
        banner.onTap = {
            self.openURLInside(url: Config.appWebLink)
        }
    }
    
    func moveButton(moveValue :CGFloat) {
        self.phoneView.buttonBottomConstraint?.isActive = false
        
        UIView.animate(withDuration: 0.3) {
            self.phoneView.buttonBottomConstraint?.constant = moveValue
            self.phoneView.buttonBottomConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneView.sendCodeBtn.isUserInteractionEnabled = true
        phoneView.sendCodeBtn.layer.backgroundColor = UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1.0).cgColor
        phoneView.sendCodeBtn.setTitleColor(UIColor.white, for: .normal)
        if phoneView.numberTextField.text == "" {
            phoneView.numberTextField.text = "+1"
        }
        moveButton(moveValue: -240)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if phoneView.numberTextField.text?.characters.count == 0 {
            phoneView.sendCodeBtn.isUserInteractionEnabled = false
            phoneView.sendCodeBtn.layer.backgroundColor = UIColor(red: 255/255, green: 210/255, blue: 55/255, alpha: 1.0).cgColor
            phoneView.sendCodeBtn.setTitleColor(UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0), for: .normal)
        }
        phoneView.numberTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveButton(moveValue: -136)
    }
    
}

extension LoginViewController {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
