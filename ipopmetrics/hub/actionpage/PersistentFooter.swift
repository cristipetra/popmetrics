//
//  PersistentFooter.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 09/12/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class PersistentFooter: UIView {
    
    lazy private var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 189/255, green: 197/255, blue: 203/255, alpha: 1)
        return view
    }()
    
    lazy var leftBtn: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(PopmetricsColor.secondGray, for: .normal)
        button.setTitle("Deny Post", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont(name: FontBook.bold, size: 15)
        return button
    }()
    
    lazy var rightBtn: ActionButton = {
        let button = ActionButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        self.backgroundColor = .white
        
        self.addSubview(leftBtn)
        self.addSubview(rightBtn)
        self.addSubview(separatorView)
        
        leftBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        leftBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftBtn.widthAnchor.constraint(equalToConstant: 90).isActive = true
        leftBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        rightBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24).isActive = true
        rightBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightBtn.widthAnchor.constraint(equalToConstant: 163).isActive = true
        rightBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        rightBtn.layer.cornerRadius = 17
        
        separatorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

}