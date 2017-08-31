//
//  GradientView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit


@IBDesignable final class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = UIColor.clear
    @IBInspectable var endColor: UIColor = UIColor.clear
    
    let gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        
        gradientLayer.transform = CATransform3DMakeRotation(3 * CGFloat.pi / 2, 0, 0, 1)
        gradientLayer.frame = CGRect(x: CGFloat(0),
                                y: CGFloat(0),
                                width: self.frame.width,
                                height: self.frame.height)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.zPosition = -1
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
         gradientLayer.frame = self.bounds
    }
    
}
