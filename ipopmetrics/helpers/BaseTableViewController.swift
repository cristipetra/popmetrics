//
//  BaseTableViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Reachability
import Whisper
import NotificationBannerSwift

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
        if useWhisper {
            displayWhisper(title, message: message)
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    internal func displayWhisper(_ title: String, message: String) {
        let announcement = Announcement(title: title, subtitle: message, image: UIImage(named: "active_home"), duration: 5)
        Whisper.show(shout: announcement, to: self.navigationController!)
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
        
        guard let userInfo = notification.userInfo,
            let title    = userInfo["title"] as? String,
            let message  = userInfo["message"] as? String
            else {
                presentAlertWithTitle("Unexpected error", message: "Error within the error handler itself.")
                return
            }
        presentAlertWithTitle(title, message: message, useWhisper: true)
        
    }
    
    func showBanner(bannerType: BannerType, title: String, message: String) {
        let banner: NotificationBanner!
        switch bannerType {
        case .success:
            let titleAttribute = [
                NSAttributedStringKey.font: UIFont(name: "OpenSans-Bold", size: 12),
                NSAttributedStringKey.foregroundColor: PopmetricsColor.darkGrey]
            let attributedTitle = NSAttributedString(string: title, attributes: (titleAttribute as Any as! [NSAttributedStringKey : Any]))
            let subtitle = message
            let subtitleAttribute = [
                NSAttributedStringKey.font: UIFont(name: "OpenSans-SemiBold", size: 12),
                NSAttributedStringKey.foregroundColor: UIColor.white]
            let attributedSubtitle = NSAttributedString(string: subtitle, attributes: (subtitleAttribute as Any as! [NSAttributedStringKey : Any]))
            banner = NotificationBanner(attributedTitle: attributedTitle, attributedSubtitle: attributedSubtitle, leftView: nil, rightView: nil, style: BannerStyle.none, colors: nil)
            banner.backgroundColor = PopmetricsColor.greenMedium
            break
        case .failed:
            let title = title
            let titleAttribute = [
                NSAttributedStringKey.font: UIFont(name: "OpenSans-Bold", size: 12),
                NSAttributedStringKey.foregroundColor: PopmetricsColor.notificationBGColor]
            let attributedTitle = NSAttributedString(string: title, attributes: (titleAttribute as Any as! [NSAttributedStringKey : Any]))
            let subtitle = message
            let subtitleAttribute = [
                NSAttributedStringKey.font: UIFont(name: "OpenSans-SemiBold", size: 12),
                NSAttributedStringKey.foregroundColor: UIColor.white]
            let attributedSubtitle = NSAttributedString(string: subtitle, attributes: (subtitleAttribute as Any as! [NSAttributedStringKey : Any]))
            banner = NotificationBanner(attributedTitle: attributedTitle, attributedSubtitle: attributedSubtitle, leftView: nil, rightView: nil, style: BannerStyle.none, colors: nil)
            banner.backgroundColor = PopmetricsColor.salmondColor
            break
        default:
            break
        }
        banner.duration = TimeInterval(exactly: 7.0)!
        banner.show()
        
        banner.onTap = {
            banner.dismiss()
        }
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
