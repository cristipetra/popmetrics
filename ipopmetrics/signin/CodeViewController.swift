//
//  CodeViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Crashlytics
import EZAlertController
import SafariServices
import Hero
import ObjectMapper
import Intercom
import UserNotifications

class CodeViewController: BaseViewController {
    
    var phoneNo: String?
    fileprivate var editableCodeMask = codeMask
    
    let digitCodeView = DigitCodeView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height));
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(digitCodeView)
        
        digitCodeView.didMoveToSuperview()
        digitCodeView.digitextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        digitCodeView.sendCodeBtn.addTarget(self, action: #selector(didPressSendSmsCode), for: .touchUpInside)
        digitCodeView.contactBtn.addTarget(self, action: #selector(didPressContact), for: .touchUpInside)
        digitCodeView.resendCodeBtn.addTarget(self, action: #selector(didPressResendCode), for: .touchUpInside)
        
        updateDigitFieldNumber(textField: digitCodeView.digitextField, mask: editableCodeMask)
        isHeroEnabled = true
        digitCodeView.sendCodeBtn.isEnabled = false
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        setNavigationBar()
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
    
    
    @objc internal func dismissKeyboard() {
        if digitCodeView.digitextField.text?.characters.count == 0 {
            digitCodeView.sendCodeBtn.isUserInteractionEnabled = false
            digitCodeView.sendCodeBtn.layer.backgroundColor = UIColor(red: 255/255, green: 210/255, blue: 55/255, alpha: 1.0).cgColor
            digitCodeView.sendCodeBtn.setTitleColor(UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0), for: .normal)
        }
        digitCodeView.digitextField.resignFirstResponder()
    }
    
    
    @objc func didPressSendSmsCode(_ sender: Any) {
        digitCodeView.digitextField.resignFirstResponder()
        
        let smsCode = extractCode(text: editableCodeMask)
        let phoneNumber = phoneNo!
        showProgressIndicator()
        UsersApi().logInWithSmsCode(phoneNumber, smsCode: smsCode) {responseWrapper, error in
            self.hideProgressIndicator()
            if error != nil {
                let message = "An error has occurred. Please try again later."
                EZAlertController.alert("Error", message: message)
                return
            }
            
            let code = responseWrapper?.code
            if code != "success" {
                EZAlertController.alert("Authentication failed.", message: (responseWrapper?.message)!)
                return
            }
            
            let userAccount = responseWrapper?.data
            if let teams = userAccount?.profileDetails?.brandTeams {
                UserStore.getInstance().storeLocalUserAccount(userAccount!)
                UserStore.currentBrandId = teams[0].brandId!
                SyncService.getInstance().syncBrandDetails(silent: true)
                
                //Fixme: This is tmp json until it will be received data
                let tmpUserSettingsJson = [
                    "user_account": userAccount?.toJSONString(),
                    "current_brand": teams[0],
                    "allow_sounds": true,
                    "overlay_description": "Overlay description",
                    "overlay_actions": "Visit Website, Learn More, Find Out More",
                    "overlay_action_url": "http://www.actionURL.com"
                    ] as [String : Any]
                
                let userSettings = Mapper<UserSettings>().map(JSONObject: tmpUserSettingsJson)
                
                UserStore.getInstance().storeLocalUserSettings(userSettings!)
                
                //Intercom
                let currentUser = UserStore.getInstance().getLocalUserAccount()
                
                Intercom.registerUser(withUserId: currentUser.id!)
                /*
                 let brand = ICMCompany()
                 brand.name = UsersStore.getInstance().currentBrandId
                 brand.companyId = UsersStore.getInstance().currentBrandName
                 */
                let userAttributes = ICMUserAttributes()
                //userAttributes.companies = [company]
                
                if currentUser.name != nil && !(currentUser.name?.isEmpty)! {
                    userAttributes.name = currentUser.name
                }
                if currentUser.email != nil && !(currentUser.email?.isEmpty)! {
                    userAttributes.email = currentUser.email
                }
                if currentUser.phone != nil && !(currentUser.phone?.isEmpty)! {
                    userAttributes.phone = currentUser.phone
                }
                
                Intercom.updateUser(userAttributes)
                
                SyncService.getInstance().syncAll(silent: false)
                
                self.showNextScreen()
            }
            else {
                EZAlertController.alert("Authentication failed.", message: "No brands associated with the account.")
                return
            }
        }
        
    }
    
    private func showNextScreen() {
        self.showSocialScreen()
        /*
        if let currentBrand = UserStore.currentBrand {
            if let twitterDetails = currentBrand.twitterDetails {
                if twitterDetails.name != nil {
                    self.checkNotifcations()
                    return
                }
            }
        }
        
       self.showSocialScreen()
         */
    }
    
    private func checkNotifcations() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .denied {
                self.showManualEnableNotifications()
            }
            if settings.authorizationStatus == .notDetermined {
                self.showPushNotificationsScreen()
            }
            if settings.authorizationStatus == .authorized {
                self.showOnboardingFinalScreen()
            }
        }
        
    }
    
    internal func showOnboardingFinalScreen() {
        let finalOnboardingVC = OnboardingFinalView()
        self.navigationController?.pushViewController(finalOnboardingVC, animated: true)
    }
    
    internal func showManualEnableNotifications() {
        let notificationsVC = AppStoryboard.Notifications.instance.instantiateViewController(withIdentifier: ViewNames.SBID_PUSH_MANUALLY_NOTIFCATIONS_VC)
        self.navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    internal func showPushNotificationsScreen() {
        let notificationsVC = AppStoryboard.Notifications.instance.instantiateViewController(withIdentifier: ViewNames.SBID_PUSH_NOTIFICATIONS_VC)
        self.navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    @objc internal func didPressResendCode() {
        let phoneNumber = phoneNo!
        showProgressIndicator()
        UsersApi().sendCodeBySms(phoneNumber: phoneNumber) {userDict, error in
            self.hideProgressIndicator()
            if error != nil {
                let message = "An error has occurred. Please try again later."
                EZAlertController.alert("Error", message: message)
                return
            }
            self.clearCodeTextField()
        }
    }
    
    private func clearCodeTextField() {
        guard let code = self.digitCodeView.digitextField.text else { return }
        for _ in code {
            self.textField(self.digitCodeView.digitextField, shouldChangeCharactersIn: NSRange(location:0, length:1), replacementString: "")
        }
    }
    
    @objc func didPressContact() {
        let message = "mailto:" + Config.mailContact
        UIApplication.shared.open(URL(string: message)!, options: [:], completionHandler: nil)
    }
    
    func updateDigitFieldNumber(textField: UITextField, mask: String) {
        let threshold = mask.range(for: "#")?.lowerBound ?? mask.range!.upperBound
        let boldRange = Range(uncheckedBounds: (lower: mask.range!.lowerBound, upper: threshold))
        textField.attributedText = mask.replacingOccurrences(of: "#", with: "3").attributed
            .font(UIFont(name: FontBook.regular, size: 24)!)
            .color(.lightGray)
            .font(UIFont(name: FontBook.bold, size: 24)!, range: boldRange)
            .color(PopmetricsColor.buttonTitle, range: boldRange)
    }
    
    fileprivate func updateCursorPosition(textField: UITextField) {
        let slotPosition = editableCodeMask.range(for: "#")?.lowerBound.encodedOffset ?? codeMask.count
        
        let cursorPosition = textField.position(from: textField.beginningOfDocument, offset: slotPosition)!
        textField.selectedTextRange = textField.textRange(from: cursorPosition, to: cursorPosition)
    }
    
    @objc internal func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    internal func showSocialScreen() {
    
        let verifySocialVC = AppStoryboard.Boarding.instance.instantiateViewController(withIdentifier: "loginSocial") as! LoginSocialViewController
       
        self.navigationController?.pushViewController(verifySocialVC, animated: true)
        
    }
    
    @objc internal func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func extractCode(text: String) -> String {
        return text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

// MARK: - UITextFieldDelegate

extension CodeViewController: UITextFieldDelegate {
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        updateCursorPosition(textField: textField)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            guard let lastDigitRange = editableCodeMask.findMatches(for: "[0-9]").last?.range else { return false }
            editableCodeMask = editableCodeMask
                .replacingCharacters(in: Range(lastDigitRange, in: editableCodeMask)!, with: "#")
        } else {
            guard let slot = editableCodeMask.range(for: "#") else { return false }
            editableCodeMask = editableCodeMask.replacingCharacters(in: slot, with: string)
        }
        updateDigitFieldNumber(textField: textField, mask: editableCodeMask)
        updateCursorPosition(textField: textField)
        digitCodeView.sendCodeBtn.isEnabled = extractCode(text: editableCodeMask).count >= 3
        return false
    }
}

extension CodeViewController {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}

