//
//  SocialIconView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 26/01/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class SocialIconView: UIView {

    lazy var socialIcon: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var socialType: String? {
        didSet {
            changeIcon()
            changeConstraintsImage()
        }
    }
    
    private var constraintHeight: NSLayoutConstraint!
    private var constraintWidth: NSLayoutConstraint!
    
    private var heightIcon: CGFloat = 20
    private var widthIcon: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.maskToBounds = true
        self.cornerRadius = self.frame.size.width / 2
        
        self.addSubview(socialIcon)
        
        socialType = "twitter"
    }
    
    override func layoutSubviews() {
        
        socialIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        constraintWidth = socialIcon.widthAnchor.constraint(equalToConstant: widthIcon)
        constraintWidth.isActive = true
        constraintHeight = socialIcon.heightAnchor.constraint(equalToConstant: heightIcon)
        constraintHeight.isActive = true
    }
    
    internal func changeIcon() {
        guard let _ = socialType else { return }
        switch socialType! {
        case "twitter":
            socialIcon.image = #imageLiteral(resourceName: "icon_twitter")
        case "facebook":
            socialIcon.image = #imageLiteral(resourceName: "iconFacebookSocial")
        default:
            break
        }
    }
    
    internal func changeConstraintsImage() {
        guard let _ = socialType else { return }
        if constraintHeight == nil || constraintWidth == nil {  return }
        switch socialType! {
        case "twitter":
            heightIcon = 20
            constraintHeight.constant = 20
            constraintWidth.constant = 20
            widthIcon = 20
        case "facebook":
            heightIcon = 20
            constraintHeight.constant = 20
            constraintWidth.constant = 18
            widthIcon = 18
        default:
            break
        }
        
    }

}
