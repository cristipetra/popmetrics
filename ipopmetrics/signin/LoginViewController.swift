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
import Hero

private let phoneNumberLength = 12

class LoginViewController: UIViewController {
    
    fileprivate let progressHUD = ProgressHUD(text: "Loading...")
    fileprivate var editablePhoneNumberMask = phoneNumberMask
    fileprivate var lastEnteredDigitIndex = 0
    
    var phoneNumber: String = "+1"
    
    var phoneView: PhoneView = PhoneView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let digitCodeView = DigitCodeView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height));
    
    var isSignupFlow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        phoneView.numberTextField.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        phoneView.sendCodeBtn.addTarget(self, action: #selector(didPressSendPhoneNumber), for: .touchUpInside)
        addPhoneView();
        
        view.addSubview(progressHUD)
        progressHUD.hide()
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        updatePhoneFieldNumber(textField: phoneView.numberTextField, phoneNumberMask: editablePhoneNumberMask)
        phoneView.sendCodeBtn.isEnabled = false
        setNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if self.phoneNumber != "" {
            
            self.textFieldDidBeginEditing(self.phoneView.numberTextField)
            for c in self.phoneNumber {
                let phn = String(c)
                if phn == "+" {
                    continue
                }
                self.textField(self.phoneView.numberTextField, shouldChangeCharactersIn: NSRange(location:0, length:phn.count), replacementString: phn)
                self.updateCursorPosition(textField: self.phoneView.numberTextField)
                
            }
            
        }
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let logoImageView = UIImageView(image: UIImage(named: "logoPop"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        logoImageView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = logoImageView
        
        self.navigationItem.titleView = logoImageView
        let backButton = UIBarButtonItem(image: UIImage(named: "login_back"), style: .plain, target: self, action: #selector(dismissView))
        backButton.tintColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1)
        backButton.setTitlePositionAdjustment(UIOffset.init(horizontal: -55, vertical: 0), for: .default)
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 15
        
        self.navigationItem.leftBarButtonItems = [leftSpace, backButton]
        
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
    
    @objc internal func didPressSendPhoneNumber() {
        if isSignupFlow {
            registerNewUser()
        } else {
            sendCodeBySms()
        }
        
    }
    
    private func registerNewUser() {
        
        let registerBrand = (self.navigationController as! BoardingNavigationController).registerBrand
        let name = registerBrand.name
        let website = registerBrand.website
        let phoneNumber = extractPhoneNumber(text: extractPhoneNumber(text: editablePhoneNumberMask))
        let email = registerBrand.workEmail ?? ""
        
        showProgressIndicator()
        
        UsersApi().registerNewUser(name: name!, website: website!, phone: phoneNumber, email: email) { response in
            self.hideProgressIndicator()
            if response.code == "success" {
                self.performSegue(withIdentifier: "enterCode", sender: self)

            } else {
                let title = "Error"
                let message = response.message ?? "An error has ocurred. Please try again later."
                EZAlertController.alert(title, message: message)

            }
        }
        
    }
    
    private func sendCodeBySms() {
        let phoneNumber = extractPhoneNumber(text: extractPhoneNumber(text: editablePhoneNumberMask))
        showProgressIndicator()
        UsersApi().sendCodeBySms(phoneNumber: phoneNumber) {userDict, error in
            self.hideProgressIndicator()
            if error != nil {
                var message = "An error has occurred. Please try again later."
                if error == ApiError.userMismatch || error == ApiError.userNotAuthenticated {
                    message = "User /Password combination not found."
                }
                EZAlertController.alert("Error", message: message)
            } else {
                if let code = userDict?["code"] as? String {
                    if code == "success" {
                        self.performSegue(withIdentifier: "enterCode", sender: self)
                    }else{
                        var message = "An error has occured. Please try again later."
                        if let msg = userDict?["message"] as? String{
                            message = msg
                        }
                        
                        EZAlertController.alert("Error", message: message)
                    }
                    
                }
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enterCode" {
            guard let vc = segue.destination as? CodeViewController else { return }
            vc.phoneNo =  extractPhoneNumber(text: extractPhoneNumber(text: editablePhoneNumberMask))
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
 
    func updatePhoneFieldNumber(textField: UITextField, phoneNumberMask: String) {
        let threshold = phoneNumberMask.range(for: "#")?.lowerBound ?? phoneNumberMask.range!.upperBound
        let boldRange = Range(uncheckedBounds: (lower: phoneNumberMask.range!.lowerBound, upper: threshold))
        textField.attributedText = phoneNumberMask.replacingOccurrences(of: "#", with: "3").attributed
            .font(UIFont(name: FontBook.regular, size: 24)!)
            .color(.lightGray)
            .font(UIFont(name: FontBook.bold, size: 24)!, range: boldRange)
            .color(PopmetricsColor.buttonTitle, range: boldRange)
    }
    
    func extractPhoneNumber(text: String) -> String {
        return "+\(text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())"
    }

    
    @objc internal func dismissKeyboard() {
        if phoneView.numberTextField.text?.characters.count == 0 {
            phoneView.sendCodeBtn.isUserInteractionEnabled = false
        }
        phoneView.numberTextField.resignFirstResponder()
    }
    
    @objc internal func dismissView() {
        self.dismiss(animated: true, completion: nil)
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
        
        let fullStr = "Haven't registered yet? 👋 ".set(style: first) + "Click here.".set(style: second)
        let attrTitle = "Unrecognized Number".set(style: title)
        
        let banner = NotificationBanner(attributedTitle: attrTitle, attributedSubtitle: fullStr, leftView: nil, rightView: nil, style: BannerStyle.none, colors: nil)
        banner.backgroundColor = PopmetricsColor.notificationBGColor
        banner.duration = TimeInterval(exactly: 7.0)!
        banner.show()
        
        banner.onTap = {
            self.dismiss(animated: true, completion: {
                self.navigationController?.performSegue(withIdentifier: "signUpSeguea", sender: self)
            })
            
        }
    }
    
    func moveView(value :CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.phoneView.changeYPosItems(yPos: value)
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneView.sendCodeBtn.isUserInteractionEnabled = true
        
        moveView(value: -140)
        
        updateCursorPosition(textField: textField)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if phoneView.numberTextField.text?.count == 0 {
            phoneView.sendCodeBtn.isUserInteractionEnabled = false
        }
        phoneView.numberTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            let matches = editablePhoneNumberMask.findMatches(for: "[0-9]")
            guard matches.count >= 1,
                let lastDigitRange = matches.last?.range else { return false }
            editablePhoneNumberMask = editablePhoneNumberMask
                .replacingCharacters(in: Range(lastDigitRange, in: editablePhoneNumberMask)!, with: "#")
        } else {
            guard let slot = editablePhoneNumberMask.range(for: "#") else { return false }
            editablePhoneNumberMask = editablePhoneNumberMask.replacingCharacters(in: slot, with: string)
        }
        updatePhoneFieldNumber(textField: textField, phoneNumberMask: editablePhoneNumberMask)
        updateCursorPosition(textField: textField)
        //phoneView.sendCodeBtn.isEnabled = extractPhoneNumber(text: editablePhoneNumberMask).count == phoneNumberLength
        if extractPhoneNumber(text: editablePhoneNumberMask).count >= phoneNumberLength - 1 {
            phoneView.sendCodeBtn.isEnabled = true
        } else {
            phoneView.sendCodeBtn.isEnabled = false
        }
        
        return false
    }
    
    private func updateCursorPosition(textField: UITextField) {
        guard let lastDigitRange = editablePhoneNumberMask.findMatches(for: "[+0-9]").last?.range else { return }
        let slotPosition = Range(lastDigitRange, in: phoneNumberMask)!.upperBound.encodedOffset
        let cursorPosition = textField.position(from: textField.beginningOfDocument, offset: slotPosition)!
        textField.selectedTextRange = textField.textRange(from: cursorPosition, to: cursorPosition)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            moveView(value: -70)
    }
    
}

extension LoginViewController {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
