//
//  ActionTodoButton.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 10/12/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ActionTodoButton: ActionButton {

    override func setupView() {
        //self.setupView()
        
        self.roundedCorners = true
        self.tintColor = PopmetricsColor.darkGrey
    
        self.layer.borderWidth = 3
        
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textColor = PopmetricsColor.borderButton
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 2
        
        
        self.layer.cornerRadius = 17
        self.layer.borderColor = PopmetricsColor.statisticsTableBackground.cgColor
        let myImage = UIImage(named: "iconCtaCheck")
        self.setImage(myImage, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 95, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 20)
        
        //changeTitle("Approve")
    }

}
