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
    
    @IBOutlet weak var closeButton: UIButton!
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
        segue.destination.modalPresentationStyle = .custom
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    private func setup() {
        
        let closeButtonImage = UIImage(named: "iconCloseBlack")!.withRenderingMode(.alwaysTemplate)
        //let logo = UIImage(named: "logoCube")!.withRenderingMode(.alwaysTemplate)
        //closeButtonImage.bma_tintWithColor(UIColor.white)
        
        //logo.bma_tintWithColor(UIColor.white)
        closeButton.setImage(closeButtonImage, for: .normal)
        //logoImage.image = logo
        
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
