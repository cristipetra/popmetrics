//
//  WelcomeScreen.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ActiveLabel

class WelcomeScreen: UIViewController {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: ActiveLabel!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet var containerView: UIView!
    
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
    
    
    private func setUpColors() {
        let customColor = ActiveType.custom(pattern: "\\smarketing\\b")
        let customColor2 = ActiveType.custom(pattern: "\\sA.I\\b")
        let customColor3 = ActiveType.custom(pattern: "\\sautomation\\b")
        
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
        blueButton.layer.cornerRadius = 30
        btnNew.layer.cornerRadius = 30
        heartButton.layer.cornerRadius = heartButton.frame.width / 2
    }
    
    internal func addShadowToView(_ toView: UIView) {
        toView.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        toView.layer.shadowOpacity = 0.3;
        toView.layer.shadowRadius = 2
        toView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        toView.layer.shouldRasterize = true
    }
    
    @IBAction func handlerSpoken(_ sender: UIButton) {
        let loginVC = LoginNavigationViewController()
        self.present(loginVC, animated: true, completion: nil)
    }

    @IBAction func handlerHeartButton(_ sender: UIButton) {
        let mainTabVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewNames.SBID_MAIN_TAB_VC)
        self.present(mainTabVC, animated: true, completion: nil)
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

