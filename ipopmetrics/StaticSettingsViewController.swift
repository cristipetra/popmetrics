//
//  StaticSettingsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 13/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StaticSettingsViewController: UITableViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var professionalEmail: UITextField!
    
    let sectionTitles = ["USER IDENTITY", "NOTIFICATIONS", "BRAND IDENTITY", "SOCIAL ACCOUNTS", "DATA ACCOUNTS", "WEB OVERLAY"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = PopmetricsColor.tableBackground
        //tableView.allowsSelection = false
        
        setUpNavigationBar()
        updateView()
    }
    
    private func updateView() {
        let user = UsersStore.getInstance().getLocalUserAccount()
        
        name.text = user.name
        phone.text = user.phone
        professionalEmail.text = user.email
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
        } else if (indexPath.section == 3 && indexPath.row == 0) {
            displayFacebook()
        } else if (indexPath.section == 3 && indexPath.row == 1) {
            displayTwitter()
        } else if (indexPath.section == 3 && indexPath.row == 2) {
            displayLinkedin()
        } else if (indexPath.section == 4 && indexPath.row == 0) {
            displayGASettings()
        } else if (indexPath.section == 5 && indexPath.row == 0) {
            displayOverlay()
        } else if (indexPath.section == 5 && indexPath.row == 1) {
            displayOverlayDescription()
        }
    }
    
    private func displayTwitter() {
        let twitterVC = SettingsFacebookViewController(nibName: "SettingsFacebookView", bundle: nil)
        twitterVC.displayTwitter()
        self.navigationController?.pushViewController(twitterVC, animated: true)
    }
    
    private func displayLinkedin() {
        let linkedinVC = SettingsFacebookViewController(nibName: "SettingsFacebookView", bundle: nil)
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
        let facebookVC = SettingsFacebookViewController(nibName: "SettingsFacebookView", bundle: nil)
        self.navigationController?.pushViewController(facebookVC, animated: true)
    }
    
    private func displayGASettings() {
        let gaVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "settingsGA") as! SettingsGAViewController
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

}
