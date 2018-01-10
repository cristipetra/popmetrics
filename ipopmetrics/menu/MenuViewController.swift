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
import Reachability

class MenuViewController: ElasticModalViewController {
    
    @IBOutlet weak var buildLabel: UILabel!
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
    internal var offlineBanner: OfflineBanner!
    
    var transition = ElasticTransition()
    
    var dismissByBackgroundTouch = false
    var dismissByBackgroundDrag = true
    //var dismissByForegroundDrag = true
    
    var secretTaps = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOfflineBanner()
        buildLabel.text = UIApplication.versionBuild()
        
        self.brandNameLabel.text = UserStore.currentBrand?.name
        
        setup()
        transition.edge = .right
        transition.sticky = false
        
        self.popmetricsImageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        // Add the recognizer to your view.
        popmetricsImageView.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        secretTaps = 0
    }
    
    func setupOfflineBanner() {
        if offlineBanner == nil {
            offlineBanner = OfflineBanner()
            self.view.addSubview(offlineBanner)
            
            offlineBanner.translatesAutoresizingMaskIntoConstraints = false
            offlineBanner.trailingAnchor.constraint(equalTo: (self.view.trailingAnchor), constant: 0).isActive = true
            offlineBanner.leadingAnchor.constraint(equalTo: (self.view.leadingAnchor), constant: 0).isActive = true
            offlineBanner.heightAnchor.constraint(equalToConstant: 45).isActive = true
            offlineBanner.topAnchor.constraint(equalTo: (self.view.safeAreaLayoutGuide.topAnchor), constant: 44).isActive = true
            
            offlineBanner.isHidden = ReachabilityManager.shared.isNetworkAvailable
        }
    }
    
    @objc func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {

        secretTaps = secretTaps + 1
        if secretTaps > 8 {
            secretTaps = 0
            let confirmAlert = UIAlertController(title: "Confirmation", message: "Are you sure you want to reset your hubs?",
                                                 preferredStyle: UIAlertControllerStyle.alert)
            confirmAlert.addAction(UIAlertAction(title:"Yes", style: .default, handler: { (action: UIAlertAction!) in
                FeedStore.getInstance().wipe()
                TodoStore.getInstance().wipe()
                CalendarStore.getInstance().wipe()
                StatsStore.getInstance().wipe()
                
                UsersApi().resetBrandHubs(UserStore.currentBrandId)
                self.presentAlertWithTitle("Confirmation", message: "The hubs are being reset. It may take up to a minute.")
            }))
            
            confirmAlert.addAction(UIAlertAction(title:"No", style: .default, handler: { (action: UIAlertAction!) in
                self.secretTaps = 0
            }))
            
            present(confirmAlert, animated: true)
        }
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
    @IBAction func labelButtonClosePressed(_ sender: UIButton) {
        self.dismissAnimated(self.view)
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
        let aboutVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "aboutViewController") as! AboutViewController
        
        let navigationController = UINavigationController()
        navigationController.pushViewController(aboutVC, animated: false)
        
        self.presentFromDirection(viewController: navigationController, direction: .right)
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

// Mark: notifications handler
extension MenuViewController: NetworkStatusListener {
    
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
