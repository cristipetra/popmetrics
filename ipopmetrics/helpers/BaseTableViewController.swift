//
//  BaseTableViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Reachability
import NotificationBannerSwift
import ObjectMapper
import URLNavigator

class BaseTableViewController: UITableViewController {
    
    fileprivate let progressHUD = ProgressHUD(text: "Loading...")
    internal var topHeaderView: HeaderView!
    internal var offlineBanner: OfflineBanner!
    internal var reachability: Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(progressHUD)
        progressHUD.hide()
        setupOfflineBanner()
        ReachabilityManager.shared.addListener(listener: self)
        
        let nc = NotificationCenter.default
        
        nc.addObserver(self, selector:#selector(self.catchNotification), name: Notification.Popmetrics.ApiNotReachable, object:nil)
        nc.addObserver(self, selector:#selector(self.catchNotification), name: Notification.Popmetrics.ApiFailure, object:nil)
        nc.addObserver(self, selector:#selector(self.catchNotification), name: Notification.Popmetrics.ApiResponseUnsuccessfull, object:nil)
        nc.addObserver(self, selector:#selector(self.catchNotification), name: Notification.Popmetrics.RemoteMessage, object:nil)
        
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
            return
        } else {
            let message = "Something went wrong. Please try again later."
            self.presentAlertWithTitle("Error", message: message)
            completionHandler()
        }
    }
    
    internal func presentAlertWithTitle(_ title: String, message: String, useWhisper: Bool = false) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func setupOfflineBanner() {
        if offlineBanner == nil {
            offlineBanner = OfflineBanner()
            self.navigationController?.view.addSubview(offlineBanner)
            
            offlineBanner.translatesAutoresizingMaskIntoConstraints = false
            offlineBanner.trailingAnchor.constraint(equalTo: (self.navigationController?.view.trailingAnchor)!, constant: 0).isActive = true
            offlineBanner.leadingAnchor.constraint(equalTo: (self.navigationController?.view.leadingAnchor)!, constant: 0).isActive = true
            offlineBanner.heightAnchor.constraint(equalToConstant: 45).isActive = true
            offlineBanner.topAnchor.constraint(equalTo: (self.navigationController?.view.safeAreaLayoutGuide.topAnchor)!, constant: 44).isActive = true
            
            offlineBanner.isHidden = ReachabilityManager.shared.isNetworkAvailable
        }
    }
    
    @objc func catchNotification(notification:Notification) -> Void {
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


//MARK: - NetworkStatusListener
extension BaseTableViewController: NetworkStatusListener {
    
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


extension BannerProtocol where Self: BaseTableViewController { //Make all the BaseViewControllers that conform to BannerProtocol have a default implementation of presentErrorNetwork
    
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
