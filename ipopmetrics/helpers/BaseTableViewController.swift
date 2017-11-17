//
//  BaseTableViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Reachability
import  Whisper

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
        let announcement = Announcement(title: title, subtitle: message, image: UIImage(named: "avatar"))
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
