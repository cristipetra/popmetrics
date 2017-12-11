//
//  ActionButton.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/12/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    private var imageBtn: UIImage!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.roundedCorners = true
        self.tintColor = PopmetricsColor.darkGrey
        
        self.layer.cornerRadius = 22
        self.layer.borderColor = PopmetricsColor.borderButton.cgColor
        self.layer.borderWidth = 3

        self.titleLabel?.lineBreakMode = .byWordWrapping
        
        self.titleLabel?.textColor = PopmetricsColor.borderButton
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 2
        
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 20)
        imageBtn = UIImage(named: "calendarArrowIcon")
        self.setImage(imageBtn, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 140, bottom: 0, right: 0)
        
    }

    internal func changeTitle(_ title: String) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: FontBook.bold, size: 15)
    }
    
    internal func hideImageBtn() {
        
        self.setImage(nil, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
    }
}
