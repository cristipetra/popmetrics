//
//  ActionTodoButton.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 10/12/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ActionTodoButton: ActionButton {
    
    internal  var rightImage: UIImage!
    
    internal var widthConstraint: NSLayoutConstraint!

    override func setupView() {
        //self.setupView()
        
        widthConstraint = self.widthAnchor.constraint(equalToConstant: 122)
        widthConstraint.isActive = true
        
        self.roundedCorners = true
        self.tintColor = PopmetricsColor.darkGrey
    
        self.layer.borderWidth = 3
        
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textColor = PopmetricsColor.borderButton
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 2
        
        self.layer.cornerRadius = 17
        self.layer.borderColor = PopmetricsColor.statisticsTableBackground.cgColor
        
        displayUnapproved()
    }
    
    internal func animateButton() {
        UIView.animate(withDuration: 0.2, animations: {
             self.frame = CGRect(x: self.frame.origin.x + 60, y: self.frame.origin.y, width: 50, height: self.frame.size.height)
            
        }) { (val) in
            self.displayApproved()
            self.layoutIfNeeded()
        }
    }
    
    internal func displayApproved() {
        self.widthConstraint.constant = 50
        changeTitle("")
        rightImage = UIImage(named: "iconCtaCheck")
        self.setImage(rightImage, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.frame.size.width = 50
    }
    
    internal func displayUnapproved() {
        changeTitle("Approve")
        rightImage = UIImage(named: "calendarArrowIcon")
        self.setImage(rightImage, for: .normal)
        self.widthConstraint.constant = 122
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 95, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 20)
        self.frame.size.width = 122
    }

}
