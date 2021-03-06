//
//  FooterView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//


import UIKit
import SwiftRichString

class FooterView: UIView {
    
    // VIEW
    lazy var containerView : UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.clear
        return container
    }()
    
    lazy var actionButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.tintColor = PopmetricsColor.darkGrey
        return button
    }()
    
    lazy var leftButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: FontBook.semibold, size: 15)
        button.titleLabel?.textAlignment = .left
        button.setTitleColor(PopmetricsColor.visitSecondColor, for: .normal)
        button.setTitleColor(PopmetricsColor.visitSecondColor.withAlphaComponent(0.3), for: .highlighted)
        button.setTitle("More Info", for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var gradientLayer: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = PopmetricsColor.statisticsGradientStartColor
        view.endColor = PopmetricsColor.statisticsGradientEndColor
        return view
    }()
    
    lazy var approveStackView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    internal var horizontalStackView: UIStackView!
    
    // END VIEW
    
    var feedCard: FeedCard?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupView()
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setupCorners()
        gradientLayer.frame = self.bounds
        
        setConstraintsContainerView()
        setConstraintsApproveStackView()
        setConstraintsLeftButton()
        setConstraintsRightButton()
        
        setConstraintsHorizontalStackView()
    }
    
    func setupView() {
        self.addSubview(containerView)
        addApproveStackView()
        addHorizontalStackView()
    }
    
    private func setConstraintsLeftButton() {
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        //leftButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
    }
    
    func setConstraintsContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setConstraintsApproveStackView() {
        approveStackView.translatesAutoresizingMaskIntoConstraints = false
        approveStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        approveStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -10).isActive = true
    }
    
    private func setConstraintsRightButton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.widthAnchor.constraint(equalToConstant: 165).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func setConstraintsHorizontalStackView() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 10).isActive = true
    }
    
    
    private func addHorizontalStackView() {
        horizontalStackView = UIStackView(arrangedSubviews: [leftButton])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .top
        containerView.addSubview(horizontalStackView)
    }
    
    func addApproveStackView() {
        containerView.addSubview(approveStackView)
        
        approveStackView.addArrangedSubview(actionButton)
        approveStackView.axis = .vertical
        approveStackView.distribution = .equalSpacing
        approveStackView.alignment = .center
        approveStackView.spacing = 2
    }
    
    @objc func handlerT() {
        let infoCardVC = AppStoryboard.Boarding.instance.instantiateViewController(withIdentifier: "InfoCardViewID") as! InfoCardViewController;
        
        self.parentViewController?.present(infoCardVC, animated: true, completion: {
            guard let _ = self.feedCard else { return }
            var tooltipContent = ""
            if let content = self.feedCard!.tooltipContent {
                tooltipContent = content
            }
            var title = ""
            if let titleT = self.feedCard?.tooltipTitle {
                title = titleT
            }
            infoCardVC.displayMarkInfo(text: tooltipContent, title)
            
        })
    }
    
    internal func setIsTrafficUnconnected() {
        horizontalStackView = UIStackView(arrangedSubviews: [leftButton])
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .top
        horizontalStackView.distribution = .equalSpacing
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(approveStackView)
        approveStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        approveStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -10).isActive = true
        
        containerView.addSubview(horizontalStackView)
        horizontalStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 0).isActive = true
        
        
        leftButton.isHidden = true
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.roundCorners(corners: [.bottomLeft, .bottomRight] , radius: 12)
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight] , radius: 12)
        }
    }
    
    func displayOnlyActionButton() {
        horizontalStackView.isHidden = true
    }
    
    func setShadow(button: UIButton) {
        button.layer.shadowColor = PopmetricsColor.textGrey.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func hideButton(button: UIButton) {
        button.alpha = 0
        button.isUserInteractionEnabled = false
    }
    
    func disableButton(button: UIButton) {
        button.alpha = 0.3
        button.isUserInteractionEnabled = false
    }
    
    internal func setEmailViewType() {
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
        self.setIsTrafficUnconnected()
        self.leftButton.alpha = 1
        
        actionButton.changeTitle("Connect Email")
    }
    
    internal func configure(_ imageButtonType: ImageButtonType) {
        switch imageButtonType {
        case .google:
            actionButton.changeTitle("Connect Google")
        case .addToTask:
            actionButton.changeTitle("Add to Tasks")
        case .traffic:
            actionButton.changeTitle("View Traffic \nReport")
            setIsTrafficUnconnected()
        default:
            return
        }
    }
    
    internal func changeTitleLeftButton(_ title: String) {
        self.leftButton.setTitle(title, for: .normal)
    }
    
    internal func setTitleActionBtn(_ title: String) {
        
    }
    
}

extension FooterView {
    func setupGradient() {
        self.insertSubview(gradientLayer, belowSubview: containerView)
        gradientLayer.frame = self.bounds
        gradientLayer.leftAnchor.constraint(equalTo: self.leftAnchor)
        gradientLayer.rightAnchor.constraint(equalTo: self.rightAnchor)
        gradientLayer.topAnchor.constraint(equalTo: self.topAnchor)
        gradientLayer.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    }
}

extension UIButton {
    func setShadow() {
        self.layer.shadowColor = PopmetricsColor.textGrey.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
