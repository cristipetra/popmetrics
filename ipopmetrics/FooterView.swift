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
    
    var loadMoreCount: Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpFooter()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setUpFooter()
    }
    
    // VIEW
    
    lazy var loadMoreBtn : RoundButton = {
        
        let button = RoundButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 46).isActive = true
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 23
        button.tintColor = PopmetricsColor.textGrey
        button.setImage(UIImage(named: "iconLoadMore"), for: .normal)
        button.alpha = 0.0
        return button
    }()
    
    lazy var loadMoreLbl : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Load More"
        label.font = UIFont(name: FontBook.semibold, size: 10)
        label.textAlignment = .center
        label.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        label.alpha = 0
        return label
        
    }()
    
    lazy var containerView : UIView = {
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.clear
        return container
    }()
    
    lazy var informationBtn : RoundButton = {
        
        let button = RoundButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 46).isActive = true
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true
        button.addTarget(self, action: #selector(informationHandler), for: .touchUpInside)
        let attrTitle = Style.default {
            $0.font = FontAttribute(FontBook.regular, size: 30)
            $0.color = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        }
        button.setAttributedTitle("i".set(style: attrTitle), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 23
        return button
    }()

    lazy var actionButton: TwoColorButton = {
        let button = TwoColorButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var xButton : RoundButton = {
        
        let button = RoundButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 46).isActive = true
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true
        button.addTarget(self, action: #selector(deleteHandler), for: .touchUpInside)
        button.setImage(UIImage(named: "iconCtaClose"), for: .normal)
        button.tintColor = PopmetricsColor.textGrey
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 23
        return button
    }()
    
    lazy var approveLbl : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontBook.semibold, size: 10)
        label.text = ""
        label.textAlignment = .center
        label.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        label.numberOfLines = 2
        return label
        
    }()
    
    lazy var gradientLayer: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = PopmetricsColor.statisticsGradientStartColor
        view.endColor = PopmetricsColor.statisticsGradientEndColor
        return view
    }()
    
    
    // END VIEW
    var loadMoreStackView: UIStackView!
    internal var horizontalStackView: UIStackView!
    var approveStackView: UIStackView!
    
    func setUpFooter() {
        self.addSubview(containerView)
        setContainerView()
        setUpApproveStackView()
        setShadow(button: actionButton)
        setShadow(button: informationBtn)
        setShadow(button: xButton)
        setShadow(button: loadMoreBtn)
        setUpDoubleButton()
        setUpLoadMoreStackView()
        setUpHorizontalStackView()
        
        xButton.isHidden = true
    }
    
    func setContainerView() {
        
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setUpApproveStackView() {
        approveStackView = UIStackView(arrangedSubviews: [actionButton, approveLbl])
        approveStackView.axis = .vertical
        approveStackView.distribution = .equalSpacing
        approveStackView.alignment = .center
        approveStackView.spacing = 2
        approveStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUpLoadMoreStackView() {
        
        loadMoreStackView = UIStackView(arrangedSubviews: [loadMoreBtn, loadMoreLbl])
        loadMoreStackView.axis = .vertical
        loadMoreStackView.distribution = .equalSpacing
        loadMoreStackView.alignment = .center
        loadMoreStackView.spacing = 2
        loadMoreStackView.translatesAutoresizingMaskIntoConstraints = false
        loadMoreStackView.widthAnchor.constraint(equalToConstant: 54).isActive = true
    }
    
    func setUpHorizontalStackView() {
        horizontalStackView = UIStackView(arrangedSubviews: [xButton, informationBtn, loadMoreStackView])
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .top
        //horizontalStackView.spacing = 16
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(approveStackView)
        //approveStackView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 14).isActive = true
        approveStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        approveStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: 0).isActive = true
        
        containerView.addSubview(horizontalStackView)
        horizontalStackView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 24).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 10).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: self.approveStackView.leftAnchor, constant: -12).isActive = true
        
    }
    
    func setIsTrafficUnconnected() {
        
        horizontalStackView = UIStackView(arrangedSubviews: [xButton, loadMoreStackView, informationBtn])
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .top
        horizontalStackView.distribution = .equalSpacing
        //horizontalStackView.spacing = 16
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(approveStackView)
        approveStackView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 14).isActive = true
        approveStackView.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: 0).isActive = true
        
        containerView.addSubview(horizontalStackView)
        horizontalStackView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 14).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 10).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: self.approveStackView.leftAnchor, constant: -10).isActive = true
        
    }
    
    @objc func deleteHandler() {
        animateButtonBlink(button: xButton)
    }
    
    @objc func informationHandler() {
        print("information button pressed")
        animateButtonBlink(button: informationBtn)
    }
    
    
    func setUpDoubleButton() {
        
        actionButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        actionButton.tintColor = PopmetricsColor.darkGrey
        actionButton.addTarget(self, action: #selector(approveHandler), for: .touchUpInside)
        actionButton.imageButtonType = .twitter
    }
    
    @objc func approveHandler() {
        animateButtonBlink(button: actionButton)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setupCorners()
        gradientLayer.frame = self.bounds
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.roundCorners(corners: [.bottomLeft, .bottomRight] , radius: 12)
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight] , radius: 12)
        }
    }
    
    func animateButtonBlink(button: UIButton) {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            button.alpha = 0.0
        }) { (completion) in
            button.alpha = 1.0
        }
    }
    
    func hideInformationButton() {
        informationBtn.isHidden = true
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
        self.xButton.alpha = 1
        self.hideButton(button: self.loadMoreBtn)
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
