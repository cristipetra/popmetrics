//
//  RoundButton.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 20/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup();
    }
    
    func setup() {
        DispatchQueue.main.async {
            self.setRadiusAndBorder()
        }
        setShadows()
    }
    
    private func setRadiusAndBorder() {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = PopmetricsColor.textGrey.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.tintColor = PopmetricsColor.darkGrey
    }
    
    private func setShadows() {
        self.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.22).cgColor
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.white
    }

}
