//
//  TwoImagesButton.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class TwoImagesButton: RoundButton {
    
    @IBInspectable
    var leftHandImage: UIImage? {
        didSet {
            leftHandImage = leftHandImage?.withRenderingMode(.alwaysTemplate)
            setLeftImage()
        }
    }
    @IBInspectable
    var rightHandImage: UIImage? {
        didSet {
            rightHandImage = rightHandImage?.withRenderingMode(.alwaysTemplate)
            setRightImage()
        }
    }
    
    var approveButtonText : String? {
        didSet {
            rightTextLabel.text = approveButtonText
            setUpTitleBtn()
        }
    }
    
    open var leftImageView: UIImageView = UIImageView()
    open var rightImageView: UIImageView =  UIImageView()
    open var rightTextLabel: UILabel = UILabel()
    
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
        self.layer.borderWidth = 2
        
        changeImageButtonType()
        
        self.backgroundColor = PopmetricsColor.yellowBGColor
        
        self.addSubview(leftImageView)
        self.addSubview(rightImageView)
        self.addSubview(rightTextLabel)
        
    }
    
    func setLeftImage() {
        if let leftImage = leftHandImage {
            leftImageView.image = leftImage
            let height = 18 as CGFloat
            //let yPos = (self.frame.height - height) / 2
            let yPos = CGFloat(16)
            leftImageView.contentMode = .scaleAspectFill
            leftImageView.frame = CGRect(x: 20 as CGFloat, y: yPos, width: 26 as CGFloat, height: height)
        }
    }
    
    func setRightImage() {
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
    
    func setUpTitleBtn() {
        
        if let leftImage = leftHandImage {
            leftImageView.image = leftImage
            leftImageView.tintColor = UIColor.white
            let height = 16
            //let yPos = (self.frame.height - height) / 2
            let yPos = 12
            leftImageView.contentMode = .scaleAspectFill
            leftImageView.frame = CGRect(x: 15, y: yPos, width: 20, height: height)
        }
        
        if let buttonText = approveButtonText {
            rightTextLabel.textColor = UIColor.white
            rightTextLabel.font = UIFont(name: FontBook.semibold, size: 10)
            rightTextLabel.text = buttonText
            rightTextLabel.textAlignment = .center
            rightTextLabel.frame = CGRect(x: 44, y: 10, width: 50, height: 18)
            
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
            leftHandImage = UIImage(named: "iconCtaTwitter")
            leftImageView.frame.size.height = 24
            leftImageView.frame.origin.y = 12
            rightHandImage = UIImage(named: "iconCalLeft")
        case .approved:
            leftHandImage = UIImage(named: "icon2CtaApprovepost")
            rightImageView.isHidden = true
            approveButtonText = "Approved"
        case .rescheduled:
            leftHandImage = UIImage(named: "icon2CtaApprovepost")
            rightImageView.isHidden = true
            approveButtonText = "Rescheduled"
        case .allowNotification:
            leftHandImage = UIImage(named: "iconAlertMessage")
            leftImageView.frame.origin.y = 14
        case .todo:
            leftHandImage = UIImage(named: "iconCtaTodo")
        default:
            break
        }
    }
    
    func changeToDisabled() {
        self.backgroundColor = .white
        self.leftImageView.layer.opacity = 0.3
        self.rightImageView.layer.opacity = 0.3
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.isEnabled = false
    }
}

enum ImageButtonType {
    case approved
    case unapproved
    case failed
    case complete
    case twitter
    case rescheduled
    case allowNotification
    case todo
}
