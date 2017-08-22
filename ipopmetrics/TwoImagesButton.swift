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
    
    @IBInspectable
    var leftHandImage: UIImage? {
        didSet {
            leftHandImage = leftHandImage?.withRenderingMode(.alwaysTemplate)
            setupImages()
        }
    }
    @IBInspectable
    var rightHandImage: UIImage? {
        didSet {
            rightHandImage = rightHandImage?.withRenderingMode(.alwaysTemplate)
            setupImages()
        }
    }
    
    open var leftImageView: UIImageView = UIImageView()
    open var rightImageView: UIImageView =  UIImageView()
    
    var imageButtonType: ImageButtonType = .unapproved {
        didSet {
            changeImageButtonType()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = 22
        self.layer.borderColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1).cgColor
        self.layer.borderWidth = 1.5
        
        changeImageButtonType()
        
        self.backgroundColor = PopmetricsColor.yellowBGColor
        
        self.addSubview(leftImageView)
        self.addSubview(rightImageView)
        
        setupImages()
    }
    
    func setupImages() {
        if let leftImage = leftHandImage {
            //leftImageView = UIImageView(image: leftImage)
            leftImageView.image = leftImage
            let height = 18 as CGFloat
            //let yPos = (self.frame.height - height) / 2
            let yPos = CGFloat(16)
            leftImageView.contentMode = .scaleAspectFill
            leftImageView.frame = CGRect(x: 20 as CGFloat, y: yPos, width: 26 as CGFloat, height: height)
        } 
        
        if let rightImage = rightHandImage {
            rightImageView = UIImageView(image: rightImage)
            //rightImageView.tintColor = UIColor.black
            let height = 18 as CGFloat
            //let xPos = self.frame.width - width
            //let yPos = (self.frame.height - height) / 2
            let yPos = CGFloat(16)
            rightImageView.contentMode = .scaleAspectFill
            rightImageView.frame = CGRect(x: 54 as CGFloat, y: yPos, width: 16 as CGFloat, height: height)
            
        }
    }
    
    func changeImageButtonType() {
        switch imageButtonType {
        case .unapproved:
            leftHandImage = UIImage(named: "iconApprove")
            rightHandImage = UIImage(named: "iconCalLeft")
        case .failed:
            leftHandImage = UIImage(named: "icon_timescore")
            rightHandImage = UIImage(named: "iconCalLeft")
        case .complete:
            leftHandImage = UIImage(named: "icon_timescore")
            rightHandImage = UIImage(named: "iconCalLeft")
        case .twitter:
            leftHandImage = UIImage(named: "icon_twitter")
            rightHandImage = UIImage(named: "iconCalLeft")
        default:
            break
        }
    }
}

enum ImageButtonType {
    case approved
    case unapproved
    case failed
    case complete
    case twitter
}
