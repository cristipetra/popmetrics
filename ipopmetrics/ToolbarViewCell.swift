//
//  ToolbarViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class ToolbarViewCell: UIView {
    
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontBook.bold, size: 15)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        //title
        self.addSubview(title)
        title.text = "Schedule"
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        setupCorners()
        
    }
    
    func setupCorners() {
        DispatchQueue.main.async {
            self.roundCorners(corners: [.topRight, .topLeft] , radius: 12)
        }
    }


}
