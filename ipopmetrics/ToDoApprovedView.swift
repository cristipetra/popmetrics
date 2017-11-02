//
//  ToDoApprovedView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 12/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ToDoApprovedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // View
    lazy var shadowLayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var approvedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Post approved! 🎉"
        label.font = UIFont(name: FontBook.semibold, size: 15)
        label.textColor = PopmetricsColor.darkGrey
        label.textAlignment = .center
        return label
    }()
    
    lazy var undoBtn: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Undo", for: .normal)
        button.setTitleColor(UIColor(red: 255/255, green: 119/255, blue: 106/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: FontBook.semibold, size: 15)
        return button
        
    }()
    //End View
    
    func setupView() {
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.insertSubview(shadowLayer, at: 0)
        
        shadowLayer.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        shadowLayer.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        self.addSubview(approvedLabel)
        approvedLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        approvedLabel.widthAnchor.constraint(equalToConstant: 139).isActive = true
        approvedLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        approvedLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        self.addSubview(undoBtn)
        undoBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -22).isActive = true
        undoBtn.widthAnchor.constraint(equalToConstant: 41).isActive = true
        undoBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        undoBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 10
        
    }
    
    func displayDeny() {
        approvedLabel.text = "Post denied"
    }
    
    func displayApproved() {
        approvedLabel.text = "Post approved! 🎉"
    }
    
}
