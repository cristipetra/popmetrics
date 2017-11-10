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

class WelcomeScreen: UIViewController {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: ActiveLabel!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var topTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    var splashView: LDSplashView?
    var indicatorView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoSplash()
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
    }
    override func viewDidLayoutSubviews() {
        updateConstraintValues()
    }
    
    private func updateConstraintValues() {
        if UIScreen.main.bounds.height <= CGFloat(480) {
            topImageConstraint.constant = 20
            heightTextConstraint.constant = 100
            topTextConstraint.constant = 20
        }
    }
    
    internal func updateTextColor() {
        let customColor = ActiveType.custom(pattern: "\\sMarketing\\b")
        let customColor2 = ActiveType.custom(pattern: "\\sA.I. \\b")
        let customColor3 = ActiveType.custom(pattern: "\\sAutomation\\b")
        
        welcomeLabel.enabledTypes.append(customColor)
        welcomeLabel.enabledTypes.append(customColor2)
        welcomeLabel.enabledTypes.append(customColor3)
        
        welcomeLabel.customize { (welcome) in
            
            welcome.customColor[customColor] = UIColor(red: 68.0 / 255.0, green: 180.0 / 255.0, blue: 142.0 / 255.0, alpha: 1.0)
            welcome.customColor[customColor2] = UIColor(red: 68.0 / 255.0, green: 180.0 / 255.0, blue: 142.0 / 255.0, alpha: 1.0)
            welcome.customColor[customColor3] = UIColor(red: 68.0 / 255.0, green: 180.0 / 255.0, blue: 142.0 / 255.0, alpha: 1.0)
        }
    }
    
    @IBAction func handlerSpoken(_ sender: UIButton) {
        let loginVC = LoginViewController()
        self.present(loginVC, animated: true, completion: nil)
        //self.presentFromDirection(viewController: loginVC, direction: .right)
    }
    
    @IBAction func handlerDidPressNewButton(_ sender: UIButton) {
        openURLInside(url: Config.appWebAimeeLink)
    }
    
    @IBAction func handleBackPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK : splash logo animation
extension WelcomeScreen {
    func logoSplash() {
        let logoSplashIcon = LDSplashIcon(initWithImage: UIImage(named: "logo")!, animationType: .bounce)
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
