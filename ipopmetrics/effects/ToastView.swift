//
//  ToastView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ToastView: UIView {
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup()
    }
    
    func setup() {
        self.backgroundColor = PopmetricsColor.salmondColor
        title.text = "new (1)"
        setupCorners()
        addTitle()
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.roundCorners(corners: .allCorners, radius: 8)
            
        }
    }
    
    internal func addTitle() {
        self.addSubview(title)
        title.font = UIFont(name: FontBook.bold, size: 10)
        title.textColor = .white
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        
    }
}
