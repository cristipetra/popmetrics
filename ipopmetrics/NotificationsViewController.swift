//
//  NotificationsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 21/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import SafariServices
import UserNotifications


class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: RoundedCornersButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLabel.adjustLabelSpacing(spacing: 4, lineHeight: 15, letterSpacing: 0.4)
        secondLabel.adjustLabelSpacing(spacing: 4, lineHeight: 15, letterSpacing: 0.4)
        thirdLabel.adjustLabelSpacing(spacing: 4, lineHeight: 15, letterSpacing: 0.3)
        firstLabel.textAlignment = .center
        secondLabel.textAlignment = .center
        thirdLabel.textAlignment = .center
        confirmButton.backgroundColor = PopmetricsColor.blueURLColor
        confirmButton.setShadow()
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        registerForPushNotifications()
        return
        
        /*
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationsViewController.applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
         */
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            
            print("Permission granted: \(granted)")
            
            self.openNextView()
            
            guard granted else { return }
            
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        print("get notification settings")
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func openNextView() {
        let finalOnboardingVC = OnboardingFinalView()
        self.present(finalOnboardingVC, animated: true, completion: nil)
    }
    
    func applicationWillEnterForeground() {
        openNextView()
    }
    
}

//MARK: Safari open
extension NotificationsViewController {
    private func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
