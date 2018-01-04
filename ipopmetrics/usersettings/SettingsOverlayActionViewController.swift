//
//  SettingsOverlayActionViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import MessageUI
import EZAlertController

class SettingsOverlayActionViewController: SettingsBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var handlerCTA: UIButton!
    
    private var dataSource: [String] = []
    
    var selectedAction: String = ""
    var didChangedOverlay: Bool = false
    var firstTimeSetOverlay = true
    
    private let userSettings: UserSettings = UserStore.getInstance().getLocalUserSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = userSettings.getOverlayActions()
        tableView.delegate = self
        tableView.dataSource = self
        
        registerCell()
        setupNavigationBar()
        titleWindow = "Overlay Action"
        
        updateView()
    }
    
    private func updateView() {
        
    }
    
    override func cancelHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func handlerCTA(_ sender: Any) {
        sendEmail(emailMessageType: .overlayAction)
    }
    
    private func registerCell() {
        tableView.register(BrandTableViewCell.self, forCellReuseIdentifier: "brandId")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brandId", for: indexPath) as! BrandTableViewCell
        cell.brandName.text = dataSource[indexPath.row]
        if indexPath == UserStore.overlayIndex {
            cell.setupSelectedCell()
            selectedAction = cell.brandName.text!
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didChangedOverlay = true
        if firstTimeSetOverlay {
            guard let cell = tableView.cellForRow(at: UserStore.overlayIndex) as? BrandTableViewCell else {
                return
            }
            cell.setDefault()
            firstTimeSetOverlay = false
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? BrandTableViewCell else {
            return
        }
        UserStore.overlayIndex = indexPath
        selectedAction = cell.brandName.text!
        cell.setupSelectedCell()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let prevCell = tableView.cellForRow(at: indexPath) as! BrandTableViewCell
        prevCell.setDefault()
    }
    
    override func doneHandler() {
        changeOverlayAction()
    }
    
    private func changeOverlayAction() {
        SettingsApi().changeOverlayAction(action: selectedAction) { (error) in
            if error == nil {
                self.closeWindow()
            } else {
                let message = "Something went wrong. Please try again later."
                EZAlertController.alert("Error", message: message)
            }
        }
    }
    
}

extension SettingsOverlayActionViewController: MFMailComposeViewControllerDelegate {
    
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
