//
//  DigitCodeView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class DigitCodeView: UIView {

    lazy var digitextField : UITextField = {
        let digitCellTxt = UITextField()
        digitCellTxt.translatesAutoresizingMaskIntoConstraints = false
        digitCellTxt.textAlignment = .center
        digitCellTxt.font = UIFont(name: "OpenSans", size: 23)
        digitCellTxt.keyboardType = .numbersAndPunctuation
        return digitCellTxt
    }()
    
    lazy var sendCodeBtn : UIButton = {
        let sendCodeButton = UIButton()
        sendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        sendCodeButton.setTitle("Submit code", for: .normal)
        
        return sendCodeButton
    }()
    
    lazy var resendCodeBtn : UIButton = {
        let resendCodeButton = UIButton()
        resendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        resendCodeButton.setTitle("Resend code", for: .normal)
        
        return resendCodeButton
    }()
    
    lazy var contactBtn : UIButton = {
        let contactButton = UIButton()
        contactButton.translatesAutoresizingMaskIntoConstraints = false
        contactButton.setTitle("Contact concierge", for: .normal)
        
        return contactButton
    }()
    
    
    func setup() {
        self.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1.0)
        
        
        // TextField for number
        self.addSubview(digitextField)
        let texDigitColor = UIColor(red: 68/255, green: 180/255, blue: 142/255, alpha: 1.0)
        digitextField.widthAnchor.constraint(equalToConstant: 264).isActive = true
        digitextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 122).isActive = true
        digitextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        digitextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        digitextField.borderStyle = .roundedRect
        digitextField.keyboardType = .numberPad
        digitextField.font = UIFont(name: "OpenSans", size: 23)
        digitextField.textColor = texDigitColor;
        digitextField.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 156/255, alpha: 1.0)
        setPlaceholder()
        
        // Send code button
        self.addSubview(sendCodeBtn)
        sendCodeBtn.widthAnchor.constraint(equalToConstant: 233).isActive = true
        sendCodeBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        sendCodeBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sendCodeBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 40).isActive = true
        sendCodeBtn.layer.backgroundColor = UIColor(red: 255/255, green: 210/255, blue: 55/255, alpha: 1.0).cgColor
        sendCodeBtn.setTitleColor(UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0), for: .normal)
        sendCodeBtn.layer.cornerRadius = 30
        addShadowToView(sendCodeBtn)
        
        
        //Resend code button
        self.addSubview(resendCodeBtn)
        resendCodeBtn.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 12)
        resendCodeBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -130).isActive = true
        resendCodeBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        resendCodeBtn.setTitleColor(UIColor(red: 166/255, green: 135/255, blue: 28/255, alpha: 1.0), for: .normal)
        
    
        //Contact button
        self.addSubview(contactBtn)
        contactBtn.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 12)
        contactBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -90).isActive = true
        contactBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contactBtn.setTitleColor(UIColor(red: 166/255, green: 135/255, blue: 28/255, alpha: 1.0), for: .normal)
    }
    
    private func setPlaceholder() {
        let mutableAttrString = NSMutableAttributedString()
        let regularAttribute = [
            NSFontAttributeName: UIFont(name: "OpenSans", size: 23),
            NSForegroundColorAttributeName: UIColor(red: 68/255, green: 180/255, blue: 142/255, alpha: 1.0)
        ]
        let regularAttributedString = NSAttributedString(string: "Enter 6-digit code", attributes: regularAttribute)
        mutableAttrString.append(regularAttributedString)
        digitextField.attributedPlaceholder = mutableAttrString
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup();
    }
    
    func changeColorButton() {
        if digitextField.text?.characters.count == 0 {
            sendCodeBtn.isUserInteractionEnabled = false
            sendCodeBtn.layer.backgroundColor = UIColor(red: 255/255, green: 210/255, blue: 55/255, alpha: 1.0).cgColor
            sendCodeBtn.setTitleColor(UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0), for: .normal)
        } 
    }
    
    func changeColorToEdit() {
        sendCodeBtn.isUserInteractionEnabled = true
        sendCodeBtn.layer.backgroundColor = UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1.0).cgColor
        sendCodeBtn.setTitleColor(UIColor.white, for: .normal)
    }

}
