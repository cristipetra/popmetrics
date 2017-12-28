//
//  MenuViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ElasticTransition
import SafariServices
import Haptica
import MessageUI

class MenuViewController: ElasticModalViewController {
    
    @IBOutlet weak var changeBrandBtn: UIButton!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var brandNameLabel: UILabel!
    
    @IBOutlet weak var popmetricsImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.isHaptic = true
            closeButton.hapticType = .notification(.success)
        }
    }
    @IBOutlet weak var logoImage: UIImageView!
    
    var transition = ElasticTransition()
    
    var dismissByBackgroundTouch = false
    var dismissByBackgroundDrag = true
    //var dismissByForegroundDrag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.brandNameLabel.text = UserStore.currentBrand?.name
        
        setup()
        transition.edge = .right
        transition.sticky = false
        
        let currentBrandId = UserStore.currentBrandId
        if currentBrandId == "5a278fcec2ff29587ee10739" || currentBrandId == "5a27900ac2ff29587ee1073a" {
            self.popmetricsImageView.isUserInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            //Add the recognizer to your view.
            popmetricsImageView.addGestureRecognizer(tapRecognizer)
        }
        
    }
    
    @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        FeedStore.getInstance().wipe()
        TodoStore.getInstance().wipe()
        CalendarStore.getInstance().wipe()
        StatsStore.getInstance().wipe()
        
        UsersApi().resetBrandHubs(UserStore.currentBrandId)
        presentAlertWithTitle("Confirmation", message: "The hubs are being reset. It may take up to a minute.")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = transition as UIViewControllerTransitioningDelegate
        //segue.destination.modalPresentationStyle = .custom
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    private func setup() {
        changeBrandBtn.contentHorizontalAlignment = .left
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismissAnimated(self.view)
        //self.dismiss(animated: true, completion: nil)
    }
    @IBAction func handlerLegalBits(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.openURLInside(self, url: Config.legalBitsLink)
    }
    
    @IBAction func handlerContactUsPressed(_ sender: Any) {
        sendEmail(emailMessageType: .contact)
    }

    @IBAction func handlerAboutButtonPressed(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.openURLInside(self, url: Config.aboutPopmetricsLink)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        UserStore.getInstance().clearCredentials()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewController()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    @IBAction func handlerClickSetttings(_ sender: UIButton) {
        let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "staticSettings") as! StaticSettingsViewController
        
        let navigationController = UINavigationController()
        navigationController.pushViewController(settingsVC, animated: false)

        self.presentFromDirection(viewController: navigationController, direction: .right)
    }
    
    @IBAction func handlerChangeBrand(_ sender: Any) {
        let changeBrandVC = ChangeBrandViewController()
        let navController =  UINavigationController(rootViewController: changeBrandVC)
        changeBrandVC.brandDelegate = self
        
        self.presentFromDirection(viewController: navController, direction: .right)
    }
    
    
    internal func presentAlertWithTitle(_ title: String, message: String, useWhisper: Bool = false) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
}

extension MenuViewController: MFMailComposeViewControllerDelegate {
    
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
        
        mailComposerVC.setToRecipients(["help@popmetrics.io"])
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: Safari open
extension MenuViewController {
    private func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}

extension ElasticModalViewController {
    func dismissAnimated(_ sender: UIView?) {
        modalTransition.transformType = dragRightTransformType
        modalTransition.edge = .left
        modalTransition.startingPoint = sender?.center
        dismiss(animated: true, completion: nil)
    }
}

extension MenuViewController: BrandProtocol {
    func changeBrand(_ brand: Brand) {
        brandNameLabel.text = brand.name!.uppercased()
        UserStore.currentBrand = brand
        SyncService.getInstance().syncAll(silent: false)
    }
}
