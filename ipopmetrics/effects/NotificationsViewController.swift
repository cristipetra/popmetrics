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
import Hero

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: RoundedCornersButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        setNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        confirmButton.setTitleColor(PopmetricsColor.borderButton, for: .normal)
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let logoImageView = UIImageView(image: UIImage(named: "logoPop"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        logoImageView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = logoImageView
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
            UserStore.didAskedForAllowingNotification = true
            self.openNextView()
            
            guard granted else { return }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.getNotificationSettings()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        openNextView()
    }
    
    func openNextView() {
        let finalOnboardingVC = OnboardingFinalView()
        self.present(finalOnboardingVC, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
