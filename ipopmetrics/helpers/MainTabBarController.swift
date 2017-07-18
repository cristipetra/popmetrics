//
//  MainNavigationTabBarController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var splashView: LDSplashView?
    var indicatorView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoSplash()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check to see if the user didn't dismiss the intro
        // and that she/he still has unanswered items

        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    }
    
    /*
     override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
     if (self.viewControllers?.first as? UINavigationController)?.viewControllers.last is PropertyCaptureViewController {
     return UIInterfaceOrientationMask.AllButUpsideDown
     }
     return UIInterfaceOrientationMask.Portrait
     }
     
     override func shouldAutorotate() -> Bool {
     return true
     }
     */
}

// MARK : splash logo animation
extension MainTabBarController {
    func logoSplash() {
        let logoSplashIcon = LDSplashIcon(initWithImage: UIImage(named: "logo_loading")!, animationType: .bounce)
        let iconColor = UIColor.yellowBackgroundColor()
        self.splashView = LDSplashView(initWithSplashIcon: logoSplashIcon!, backgroundColor: iconColor, animationType: .none)
        splashView!.delegate = self
        splashView!.animationDuration = 3
        self.view.addSubview(splashView!)
        self.view.bringSubview(toFront: splashView!)
        splashView!.startAnimation()
    }
}

//MARK : - Delegate Methods, implement if you need to know when the animations have started and ended
extension MainTabBarController: LDSplashDelegate {
    func didBeginAnimatingWithDuration(_ duration: CGFloat) {
        indicatorView?.startAnimating()
    }
    
    func splashViewDidEndAnimating(_ splashView: LDSplashView) {
        indicatorView?.stopAnimating()
        indicatorView?.removeFromSuperview()
    }
}
