//
//  WelcomeScreen.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ActiveLabel
import SafariServices
import Hero
import Reachability

class WelcomeScreen: BaseViewController {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: ActiveLabel!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    //internal var offlineBanner: OfflineBanner!

    var splashView: LDSplashView?
    var indicatorView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Popmetrics.SignIn, object:nil, queue:nil, using:catchNotificationSignIn)
 
        addShadowToView(blueButton)

        self.logoSplash()
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.welcomeViewController = self
        
        backButton.isHidden = true
    }
    
    override func setupOfflineBanner() {
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
    
    @IBAction func handlerSpoken(_ sender: UIButton) {
        
        if !ReachabilityManager.shared.isNetworkAvailable {
            presentErrorNetwork()
            return
        }
        
        self.performSegue(withIdentifier: "signInSegue", sender: self)
    }
    
    @IBAction func handlerDidPressNewButton(_ sender: UIButton) {
        if !ReachabilityManager.shared.isNetworkAvailable {
            presentErrorNetwork()
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.openURLInside(self, url: Config.appWebAimeeLink)
    }
    
    @IBAction func handleBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LoginViewController {
            let vc = segue.destination as? LoginViewController
            vc?.phoneNumber = UserStore.getInstance().phoneNumber
        }
    }
    
    func catchNotificationSignIn(notification:Notification) -> Void {
        if !ReachabilityManager.shared.isNetworkAvailable {
            presentErrorNetwork()
            return
        }
        self.performSegue(withIdentifier: "signInSegue", sender: self)        
    }
    
}

// MARK : splash logo animation
extension WelcomeScreen {
    func logoSplash() {
        let logoSplashIcon = LDSplashIcon(initWithImage: UIImage(named: "logo")!, animationType: .bounce)
        let iconColor = UIColor.white
        self.splashView = LDSplashView(initWithSplashIcon: logoSplashIcon!, backgroundColor: iconColor, animationType: .none)
        splashView!.delegate = self
        splashView!.animationDuration = 3
        self.view.addSubview(splashView!)
        self.view.bringSubview(toFront: splashView!)
        splashView!.startAnimation()
    }
}

extension WelcomeScreen: BannerProtocol {
    
}

//MARK : - Delegate Methods, implement if you need to know when the animations have started and ended
extension WelcomeScreen: LDSplashDelegate {
    func didBeginAnimatingWithDuration(_ duration: CGFloat) {
        indicatorView?.startAnimating()
    }
    
    func splashViewDidEndAnimating(_ splashView: LDSplashView) {
        indicatorView?.stopAnimating()
        indicatorView?.removeFromSuperview()
    }
}

extension WelcomeScreen {
    private func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}
