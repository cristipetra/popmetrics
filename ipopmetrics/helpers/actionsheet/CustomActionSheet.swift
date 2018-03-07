//
//  CustomActionSheet.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class CustomActionSheet: UIView {
    
    lazy private var wrapperView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        wrapperView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        wrapperView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        wrapperView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        contentView.leftAnchor.constraint(equalTo: self.wrapperView.leftAnchor, constant: 0).isActive = true
        contentView.topAnchor.constraint(equalTo: self.wrapperView.topAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.wrapperView.rightAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.wrapperView.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupView() {
        self.addSubview(wrapperView)
        
        self.wrapperView.addSubview(contentView)
    }
    
    internal func addItem(title: String) {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 150).isActive = true
        view.backgroundColor = .red
        self.contentView.addSubview(view)
    }

}


