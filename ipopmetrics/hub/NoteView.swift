//
//  NoteView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 02/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class NoteView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    lazy var descriptionLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Semibold", size: 13)
        label.textColor = PopmetricsColor.textGrey
        label.textAlignment = .left
        
        return label
        
    }()
    
    lazy var performActionButton : TwoImagesButton = {
        
        let button = TwoImagesButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
        
    }()
    
    lazy var performActionLbl : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "OpenSans-Semibold", size: 10)
        label.text = "View Home Feed"
        label.textAlignment = .left
        return label
        
    }()
    
    lazy var containerView : UIView = {
        let container = GradientView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.clear
        return container
    }()
    
    lazy var gradientView : GradientView = {
        
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = UIColor(red: 255/255, green: 200/255, blue: 62/255, alpha: 1)
        view.endColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        return view
    }()
    
    func setUpView() {
        self.addSubview(containerView)
        setContainerView()
        setupGradient()
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(performActionButton)
        containerView.addSubview(performActionLbl)
        setDescriptionLabel()
        setPerformActionButton()
        setPerformActionLbl()
        
    }
    
    func setContainerView() {
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        
    }
    
    func setPerformActionLbl() {
        performActionLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            performActionLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -29),
            performActionLbl.topAnchor.constraint(equalTo: performActionButton.bottomAnchor, constant: +6),
            performActionLbl.widthAnchor.constraint(equalToConstant: 81),
            performActionLbl.heightAnchor.constraint(equalToConstant: 14)
            ])
        performActionLbl.textColor = PopmetricsColor.textGrey
        
    }
    
    func setPerformActionButton() {
        performActionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            performActionButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 14),
            performActionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -23),
            performActionButton.widthAnchor.constraint(equalToConstant: 90),
            performActionButton.heightAnchor.constraint(equalToConstant: 45)
            ])
        performActionButton.leftImageView.image = UIImage(named: "iconCtaHome")
        performActionButton.rightImageView.image = UIImage(named: "iconCalRightBold")
        
    }
    
    func setDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 9),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 177),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72)
            ])
        descriptionLabel.lineBreakMode = .byWordWrapping
        
    }
    
    func setDescriptionText(type: FeedType) {
        switch type {
        case .statistics:
            descriptionLabel.text = "Once you connect your Google Analytics, business stats will be available to view stats here."
            descriptionLabel.numberOfLines = 4
        case .todo:
            descriptionLabel.text = "You first need to do the recommended actions in the home feed!"
            descriptionLabel.numberOfLines = 4
        case .calendar:
            descriptionLabel.text = "Your posts will show dates & times for scheduling here once they're approved in the todo hub"
            descriptionLabel.numberOfLines = 4
        default:
            break
        }
    }
    
    
}

extension NoteView {
    func setupGradient() {
        self.insertSubview(gradientView, belowSubview: containerView)
        gradientView.frame = self.bounds
        gradientView.leftAnchor.constraint(equalTo: self.leftAnchor)
        gradientView.rightAnchor.constraint(equalTo: self.rightAnchor)
        gradientView.topAnchor.constraint(equalTo: self.topAnchor)
        gradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    }
}
