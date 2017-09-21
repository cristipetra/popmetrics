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

class WelcomeScreen: UIViewController {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: ActiveLabel!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var topTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonsConstraint: NSLayoutConstraint!
    var splashView: LDSplashView?
    var indicatorView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpColors()
 
        setUpCornerRadious()
        addShadowToView(blueButton)
        addShadowToView(btnNew)
        addShadowToView(heartButton)
        
        self.logoSplash()
    }
    override func viewDidLayoutSubviews() {
        updateConstraintValues()
    }
    
    private func updateConstraintValues() {
        if UIScreen.main.bounds.height <= CGFloat(480) {
            topImageConstraint.constant = 20
            bottomButtonsConstraint.constant = 20
            heightTextConstraint.constant = 100
            topTextConstraint.constant = 20
        }
    }
    
    private func setUpColors() {
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
        
        
        containerView.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1.0)
        blueButton.layer.backgroundColor = UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1.0).cgColor
        blueButton.setTitleColor(UIColor.white, for: .normal)
        btnNew.backgroundColor = UIColor.white
        heartButton.backgroundColor = UIColor.white
    }
    
    private func setUpCornerRadious() {
        blueButton.layer.cornerRadius = blueButton.frame.height / 2
        btnNew.layer.cornerRadius = btnNew.frame.height / 2
        heartButton.layer.cornerRadius = heartButton.frame.width / 2
    }
    
    internal func addShadowToView(_ toView: UIView) {
        toView.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        toView.layer.shadowOpacity = 0.3;
        toView.layer.shadowRadius = 2
        toView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    @IBAction func handlerSpoken(_ sender: UIButton) {
        let loginVC = LoginViewController()
        self.present(loginVC, animated: true, completion: nil)
        //self.presentFromDirection(viewController: loginVC, direction: .right)
    }

    @IBAction func handlerHeartButton(_ sender: UIButton) {
        let onboardingVC = OnboardingViewController()
        self.present(onboardingVC, animated: true, completion: nil)
        return
        openURLInside(url: Config.appWebLink)
    }
    
    @IBAction func handlerDidPressNewButton(_ sender: UIButton) {
        openURLInside(url: Config.appWebLink)
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
