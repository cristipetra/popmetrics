//
//  SwipeExtension.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 01/12/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var swipeGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var swipeGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.swipeGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let swipeGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.swipeGestureRecognizer) as? Action
            return swipeGestureRecognizerActionInstance
        }
    }
    
    // Here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addSwipeGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.swipeGestureRecognizerAction = action
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeGestureRecognizer.direction = .right
        self.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleSwipeGesture(sender: UITapGestureRecognizer) {
        if let action = self.swipeGestureRecognizerAction {
            action?()
        }
    }
    
    
}
