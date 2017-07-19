//
//  PhoneView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 18/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class PhoneView: UIView {
    
    lazy var numberTextField : UITextField = {
        let numberCellTxt = UITextField()
        numberCellTxt.translatesAutoresizingMaskIntoConstraints = false
        numberCellTxt.textAlignment = .center
        numberCellTxt.font = UIFont(name: "OpenSans", size: 23)
        //numberCellTxt.keyboardType = .numbersAndPunctuation
        return numberCellTxt
    }()
    
    lazy var messageLbl : UILabel = {
        let msgLbl = UILabel()
        msgLbl.translatesAutoresizingMaskIntoConstraints = false
        msgLbl.text = "We’ll send you a magic code that you can use to login."
        msgLbl.font = UIFont(name: "OpenSans", size: 15)
        
        return msgLbl
    }()
    
    lazy var sendCodeBtn : UIButton = {
        let sendCodeButton = UIButton()
        sendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        sendCodeButton.setTitle("Send The Magic Code", for: .normal)
        
        return sendCodeButton
    }()
    
    func setup() {
        self.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1.0)
        
        
        // TextField for number
        self.addSubview(numberTextField)
        let textNumberColor = UIColor(red: 68/255, green: 180/255, blue: 142/255, alpha: 1.0)
        numberTextField.widthAnchor.constraint(equalToConstant: 264).isActive = true
        numberTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 122).isActive = true
        numberTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        numberTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        numberTextField.borderStyle = .roundedRect
        numberTextField.font = UIFont(name: "OpenSans", size: 23)
        numberTextField.textColor = textNumberColor;
        numberTextField.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 156/255, alpha: 1.0)
        setPlaceholder()
        
        // Message Label
        self.addSubview(messageLbl)
        messageLbl.widthAnchor.constraint(equalToConstant: 276).isActive = true
        messageLbl.heightAnchor.constraint(equalToConstant: 44).isActive = true
        messageLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageLbl.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -66).isActive = true
        messageLbl.numberOfLines = 2
        messageLbl.textAlignment = .center
        messageLbl.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1.0)
        
        // Send code button
        self.addSubview(sendCodeBtn)
        sendCodeBtn.widthAnchor.constraint(equalToConstant: 233).isActive = true
        sendCodeBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        sendCodeBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -136).isActive = true
        sendCodeBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sendCodeBtn.layer.backgroundColor = UIColor(red: 255/255, green: 210/255, blue: 55/255, alpha: 1.0).cgColor
        sendCodeBtn.setTitleColor(UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0), for: .normal)
        sendCodeBtn.layer.cornerRadius = 30
        addShadowToView(sendCodeBtn)
        
    }
    
    private func setPlaceholder() {
        let mutableAttrString = NSMutableAttributedString()
        let regularAttribute = [
            NSFontAttributeName: UIFont(name: "OpenSans", size: 23),
            NSForegroundColorAttributeName: UIColor(red: 68/255, green: 180/255, blue: 142/255, alpha: 1.0)
        ]
        let regularAttributedString = NSAttributedString(string: "Enter your cell #", attributes: regularAttribute)
        mutableAttrString.append(regularAttributedString)
        numberTextField.attributedPlaceholder = mutableAttrString
    }
    
    internal func addShadowToView(_ toView: UIView) {
        toView.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        toView.layer.shadowOpacity = 0.3;
        toView.layer.shadowRadius = 2
        toView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        toView.layer.shouldRasterize = true
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup();
    }

}
