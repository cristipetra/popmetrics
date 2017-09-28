//
//  BaseViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Crashlytics
import SwiftRichString
import NotificationBannerSwift

class BaseViewController: UIViewController {
    
    fileprivate let progressHUD = ProgressHUD(text: "Loading...")
    
    func getMyNotification() -> Notification.Name {
        return Notification.Name(rawValue:"HomzenNotification")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:getMyNotification(), object:nil, queue:nil, using:catchNotification)
        nc.addObserver(forName:Notification.Popmetrics.ApiNotReachable, object:nil, queue:nil, using:catchApiNotReachable)
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let title    = userInfo["title"] as? String,
            let message  = userInfo["message"] as? String
            else {
                print("Incomplete user info found in notification")
                return
        }
        presentAlertWithTitle(title, message: message)
        
        
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
}

// Mark: notifications handler
extension BaseViewController {
    internal func catchApiNotReachable(notification: Notification) -> Void {
        let first = Style.default {
            $0.font = FontAttribute.init("OpenSans", size: 12)
            $0.color = UIColor.white
        }
        
        let fullStr = "Error connecting to API!".set(style: first)
        
        let banner = NotificationBanner(attributedTitle: NSAttributedString(string: "Error connecting to API!"), attributedSubtitle: NSAttributedString(string: ""), leftView: nil, rightView: nil, style: BannerStyle.none, colors: nil)
        banner.backgroundColor = PopmetricsColor.notificationBGColor
        banner.duration = TimeInterval(exactly: 7.0)!
        banner.show()
    }
}
