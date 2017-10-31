//
//  IndividualTaskView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ActiveLabel

class IndividualTaskView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        
    }
    
    lazy var containerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: ActiveLabel = {
        
        let label = ActiveLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var expandButton: ButtonWithContainer = {
        
        let button = ButtonWithContainer(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.black//(red: 67, green: 76, blue: 84, alpha: 1)
        return button
    }()
    
    lazy var tapLayerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        return view
    }()
    
    lazy var taskContainerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.yellow
        return view
    }()
    
    var containerStackView: UIStackView!
    var isSelected: Bool = false
    
    var isContentHidden: Bool = false {
        didSet{
            taskContainerView.isHidden = !isContentHidden
        }
    }
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        setUpcontainerStackView()
        setUpContainerView()
        setUpTaskContainerView()
        setUpTitleLabel()
        setUpButton()
        
    }
    
    private func setUpContainerView() {
        
        containerView.leftAnchor.constraint(equalTo: containerStackView.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: containerStackView.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: containerStackView.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        
    }
    
    private func setUpTaskContainerView() {
        
        taskContainerView.leftAnchor.constraint(equalTo: containerStackView.leftAnchor).isActive = true
        taskContainerView.bottomAnchor.constraint(equalTo: containerStackView.bottomAnchor).isActive = true
        taskContainerView.rightAnchor.constraint(equalTo: containerStackView.rightAnchor).isActive = true
        taskContainerView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
    }
    
    func setUpcontainerStackView() {
        
        containerStackView = UIStackView(arrangedSubviews: [containerView,taskContainerView])
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.alignment = .center
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerStackView)
        
        containerStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerStackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerStackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    func setUpTitleLabel() {
        
        containerView.addSubview(titleLabel)
        titleLabel.textColor = PopmetricsColor.darkGrey
        titleLabel.font = UIFont(name: FontBook.semibold, size: 18)
        
        titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        
    }
    
    func setUpButton() {
        
        containerView.addSubview(expandButton)
        expandButton.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -20).isActive = true
        expandButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        expandButton.setImage(UIImage(named:"iconDown"), for: .normal)
        
    }
    
    func setUpSubtitleview() {
        
        containerView.addSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive = true
        subtitleLabel.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        subtitleLabel.font = UIFont(name: FontBook.regular, size: 12)
        
        subtitleLabel.text = "June 23 - July 24     www.hutcheson.io"
        subtitleLabel.URLColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        
        subtitleLabel.configureLinkAttribute = { (type, attribute, isSelected) in
            
            var attr = attribute
            attr[NSAttributedStringKey.font] = UIFont(name: FontBook.bold, size: 12)
            
            return attr
        }
        
    }
    
}
