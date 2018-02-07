//
//  MessagesBadgeView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class MessagesBadgeView: UIView {
    
    lazy var count: UILabel = {
       let countLbl = UILabel()
        countLbl.text = "0"
        countLbl.font = UIFont(name: FontBook.bold, size: 12)
        countLbl.textColor = .white
        return countLbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        count.translatesAutoresizingMaskIntoConstraints = false
        count.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        count.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    
    private func setupView() {
        self.backgroundColor = PopmetricsColor.salmondColor
        self.maskToBounds = true
        self.roundedCorners = true
        
        
        addSubview(count)
    }
    
    internal func changeValue(_ value: UInt) {
        self.count.text = String(value)
    }

}
