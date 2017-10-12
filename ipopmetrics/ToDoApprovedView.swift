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
        setUpVew()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpVew()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // View
    lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var approvedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Post approved!"
        return label
    }()
    
    lazy var undoBtn: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Undo", for: .normal)
        button.setTitleColor(PopmetricsColor.orange, for: .normal)
        return button
        
    }()
    //End View
    
    func setUpVew() {
        self.addSubview(mainView)
        
        mainView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mainView.topAnchor.constraint(equalTo: self.topAnchor, constant: -40).isActive = true
        mainView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 20).isActive = true
        
        mainView.layer.cornerRadius = 5
        
        mainView.backgroundColor = .white
        
        self.addSubview(approvedLabel)
        approvedLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        approvedLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        approvedLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        approvedLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(undoBtn)
        undoBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        undoBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        undoBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        undoBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        self.backgroundColor = .red
    }
    
}
