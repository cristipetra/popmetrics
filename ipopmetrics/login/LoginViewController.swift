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

class LoginViewController: UIViewController {
    
    fileprivate let progressHUD = ProgressHUD(text: "Loading...")
    
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var sendPhoneNumberButton: UIButton!
    
    @IBOutlet var smsCodeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(progressHUD)
        progressHUD.hide()
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
    
    internal func handleApiError(_ error: ApiError, completionHandler: () -> Void) {
        if error == ApiError.userNotAuthenticated {
            UsersStore.getInstance().clearCredentials()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setInitialViewController()
            completionHandler()
        } else {
            let message = "Something went wrong. Please try again later."
            self.presentAlertWithTitle("Error", message: message)
            completionHandler()
        }
    }
    
    internal func presentAlertWithTitle(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    internal func addShadowToView(_ toView: UIView) {
        toView.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        toView.layer.shadowOpacity = 0.8;
        toView.layer.shadowRadius = 2
        toView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    
    @IBAction func didPressSendPhoneNumber(_ sender: Any) {
    
        let phoneNumber = phoneNumberTextField.text!
        showProgressIndicator()
        UsersApi().sendCodeBySms(phoneNumber: phoneNumber) {userDict, error in
            self.hideProgressIndicator()
            if error != nil {
                var message = "An error has occurred. Please try again later."
                if error == ApiError.userMismatch || error == ApiError.userNotAuthenticated {
                    message = "User /Password combination not found."
                }
                self.presentAlertWithTitle("Error", message: message)
                return
            }
            
        }

    } // func
    
    @IBAction func didPressSendSmsCode(_ sender: Any) {
        let smsCode = smsCodeTextField.text!
        let phoneNumber = phoneNumberTextField.text!
        showProgressIndicator()
        UsersApi().logInWithSmsCode(phoneNumber, smsCode: smsCode) {responseDict, error in
            self.hideProgressIndicator()
            if error != nil {
                let message = "An error has occurred. Please try again later."
                self.presentAlertWithTitle("Error", message: message)
                return
            }
            let code = responseDict?["code"] as! String
            if code != "success" {
                let message = responseDict?["message"] as! String
                self.presentAlertWithTitle("Authentication failed.", message:message)
                return
            }
            
            let userDict = responseDict?["user"] as! [String: Any]
            self.storeUserDict(userDict) { success in
                if !success {
                    Crashlytics.sharedInstance().crash()
                    let message = "An error has occurred. Please try again later."
                    self.presentAlertWithTitle("Error", message: message)
                    return
                }
                
                self.showMainNavigationController()
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
    
}
