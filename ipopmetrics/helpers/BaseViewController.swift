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
import Reachability
import ObjectMapper

class BaseViewController: UIViewController {
    
    fileprivate let progressHUD = ProgressHUD(text: "Loading...")
    internal var offlineBanner: OfflineBanner!
    internal var reachability: Reachability!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(progressHUD)
        progressHUD.hide()
        
        setupOfflineBanner()
        ReachabilityManager.shared.addListener(listener: self)
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Popmetrics.ApiNotReachable, object:nil, queue:nil, using:catchNotification)
        nc.addObserver(forName:Notification.Popmetrics.ApiFailure, object:nil, queue:nil, using:catchNotification)
        nc.addObserver(forName:Notification.Popmetrics.ApiResponseUnsuccessfull, object:nil, queue:nil, using:catchNotification)
        
        nc.addObserver(forName:Notification.Popmetrics.RemoteMessage, object:nil, queue:nil, using:catchNotification)
        
        
    }
    
    func setupOfflineBanner() {
        if offlineBanner == nil {
            offlineBanner = OfflineBanner(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 45))
            self.navigationController?.view.addSubview(offlineBanner)
            offlineBanner.isHidden = ReachabilityManager.shared.isNetworkAvailable
        }
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
            UserStore.getInstance().clearCredentials()
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
    
    internal func presentAlertWithTitle(_ title: String, message: String, useWhisper: Bool = false) {
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
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        self.hideProgressIndicator()
        
        guard let userInfo = notification.userInfo
            else {
                return
        }
        
        let pnotification = Mapper<PNotification>().map(JSONObject: userInfo)!
        self.showBannerForNotification(pnotification)
        
    }
    
    
    func showBannerForNotification(_ notification: PNotification) {
        let style: BannerStyle!
        var time = 5
        var image = #imageLiteral(resourceName: "banner_info")
        switch notification.type {
        case "info"?:
            style = BannerStyle.info
            break
        case "success"?:
            style = BannerStyle.success
            image = #imageLiteral(resourceName: "banner_success")
            break
        case "failure"?:
            style = BannerStyle.danger
            image = #imageLiteral(resourceName: "banner_danger")
            time = 10
            break
        default:
            style = BannerStyle.info
            
        }
        let leftView = UIImageView(image: image)
        let banner = NotificationBanner(title: notification.title ?? notification.alert ?? "Message", subtitle: notification.subtitle ?? "", leftView: leftView, style:style)
        banner.duration = TimeInterval(exactly: time)!
        if let deepLink = notification.deepLink {
            banner.onTap = {
                print("going to "+deepLink)
                navigator.push(deepLink)
                // banner.dismiss()
            }
        }
        banner.show()
    }
    
    
    
}

// Mark: notifications handler
extension BaseViewController: NetworkStatusListener {
    
    func networkStatusDidChange(status: Reachability.Connection) {
        
        switch status {
        case .none:
            offlineBanner.isHidden = false
        case .wifi:
            offlineBanner.isHidden = true
        case .cellular:
            offlineBanner.isHidden = true
        }
    }
}


extension BannerProtocol where Self: BaseViewController { //Make all the BaseViewControllers that conform to BannerProtocol have a default implementation of presentErrorNetwork
    
    func presentErrorNetwork() {
        let notificationObj = ["alert":"",
                               "subtitle": "You need to be online to perform this action.",
                               "type": "failure",
                               "sound":"default"
        ]
        let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
        showBannerForNotification(pnotification)
    }
    
}
