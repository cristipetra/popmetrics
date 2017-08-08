//
//  HeaderView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 08/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class HeaderView: UIView {
    
    lazy var circleView : UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    
    lazy var statusLbl: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 150, height: 18))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: FontBook.regular, size: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup();
    }
    
    func setup() {
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(circleView)
        circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        circleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 27).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        circleView.layer.cornerRadius = 6
        circleView.backgroundColor = PopmetricsColor.blueMedium
        
        
        self.addSubview(statusLbl)
        statusLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        statusLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        statusLbl.text = "Attention required"
    }
    
    func changeTitle(title: String) {
        statusLbl.text = title
    }
    
}
