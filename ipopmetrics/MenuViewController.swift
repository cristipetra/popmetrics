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

class MenuViewController: ElasticModalViewController {
    
    
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
        setup()
        transition.edge = .right
        transition.sticky = false
        
        
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
        let closeButtonImage = UIImage(named: "iconCloseBlack")!.withRenderingMode(.alwaysTemplate)
        
        closeButton.setImage(closeButtonImage, for: .normal)
        
    }
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismissAnimated(self.view)
        //self.dismiss(animated: true, completion: nil)
    }
    @IBAction func contactButtonPressed(_ sender: UIButton) {
        let message = "mailto:" + Config.mailContact
        UIApplication.shared.open(URL(string: message)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func aboutButtonPressed(_ sender: UIButton) {
        openURLInside(url: Config.socialAutomationLink)
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        UsersStore.getInstance().clearCredentials()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewController()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    @IBAction func handlerClickSetttings(_ sender: UIButton) {
        let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "staticSettings") as! StaticSettingsViewController
        //self.present(settingsVC, animated: false, completion: nil)
        
        let navigationController = UINavigationController()
        navigationController.pushViewController(settingsVC, animated: false)
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
}


//MARK: Safari open
extension MenuViewController {
    private func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}

extension UIViewController {
    func openURLInside(url: String) {
        let url = URL(string: url)
        let safari = SFSafariViewController(url: url!)
        self.present(safari, animated: true)
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

