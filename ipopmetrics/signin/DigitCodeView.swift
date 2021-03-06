//
//  DigitCodeView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

let codeMask = "####"

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
    
    
    lazy var instrLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter the 4-digit code."
        label.font = UIFont(name: FontBook.regular, size: 15)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var resendCodeBtn : UIButton = {
        let resendCodeButton = UIButton()
        resendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        resendCodeButton.setAttributedTitle("Resend code".attributed.font(UIFont(name: FontBook.semibold, size: 12)!)
            .underline().color(PopmetricsColor.buttonTitle),
                                            for: .normal)
        return resendCodeButton
    }()
    
    lazy var contactBtn : UIButton = {
        let contactButton = UIButton()
        contactButton.translatesAutoresizingMaskIntoConstraints = false
        contactButton.setTitle("Contact concierge", for: .normal)
        
        return contactButton
    }()
    
    override func layoutSubviews() {
        
    }
    
    
    func setup() {
        self.backgroundColor = .white
        
        
        // TextField for number
        self.addSubview(digitextField)
        
        setNumberTextView(yAnchor: -70)
        
        // Send code button
        self.addSubview(sendCodeBtn)
        if UIScreen.main.bounds.height > 667 {
            setSendCodeButton(topSpace: 120)
        } else  {
            setSendCodeButton(topSpace: 60)
        }
        
        //Resend code button
        self.addSubview(resendCodeBtn)
        setResendCodeButton(yAnchor: -130)
        
        addSubview(instrLabel)
        setInstructionLabel(yAnchor: 18)
        
    }
    
    
    private func setNumberTextView(yAnchor: CGFloat) {
        digitextField.widthAnchor.constraint(equalToConstant: 264).isActive = true
        digitextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: yAnchor).isActive = true
        digitextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        digitextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        digitextField.keyboardType = .numberPad
        digitextField.borderStyle = .none
        digitextField.backgroundColor = PopmetricsColor.phoneNumberField
        digitextField.cornerRadius = 5
        setPlaceholder()
    }
    
    private func setSendCodeButton(topSpace: CGFloat) {
        sendCodeBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        sendCodeBtn.topAnchor.constraint(equalTo: digitextField.bottomAnchor, constant: topSpace).isActive = true
        sendCodeBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60).isActive = true
        sendCodeBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60).isActive = true
        sendCodeBtn.borderWidth = 3
        sendCodeBtn.setTitleColor(PopmetricsColor.buttonTitle, for: .normal)
        sendCodeBtn.setTitleColor(.lightGray, for: .disabled)
        sendCodeBtn.cornerRadius = 22.5
    }
    
    
    private func setInstructionLabel(yAnchor: CGFloat) {
        instrLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        instrLabel.topAnchor.constraint(equalTo: digitextField.bottomAnchor, constant: yAnchor).isActive = true
    }
    
    private func setResendCodeButton(yAnchor: CGFloat) {
        resendCodeBtn.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 12)
        resendCodeBtn.topAnchor.constraint(equalTo: sendCodeBtn.bottomAnchor, constant: 20).isActive = true
        //        resendCodeBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: yAnchor).isActive = true
        resendCodeBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setContactButton(yAnchor: CGFloat) {
        contactBtn.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 12)
        contactBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: yAnchor).isActive = true
        contactBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        contactBtn.setTitleColor(UIColor(red: 166/255, green: 135/255, blue: 28/255, alpha: 1.0), for: .normal)
    }
    
    private func setPlaceholder() {
        let mutableAttrString = NSMutableAttributedString()
        let regularAttribute = [
            NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 23),
            NSAttributedStringKey.foregroundColor: UIColor(red: 68/255, green: 180/255, blue: 142/255, alpha: 1.0)
        ]
        let regularAttributedString = NSAttributedString(string: "Enter 4-digit code", attributes: regularAttribute)
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
}
