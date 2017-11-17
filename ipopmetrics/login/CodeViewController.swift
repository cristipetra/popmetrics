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
        digitCodeView.closeBtn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
        view.addSubview(progressHUD)
        progressHUD.hide()
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
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
        
        let smsCode = digitCodeView.digitextField.text!
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
                print(teams)
                UsersStore.getInstance().storeLocalUserAccount(userAccount!)
                UsersStore.currentBrandId = teams[0].brandId!
                if let _ = teams[0].brandName {
                    UsersStore.currentBrandName = teams[0].brandName!
                }
                
                SyncService.getInstance().syncAll(silent: false)
                
                let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
                if notificationType == [] {
                    self.showPushNotificationsScreen()
                } else {
                    self.showVideoScreen()
                }
                
            }
            else {
                EZAlertController.alert("Authentication failed.", message: "No brands associated with the account.")
                return
            }
            
            
        }
        
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
        }
    }
    
    @objc func didPressContact() {
        let message = "mailto:" + Config.mailContact
        UIApplication.shared.open(URL(string: message)!, options: [:], completionHandler: nil)
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
        let onboardingVC = OnboardingViewController()
        self.present(onboardingVC, animated: true, completion: nil)
    }
    
    internal func showPushNotificationsScreen() {
        let notificationsVC = AppStoryboard.Notifications.instance.instantiateViewController(withIdentifier: ViewNames.SBID_PUSH_NOTIFICATIONS_VC)
        //self.presentFromDirection(viewController: notificationsVC, direction: .right)
        self.present(notificationsVC, animated: false, completion: nil)
    }
    
    @objc internal func closeVC() {
        self.dismiss(animated: true, completion: nil)
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
