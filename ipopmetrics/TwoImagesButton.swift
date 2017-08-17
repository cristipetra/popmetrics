//
//  TwoImagesButton.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class TwoImagesButton: UIButton {
    
    @IBInspectable var leftHandImage: UIImage? {
        didSet {
            leftHandImage = leftHandImage?.withRenderingMode(.alwaysTemplate)
            setupImages()
        }
    }
    @IBInspectable var rightHandImage: UIImage? {
        didSet {
            rightHandImage = rightHandImage?.withRenderingMode(.alwaysTemplate)
            setupImages()
        }
    }
    
    open var leftImageView: UIImageView!
    open var rightImageView: UIImageView!
    
    func setupImages() {
        if let leftImage = leftHandImage {
            leftImageView = UIImageView(image: leftImage)
            let height  = 18 as CGFloat
            let yPos = (self.frame.height - height) / 2
            leftImageView.contentMode = .scaleAspectFill
            leftImageView.frame = CGRect(x: 20 as CGFloat, y: yPos, width: 26 as CGFloat, height: height)
            self.addSubview(leftImageView)
        }
        
        if let rightImage = rightHandImage {
            rightImageView = UIImageView(image: rightImage)
            //rightImageView.tintColor = UIColor.black
            let height = 18 as CGFloat
            //let xPos = self.frame.width - width
            let yPos = (self.frame.height - height) / 2
            rightImageView.contentMode = .scaleAspectFill
            rightImageView.frame = CGRect(x: 54 as CGFloat, y: yPos, width: 16 as CGFloat, height: height)
            self.addSubview(rightImageView)
        }
        
    }
}
