//
//  RoundedCornersButton.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 24/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class RoundedCornersButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup();
    }
    
    func setup() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func changeTypeButton() {
        
    }
    
}
