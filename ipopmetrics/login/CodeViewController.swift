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

class CodeViewController: UIViewController {
    
    fileprivate let progressHUD = ProgressHUD(text: "Loading...")
    var phoneNo: String?
    
    let digitCodeView = DigitCodeView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height));


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(digitCodeView)
        
        digitCodeView.digitextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        digitCodeView.sendCodeBtn.addTarget(self, action: #selector(didPressSendSmsCode), for: .touchUpInside)
        digitCodeView.contactBtn.addTarget(self, action: #selector(didPressContact), for: .touchUpInside)
        digitCodeView.resendCodeBtn.addTarget(self, action: #selector(didPressResendCode), for: .touchUpInside)
        
        
        view.addSubview(progressHUD)
        progressHUD.hide()
    }
    
    
    internal func dismissKeyboard() {
        if digitCodeView.digitextField.text?.characters.count == 0 {
            digitCodeView.sendCodeBtn.isUserInteractionEnabled = false
            digitCodeView.sendCodeBtn.layer.backgroundColor = UIColor(red: 255/255, green: 210/255, blue: 55/255, alpha: 1.0).cgColor
            digitCodeView.sendCodeBtn.setTitleColor(UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0), for: .normal)
        }
        digitCodeView.digitextField.resignFirstResponder()
    }
    
    
    func didPressSendSmsCode(_ sender: Any) {
        
        let smsCode = digitCodeView.digitextField.text!
        let phoneNumber = phoneNo!
        showProgressIndicator()
        UsersApi().logInWithSmsCode(phoneNumber, smsCode: smsCode) {responseDict, error in
            self.hideProgressIndicator()
            if error != nil {
                let message = "An error has occurred. Please try again later."
                EZAlertController.alert("Error", message: message)
                return
            }
            let code = responseDict?["code"] as! String
            if code != "success" {
                let message = responseDict?["message"] as! String
                EZAlertController.alert("Authentication failed.", message: message)
                return
            }
            
            let userDict = responseDict?["user"] as! [String: Any]
            self.storeUserDict(userDict) { success in
                if !success {
                    Crashlytics.sharedInstance().crash()
                    let message = "An error has occurred. Please try again later."
                    EZAlertController.alert("Error", message: message)
                    return
                }
                
                let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
                if notificationType == [] {
                    self.showPushNotificationsScreen()
                } else {
                    self.showVideoScreen()
                }
            }
        }
        
    }
    
    internal func didPressResendCode() {
        let phoneNumber = phoneNo!
        showProgressIndicator()
        UsersApi().sendCodeBySms(phoneNumber: phoneNumber) {userDict, error in
            self.hideProgressIndicator()
            if error != nil {
                let message = "An error has occurred. Please try again later."
                EZAlertController.alert("Error", message: message)
                return
            }
        }
    }
    
    func didPressContact() {
        let message = "mailto:" + Config.mailContact
        UIApplication.shared.open(URL(string: message)!, options: [:], completionHandler: nil)
    }
    
    internal func storeUserDict(_ userDict: [String: Any]?, callback: (_ success: Bool) -> Void) {
        if let userDict = userDict {
            let userID = userDict["id"] as? String
            let authToken = userDict["authentication_token"] as? String
            
            if userID == nil || authToken == nil {
                callback(false)
                return
            }
            
            let user = User()
            user.id = userID!
            user.authToken = authToken!
            user.name = userDict["name"] as! String?
            user.email = userDict["email"] as! String?
            UsersStore.getInstance().storeLocalUser(user)
            Crashlytics.sharedInstance().setUserEmail(userDict["name"] as! String?)
            Crashlytics.sharedInstance().setUserIdentifier(userID!)
            Crashlytics.sharedInstance().setUserName(userDict["name"] as! String?)
            
            callback(true)
        }
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
    
    internal func showVideoScreen() {
        let videoScreenVC = AppStoryboard.Signin.instance.instantiateViewController(withIdentifier: ViewNames.SBID_VIDEO_SCREEN)
        self.present(videoScreenVC, animated: true, completion: nil)
    }
    
    internal func showPushNotificationsScreen() {
        let notificationsVC = AppStoryboard.Notifications.instance.instantiateViewController(withIdentifier: ViewNames.SBID_PUSH_NOTIFICATIONS_VC)
        self.present(notificationsVC, animated: false, completion: nil)
    }

}

// MARK: - api
extension CodeViewController {
    internal func handleApiError(_ error: ApiError, completionHandler: () -> Void) {
        if error == ApiError.userNotAuthenticated {
            UsersStore.getInstance().clearCredentials()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setInitialViewController()
            completionHandler()
        } else {
            let message = "Something went wrong. Please try again later."
            EZAlertController.alert("Error", message: message)
            completionHandler()
        }
    }
}

// MARK: - UITextFieldDelegate

extension CodeViewController: UITextFieldDelegate {
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        digitCodeView.changeColorToEdit();
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        digitCodeView.changeColorButton()
        return true
    }
    
}

extension CodeViewController {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
