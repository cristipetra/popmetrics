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
    
    lazy var loadMoreBtn : UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var informationBtn : UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var actionButton : TwoImagesButton = {
        
        let button = TwoImagesButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    lazy var xButton : UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var approveLbl : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontBook.semibold, size: 10)
        label.text = "Connect Twitter"
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
        
    }()
    
    
    private var horizontalStackView: UIStackView!
    var approveStackView: UIStackView!
    
    // END VIEW
    
    func setUpFooter() {
        
        setUpApproveStackView()
        
        setUpXButton()
        setUpInformationBtn()
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
        placeholderView.backgroundColor = .red
        horizontalStackView = UIStackView(arrangedSubviews: [xButton, informationBtn, placeholderView, approveStackView])
        
        horizontalStackView.axis = .horizontal
        //horizontalStackView.distribution = .equalSpacing
        horizontalStackView.alignment = .top
        horizontalStackView.spacing = 16
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(horizontalStackView)
        
        
        horizontalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8).isActive = true
        horizontalStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        horizontalStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    func setUpXButton() {
        
        xButton.widthAnchor.constraint(equalToConstant: 46).isActive = true
        xButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        xButton.addTarget(self, action: #selector(deleteHandler), for: .touchUpInside)
        xButton.layer.cornerRadius = 23//xButton.frame.size.width / 2
        xButton.clipsToBounds = true
        xButton.setImage(UIImage(named: "iconCtaClose"), for: .normal)
        xButton.layer.borderColor = UIColor.black.cgColor
        xButton.tintColor = UIColor.black
        xButton.backgroundColor = UIColor.white
        xButton.layer.borderWidth = 1.5
    }
    
    func deleteHandler() {
        
        print("SSS X Button pressed")
        animateButtonBlink(button: xButton)
        
    }
    
    func setUpInformationBtn() {
        
        informationBtn.widthAnchor.constraint(equalToConstant: 46).isActive = true
        informationBtn.heightAnchor.constraint(equalToConstant: 46).isActive = true
        informationBtn.addTarget(self, action: #selector(informationHandler), for: .touchUpInside)
        informationBtn.layer.cornerRadius = 23
        
        let attrTitle = Style.default {
            
            $0.font = FontAttribute(FontBook.regular, size: 30)
            $0.color = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        }
        informationBtn.setAttributedTitle("i".set(style: attrTitle), for: .normal)
        informationBtn.layer.borderColor = UIColor.black.cgColor
        informationBtn.layer.borderWidth = 1.5
        informationBtn.backgroundColor = UIColor.white
    }
    
    func informationHandler() {
        print("SSS information button pressed")
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
    
    func animateButtonBlink(button: UIButton) {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            button.alpha = 0.0
        }) { (completion) in
            button.alpha = 1.0
        }
    }
    
    func hideInformationButton() {
        informationBtn.isHidden = true
        //horizontalStackView.insertArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 46, height: 46)), at: 2)
    }
    
}

