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

extension UILabel {
    
    func setLineSpacingAndTitle(text: String, spacing: CGFloat, letterSpacing: CGFloat) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = spacing
        
        let attrString = NSMutableAttributedString(string: text)
        
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        attrString.addAttribute(NSAttributedStringKey.kern, value: letterSpacing, range: NSRange(location: 0, length: attrString.length))
        
        self.attributedText = attrString
    }
}
