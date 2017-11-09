//
//  UIViewExtension.swift
//  ipopmetrics
//
//  Created by Ivan Hahanov on 11/9/17.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
extension UIView {
    @IBInspectable var shadowColor: UIColor? {
        set { layer.shadowColor = newValue?.cgColor }
        get { return layer.shadowColor.flatMap({ UIColor(cgColor: $0) }) }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set { layer.shadowOpacity = newValue }
        get { return layer.shadowOpacity }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set { layer.shadowRadius = newValue }
        get { return layer.shadowRadius }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable var maskToBounds: Bool {
        set { layer.masksToBounds = newValue }
        get { return layer.masksToBounds }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var roundedCorners: Bool {
        set {
            self.clipsToBounds = true
            self.cornerRadius = newValue ? self.bounds.height / 2 : 0
        } get {
            return self.cornerRadius == self.bounds.height / 2
        }
    }
}
