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
        return button
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
    
    lazy var actionButton : TwoImagesButton = {
        
        let button = TwoImagesButton(type: UIButtonType.system)
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
        label.text = "Connect Twitter"
        label.textAlignment = .center
        label.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
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
    var setCorners = true
    internal var horizontalStackView: UIStackView!
    var approveStackView: UIStackView!
    
    func setUpFooter() {
        
        setUpApproveStackView()
        setShadow(button: actionButton)
        setShadow(button: informationBtn)
        setShadow(button: xButton)
        setShadow(button: loadMoreBtn)
        setUpDoubleButton()
        
        setUpHorizontalStackView()
    }
    
    
    func setUpApproveStackView() {
        approveStackView = UIStackView(arrangedSubviews: [actionButton, approveLbl])
        approveStackView.axis = .vertical
        approveStackView.distribution = .equalSpacing
        approveStackView.alignment = .center
        approveStackView.spacing = 2
        approveStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUpHorizontalStackView() {
        
        let placeholderView = UIView(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
        horizontalStackView = UIStackView(arrangedSubviews: [xButton, informationBtn, placeholderView, approveStackView])
        
        horizontalStackView.axis = .horizontal
        //horizontalStackView.distribution = .equalSpacing
        horizontalStackView.alignment = .top
        horizontalStackView.spacing = 16
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(horizontalStackView)
        
        
        //horizontalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8).isActive = true
        horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 13).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    func setIsTrafficUnconnected() {
        let placeholderView = UIView(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
        horizontalStackView = UIStackView(arrangedSubviews: [xButton, placeholderView, informationBtn, approveStackView])
        horizontalStackView.axis = .horizontal
        xButton.alpha = 0.0
        
        horizontalStackView.alignment = .top
        horizontalStackView.spacing = 16
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(horizontalStackView)
        
        horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 13).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    func deleteHandler() {
        animateButtonBlink(button: xButton)
        
    }
    
    func informationHandler() {
        print("information button pressed")
        animateButtonBlink(button: informationBtn)
    }
    
    
    func setUpDoubleButton() {
        
        actionButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        actionButton.tintColor = PopmetricsColor.darkGrey
        actionButton.addTarget(self, action: #selector(approveHandler), for: .touchUpInside)
        actionButton.imageButtonType = .twitter
    }
    
    func approveHandler() {
        animateButtonBlink(button: actionButton)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if setCorners == true {
            setupCorners()
        }
        gradientLayer.frame = self.bounds
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.roundCorners(corners: [.bottomLeft, .bottomRight] , radius: 12)
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
    
    func setShadow(button: UIButton) {
        button.layer.shadowColor = PopmetricsColor.textGrey.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
}

extension FooterView {
    func setupGradient() {
        self.insertSubview(gradientLayer, belowSubview: horizontalStackView)
        gradientLayer.frame = self.bounds
        gradientLayer.leftAnchor.constraint(equalTo: self.leftAnchor)
        gradientLayer.rightAnchor.constraint(equalTo: self.rightAnchor)
        gradientLayer.topAnchor.constraint(equalTo: self.topAnchor)
        gradientLayer.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    }
}
