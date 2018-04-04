//
//  SplashScreen.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 20/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SplashScreen: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.adjustLabelSpacing(spacing: 5, lineHeight: 18, letterSpacing: 0.7)
        messageLabel.textAlignment = .center
        swipeLabel.adjustLabelSpacing(spacing: 0, lineHeight: 17, letterSpacing: 0.7)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.left {
            let nav = AppStoryboard.Boarding.instance.instantiateViewController(withIdentifier: "BoardingNavigationController") as! BoardingNavigationController
//            let animationVC = AppStoryboard.Boarding.instance.instantiateViewController(withIdentifier: "AnimationsViewController") as! AnimationsViewController;
            self.presentFromDirection(viewController: nav, direction: .right)
        }
    }
}
