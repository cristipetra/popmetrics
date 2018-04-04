//
//  UIViewControllerExtensions.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 04/04/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

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
        }
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}

enum TransitionDirection {
    case left
    case right
}
