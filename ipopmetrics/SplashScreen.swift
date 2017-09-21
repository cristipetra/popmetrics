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
    
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.left {
            let animationVC = AnimationsViewController()
            self.presentFromDirection(viewController: animationVC, direction: .right)
        }
    }
}

extension UIViewController {
    func presentFromDirection(viewController: UIViewController, direction: TransitionDirection) {
        let newVC = viewController
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        switch direction {
        case .left:
            transition.subtype = kCATransitionFromLeft
        case .right:
            transition.subtype = kCATransitionFromRight
        default:
            break
        }
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(newVC, animated: false, completion: nil)
    }
    
    func dismissToDirection(direction: TransitionDirection) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionPush
        switch direction {
        case .left:
            transition.subtype = kCATransitionFromLeft
        case .right:
            transition.subtype = kCATransitionFromRight
        default:
            break
        }
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}

enum TransitionDirection {
    case left
    case right
}
