//
//  UITextFieldExtensions.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 27/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

extension UITextField{
    @IBInspectable
    var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor : newValue!])

        }
    }
}
