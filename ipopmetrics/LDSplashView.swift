//
//  LDSplashView.swift
//  LDSplashView
//
//  Created by Patrick M. Bush on 10/22/15
//  Copyright © 2015 Lead Development Co. All rights reserved.
//

import UIKit

@objc class LDSplashView: UIView, LDSplashDelegate {
    
    
    enum LDSplashAnimationType {
        case fade
        case bounce
        case shrink
        case zoom
        case none
        case custom
    }
    
    var backgroundViewColor: UIColor? {
        didSet (newColor) {
            if backgroundViewColor == nil {
                self.backgroundViewColor = UIColor.gray
            } else {
                self.backgroundViewColor = newColor
            }
        }
    }
    var backgroundImage: UIImage? {
        didSet (newImage) {
            let imageView = UIImageView(image: newImage)
            imageView.frame = UIScreen.main.bounds
            self.addSubview(imageView)
        }
    }
    var animationDuration: CGFloat = 1.0 {
        didSet (newDuration) {
            if animationDuration == 1.0 {
                self.animationDuration = newDuration
                self.splashIcon?.animationDuration = Double(self.animationDuration)
            }
        }
    }
    
    var delegate: LDSplashDelegate?
    var splashIcon: LDSplashIcon?
    var customAnimation: CAAnimation? {
        didSet {
            if animationType == .custom {
                let animation = CAKeyframeAnimation(keyPath: "transform.scale")
                animation.values = [1, 0.9, 300]
                animation.keyTimes = [0, 0.4, 1]
                animation.duration = Double(self.animationDuration)
                animation.isRemovedOnCompletion = false
                animation.fillMode = kCAFillModeForwards
                let function1 = CAMediaTimingFunction(name: "kCAMediaTimingFunctionEaseOut")
                let function2 = CAMediaTimingFunction(name: "kCAMediaTimingFunctionEaseIn")
                animation.timingFunctions = [function1, function2]
                self.customAnimation = animation
            }
        }
    }
    var animationType: LDSplashAnimationType = .none//default is none
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(initWithAnimationType animationType: LDSplashAnimationType) {
        super.init(frame: UIScreen.main.bounds)
        self.animationType = animationType
    }
    
    init?(initWithBackgroundColor color: UIColor, animationType: LDSplashAnimationType) {
        super.init(frame: UIScreen.main.bounds)
        self.animationType = animationType
        self.backgroundColor = color
    }
    
    init?(initWithBackgroundImage image: UIImage, animationType: LDSplashAnimationType) {
        super.init(frame: UIScreen.main.bounds)
        self.animationType = animationType
        self.backgroundImage = image
        let imageView = UIImageView(image: image)
        imageView.frame = self.frame
        self.addSubview(imageView)
    }
    
    init?(initWithSplashIcon icon: LDSplashIcon, animationType: LDSplashAnimationType) {
        super.init(frame: UIScreen.main.bounds)
        self.animationType = animationType
        self.splashIcon = icon
        self.backgroundColor = backgroundColor
        splashIcon!.center = self.center
        self.layoutIfNeeded()
        self.addSubview(splashIcon!)
    }
    
    init?(initWithSplashIcon icon: LDSplashIcon, backgroundColor: UIColor, animationType: LDSplashAnimationType) {
        super.init(frame: UIScreen.main.bounds)
        self.splashIcon = icon
        self.backgroundColor = backgroundColor
        self.animationType = animationType
        self.splashIcon!.center = self.center
        self.addSubview(splashIcon!)
        self.layoutIfNeeded()
        self.bringSubview(toFront: splashIcon!)
    }
    
    init?(initWithSplashIcon icon: LDSplashIcon, backgroundImage: UIImage, animationType: LDSplashAnimationType) {
        super.init(frame: UIScreen.main.bounds)
        self.animationType = animationType
        self.splashIcon = icon
        self.splashIcon!.center = self.center
        self.backgroundImage = backgroundImage
        let imageView = UIImageView(image: backgroundImage)
        imageView.frame = self.frame
        self.layoutIfNeeded()
        self.addSubview(imageView)
        self.addSubview(splashIcon!)
    }
    
    //MARK: - Public Methods
    
    func startAnimation() {
        if splashIcon != nil {
            let dictionary = [String("animationDuration") : String(describing: self.animationDuration)]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "startAnimation"), object: self, userInfo: dictionary)
        }
        
        if delegate?.didBeginAnimatingWithDuration!(self.animationDuration) != nil {
            self.delegate?.didBeginAnimatingWithDuration!(self.animationDuration)
        }
        
        switch (animationType) {
        case .bounce:
            self.addBounceAnimation()
            break
        case .fade:
            self.addFadeAnimation()
            break
        case .zoom:
            self.addZoomAnimation()
            break
        case .shrink:
            self.addShrinkAnimation()
            break
        case .none:
            self.addNoAnimation()
            break
        case .custom:
//            if (animationType != nil) {
//                self.addCustomAnimationWithAnimation(customAnimation!)
//            } else {
//                self.addCustomAnimationWithAnimation(self.customAnimation!)
//            }
            break
        }
        
    }
    
    //MARK: - Animations
    
    func addBounceAnimation() {
        let bounceDuration = self.animationDuration * 0.8
        Timer.scheduledTimer(timeInterval: Double(bounceDuration), target: self, selector: #selector(LDSplashView.pingGrowAnimation), userInfo: nil, repeats: false)
    }
    
    func pingGrowAnimation() {
        let growDuration = self.animationDuration * 0.2
        UIView.animate(withDuration: Double(growDuration), animations: { () -> Void in
            let scaleTransform = CGAffineTransform(scaleX: 20, y: 20)
            self.transform = scaleTransform
            self.alpha = 0
            self.backgroundColor = UIColor.black
            }, completion: { (_) -> Void in
                self.removeFromSuperview()
                self.endAnimating()
        }) 
    }
    
    func growAnimation() {
        let growDuration = self.animationDuration * 0.7
        UIView.animate(withDuration: Double(growDuration), animations: { () -> Void in
            let scaleTransform = CGAffineTransform(scaleX: 20, y: 20)
            self.transform = scaleTransform
            self.alpha = 0
            }, completion: { (_) -> Void in
                self.removeFromSuperview()
                self.endAnimating()
        }) 
    }
    func addFadeAnimation() {
        UIView.animate(withDuration: Double(self.animationDuration), animations: { () -> Void in
            self.alpha = 0
            }, completion: { (_) -> Void in
                self.removeFromSuperview()
                self.endAnimating()
        }) 
    }
    
    func addZoomAnimation() {
        UIView.animate(withDuration: Double(self.animationDuration), animations: { () -> Void in
            let scaleTransform = CGAffineTransform(scaleX: 10, y: 10)
            self.transform = scaleTransform
            self.alpha = 0
            }, completion: { (_) -> Void in
                self.removeFromSuperview()
                self.endAnimating()
        }) 
    }
    
    func addShrinkAnimation() {
        UIView.animate(withDuration: Double(self.animationDuration), animations: { () -> Void in
            let scaleTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.transform = scaleTransform
            self.alpha = 0
            }, completion: { (_) -> Void in
                self.removeFromSuperview()
                self.endAnimating()
        }) 
    }
    
    func addNoAnimation() {
        Timer.scheduledTimer(timeInterval: Double(self.animationDuration), target: self, selector: #selector(LDSplashView.removeSplashView), userInfo: nil, repeats: true)
    }
    
    func addCustomAnimationWithAnimation(_ animation: CAAnimation) {
        self.layer.add(animation, forKey: "LDSplashAnimation")
        Timer.scheduledTimer(timeInterval: Double(self.animationDuration), target: self, selector: #selector(LDSplashView.removeSplashView), userInfo: nil, repeats: true)
    }
    
    func removeSplashView() {
        self.removeFromSuperview()
        self.endAnimating()
    }
    
    func endAnimating() {
        if delegate?.splashViewDidEndAnimating!(self) != nil {
            self.delegate?.splashViewDidEndAnimating!(self)
        }
    }

    }

@objc class LDSplashIcon: UIImageView {
    
    enum LDIconSplashAnimationType {
        case fade
        case bounce
        case ping
        case grow
        case blink
        case shrink
        case zoom
        case none
        case custom
    }
    
    var animationType: LDIconSplashAnimationType = .none
    var customAnimation: CAAnimation?
    var animationTime: CGFloat = 1.0
    var iconImage: UIImage?
    
    var iconColor: UIColor? {
        didSet(color) {
            if color == nil {
                self.tintColor = UIColor.white
            } else {
                 self.tintColor = iconColor
            }
        }
    }
    
    var iconSize: CGSize = CGSize(width: 80, height: 80) {
        didSet {
            self.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        }
    }
    
    var splashView: LDSplashView?
    
    init!(initWithImage image: UIImage) {
        super.init(image: image)
        
        self.iconImage = image
        self.tintColor = self.iconColor
        self.contentMode = .scaleAspectFit
        self.frame = CGRect(x: 0, y: 0, width: self.iconSize.width, height: self.iconSize.height)
        self.addObserverForAnimationNotification()
        
    }
    
    init?(initWithImage image: UIImage, animationType: LDIconSplashAnimationType) {
        super.init(image: image)
        self.iconImage = image
        self.animationDuration = Double(animationTime)
        self.animationType = animationType
        self.tintColor = iconColor
        self.contentMode = .scaleAspectFit
        self.frame = CGRect(x: 0, y: 0, width: iconSize.width, height: iconSize.height)
        self.addObserverForAnimationNotification()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Implementation
    func addObserverForAnimationNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(LDSplashIcon.receiveNotification(_:)), name: NSNotification.Name(rawValue: "startAnimation"), object: nil)
    }
    
    func receiveNotification(_ notification: Notification) {
        if notification.userInfo!["animationDuration"] != nil {
            let duration = Double(notification.userInfo!["animationDuration"] as! String)
            self.animationDuration = duration!
        }
        self.startAnimation()
    }
    
    func startAnimation() {
        switch (animationType) {
        case .bounce:
            self.addBounceAnimation()
            break
        case .fade:
            self.addFadeAnimation()
            break
        case .grow:
            self.addGrowAnimation()
            break
        case .shrink:
            self.addShrinkAnimation()
            break
        case .ping:
            self.addPingAnimation()
            break
        case .blink:
            self.addBlinkAnimation()
            break
        case .none:
            self.addNoAnimation()
            break
        case .custom:
            if customAnimation != nil {
                self.addCustomAnimation(customAnimation!)
            } else {
                self.addCustomAnimation(customAnimation!)
            }
            break
        default:
            print("No animation type selected")
            break
        }
    }
    
    func addBounceAnimation() {
        let shrinkDuration = self.animationDuration * 0.3
        let growDuration = self.animationDuration * 0.7
        
        UIView.animate(withDuration: Double(shrinkDuration), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: { () -> Void in
            let scaleTransform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            self.transform = scaleTransform
            }) { (_) -> Void in
                UIView.animate(withDuration: Double(growDuration), animations: { () -> Void in
                    let scaleTransform = CGAffineTransform(scaleX: 20, y: 20)
                    self.transform = scaleTransform
                    self.alpha = 0
                    }, completion: { (_) -> Void in
                        self.removeFromSuperview()
                })
                
        }
    }
    
    func addFadeAnimation() {
        UIView.animate(withDuration: Double(self.animationDuration), animations: { () -> Void in
            self.image = self.iconImage
            self.alpha = 0
            }, completion: { (_) -> Void in
                self.removeFromSuperview()
        }) 
    }
    
    func addGrowAnimation() {
        UIView.animate(withDuration: Double(self.animationDuration), animations: { () -> Void in
            let scaleTransform = CGAffineTransform(scaleX: 20, y: 20)
            self.transform = scaleTransform
            }, completion: { (_) -> Void in
                self.removeFromSuperview()
        }) 
    }
    
    func addShrinkAnimation() {
        UIView.animate(withDuration: Double(self.animationDuration), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: { () -> Void in
            let scaleTransform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            self.transform = scaleTransform
            }) { (_) -> Void in
                self.removeFromSuperview()
        }
    }
    
    func addPingAnimation() {
        Timer.scheduledTimer(timeInterval: Double(self.animationDuration), target: self, selector: #selector(LDSplashIcon.removeAnimations), userInfo: nil, repeats: true)
        UIView.animate(withDuration: 1.5, delay: 0, options: .repeat, animations: { () -> Void in
            let scaleTransform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            self.transform = scaleTransform
            }) { (_) -> Void in
                UIView.animate(withDuration: 1.5, animations: { () -> Void in
                    let scaleTransform = CGAffineTransform(scaleX: 20, y: 20)
                    self.transform = scaleTransform
                })
        }
    }
    
    func addBlinkAnimation() {
        self.alpha = 0
        Timer.scheduledTimer(timeInterval: Double(self.animationDuration), target: self, selector: #selector(LDSplashIcon.removeAnimations), userInfo: nil, repeats: true)
        UIView.animate(withDuration: 1.5, delay: 0, options: .repeat, animations: { () -> Void in
            self.alpha = 1
            }) { (_) -> Void in
                UIView.animate(withDuration: 1.5, animations: { () -> Void in
                    self.alpha = 0
                })
        }
    }
    
    func removeAnimations() {
        self.layer.removeAllAnimations()
        NotificationCenter.default.removeObserver(self)
        self.removeFromSuperview()
    }
    
    func addNoAnimation() {
        Timer.scheduledTimer(timeInterval: Double(self.animationDuration), target: self, selector: #selector(LDSplashIcon.removeAnimations), userInfo: nil, repeats: true)
    }
    
    func addCustomAnimation(_ animation: CAAnimation) {
        self.layer.add(animation, forKey: "LDSplashAnimation")
        Timer.scheduledTimer(timeInterval: Double(self.animationDuration), target: self, selector: #selector(LDSplashIcon.removeAnimations), userInfo: nil, repeats: true)
    }
}

@objc protocol LDSplashDelegate {
    @objc optional func didBeginAnimatingWithDuration(_ duration: CGFloat)
    
    @objc optional func splashViewDidEndAnimating(_ splashView: LDSplashView)
}
