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
        nc.addObserver(forName:Notification.Popmetrics.ApiNotReachable, object:nil, queue:nil, using:catchNotification)
        nc.addObserver(forName:Notification.Popmetrics.ApiFailure, object:nil, queue:nil, using:catchNotification)
        nc.addObserver(forName:Notification.Popmetrics.ApiResponseUnsuccessfull, object:nil, queue:nil, using:catchNotification)
        
        nc.addObserver(forName:Notification.Popmetrics.RemoteMessage, object:nil, queue:nil, using:catchNotification)
        
        
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
            offlineBanner = OfflineBanner(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 45))
            self.navigationController?.view.addSubview(offlineBanner)
            print("network status \(ReachabilityManager.shared.isNetworkAvailable)")
            offlineBanner.isHidden = ReachabilityManager.shared.isNetworkAvailable
        }
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
