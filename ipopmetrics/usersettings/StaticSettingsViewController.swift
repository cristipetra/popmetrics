//
//  StaticSettingsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 13/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import MessageUI
import ObjectMapper
import SwiftyJSON
import UserNotifications

class StaticSettingsViewController: BaseTableViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var professionalEmail: UITextField!
    @IBOutlet weak var brandName: UITextField!
    @IBOutlet weak var allowSounds: UISwitch!
    @IBOutlet weak var allowNotifications: UISwitch!
    
    
    @IBOutlet weak var googleAnalyticsTracker: UITextField!
    
    let sectionTitles = ["USER IDENTITY", "NOTIFICATIONS", "BRAND IDENTITY", "SOCIAL ACCOUNTS", "DATA ACCOUNTS", "WEB OVERLAY"]
    
    var currentBrand = UserStore.currentBrand
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = PopmetricsColor.tableBackground
        
        allowNotifications.addTarget(self, action: #selector(changeNotifications(_:)), for: .valueChanged)
        setUpNavigationBar()
        NotificationCenter.default.addObserver(self, selector: "handlerDidBecomeActive", name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchBrandDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateAllowNoticationsSwitch()
    }
    
    func fetchBrandDetails() {
        
        if !SyncService.getInstance().reachability.isReachable {
            return
        }
        
        self.showProgressIndicator()
        
        let currentBrandId = UserStore.currentBrandId
        UsersApi().getBrandDetails(currentBrandId) { brand in
            UserStore.currentBrand = brand!
            self.currentBrand = brand!
            self.hideProgressIndicator()
            self.updateView()
        }
        
    }
    
    
    @objc  func handlerDidBecomeActive() {
        updateAllowNoticationsSwitch()
    }
    
    private func updateView() {
        let user = UserStore.getInstance().getLocalUserAccount()
        let userSettings: UserSettings = UserStore.getInstance().getLocalUserSettings()
        
        name.text = user.name
        phone.text = user.phone
        professionalEmail.text = user.email
        
        brandName.text = UserStore.currentBrandName
        
        googleAnalyticsTracker.text = currentBrand?.googleAnalytics?.tracker ?? "N/A"
        
        allowSounds.isOn = userSettings.allowSounds
    }
    
    func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "SETTINGS", style: .plain, target: self, action: nil)
        text.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }

    @objc func handlerClickBack() {
        self.navigationController?.dismissToDirection(direction: .left)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 61
    }
     */
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView: UIView  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        var title: UILabel = UILabel()
        title.font = UIFont(name: FontBook.regular, size: 12)
        title.textColor = PopmetricsColor.textGraySettings
        title.text = sectionTitles[section]
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
        
        return contentView
    }
 
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if(indexPath.section == 0 && indexPath.row == 2) {
            displaySettingsEmail()
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            displaySettingsLogo()
        } else if (indexPath.section == 2 && indexPath.row == 2) {
            sendEmail(emailMessageType: .webAddress)
        } else if (indexPath.section == 3 && indexPath.row == 0) {
            displayFacebook()
        } else if (indexPath.section == 3 && indexPath.row == 1) {
            displayTwitter()
        } else if (indexPath.section == 3 && indexPath.row == 2) {
            displayLinkedin()
        } else if (indexPath.section == 4 && indexPath.row == 0) {
            displayGASettings()
        } else if (indexPath.section == 5 && indexPath.row == 0) {
            displayOverlayDescription()
        } else if (indexPath.section == 5 && indexPath.row == 1) {
            displayOverlay()
        } else if (indexPath.section == 5 && indexPath.row == 2) {
            displayOverlayUrl()
        }
    }
    
    private func displayTwitter() {
        let twitterVC = SettingsSocialViewController(nibName: "SettingsSocialView", bundle: nil)
        twitterVC.displayTwitter()
        self.navigationController?.pushViewController(twitterVC, animated: true)
    }
    
    private func displayLinkedin() {
        let linkedinVC = SettingsSocialViewController(nibName: "SettingsSocialView", bundle: nil)
        linkedinVC.displayLinkedin()
        self.navigationController?.pushViewController(linkedinVC, animated: true)
    }
    
    private func displaySettingsEmail() {
        let emailVC = SettingsEmailViewController(nibName: "SettingsEmailView", bundle: nil)
        self.navigationController?.pushViewController(emailVC, animated: true)
    }
    
    private func displaySettingsLogo() {
        let logoVC = SettingsLogoViewController(nibName: "SettingsLogoView", bundle: nil)
        self.navigationController?.pushViewController(logoVC, animated: true)
    }
    
    private func displayFacebook() {
        let facebookVC = SettingsSocialViewController(nibName: "SettingsSocialView", bundle: nil)
        facebookVC.displayFacebook()
        self.navigationController?.pushViewController(facebookVC, animated: true)
    }
    
    private func displayGASettings() {
        let gaVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "settingsGA") as! SettingsGAViewController
        gaVC.currentBrand = self.currentBrand
        self.navigationController?.pushViewController(gaVC, animated: true)
    }
    
    private func displayOverlay() {
        let overlayVC = SettingsOverlayActionViewController(nibName: "SettingsOverlayActionView", bundle: nil)
        self.navigationController?.pushViewController(overlayVC, animated: true)
    }
    
    private func displayOverlayDescription() {
        let overlayDescription = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "overlayDescription") as! SettingsOverlayDescriptionViewController
        self.navigationController?.pushViewController(overlayDescription, animated: true)
    }
    
    private func displayOverlayUrl() {
        let overlayURL = SettingsOverlayUrlViewController(nibName: "SettingsOverlayUrlView", bundle: nil)
        self.navigationController?.pushViewController(overlayURL, animated: true)
    }
    
    @objc func changeNotifications(_ sender: UISwitch) {
        if UserStore.didAskedForAllowingNotification {
            Alert.showNotificationAlertDialog(parent: self, action: { (action) -> (Void) in
                switch action {
                case .cancel:
                    self.updateAllowNoticationsSwitch()
                case .save:
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                default:
                    break
                }
            }, message: "Do you want to go to settings to change notifications?", title: "Notifications", okButton: true)
        } else {
            registerForNotification()
        }
    }
    
    private func updateAllowNoticationsSwitch() {
        allowNotifications.isOn = UserStore.isNotificationsAllowed
    }

    private func registerForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            UserStore.didAskedForAllowingNotification = true
            if granted {
                self.allowNotifications.isOn = true
            } else {
                self.allowNotifications.isOn = false
            }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {return }
                UIApplication.shared.registerForRemoteNotifications()
        }
        
    }
    
    @IBAction func handlerEmailName(_ sender: Any) {
        sendEmail(emailMessageType: .name)
    }
    
    @IBAction func handlerEmailPhone(_ sender: Any) {
        sendEmail(emailMessageType: .phone)
    }
    
    @IBAction func handlerEmailBrandName(_ sender: Any) {
        sendEmail(emailMessageType: .brand)
    }
    
    @IBAction func handlerEmailPrimaryUrl(_ sender: UIButton) {
        sendEmail(emailMessageType: .webAddress)
    }
    
    @IBAction func handlerEmailWebAddress(_ sender: Any) {
        sendEmail(emailMessageType: .webAddress)
    }
    
}

extension StaticSettingsViewController: MFMailComposeViewControllerDelegate {
    
    private func sendEmail(emailMessageType: EmailMessageType) {
        let mailComposerVC = configuredMailComposeVC(emailMessageType: emailMessageType)
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        }
    }
    
    func configuredMailComposeVC(emailMessageType: EmailMessageType) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        let info = EmailMessages.getInstance().getEmailMessages(emailMessageType: emailMessageType)
        
        mailComposerVC.setSubject(info.subject!)
        mailComposerVC.setMessageBody(info.messageBody!, isHTML: false)
        
        mailComposerVC.setToRecipients([Config.mailSettings])
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

