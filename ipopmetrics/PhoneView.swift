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
        //numberCellTxt.keyboardType = .numbersAndPunctuation
        numberCellTxt.keyboardType = .namePhonePad
        return numberCellTxt
    }()
    
    lazy var messageLbl : UILabel = {
        let msgLbl = UILabel()
        msgLbl.translatesAutoresizingMaskIntoConstraints = false
        msgLbl.text = "We’ll send you a magic code that you can use to login."
        msgLbl.font = UIFont(name: FontBook.regular, size: 15)
        
        return msgLbl
    }()
    
    lazy var sendCodeBtn : UIButton = {
        let sendCodeButton = UIButton()
        sendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        sendCodeButton.setTitle("Send The Magic Code", for: .normal)
        
        return sendCodeButton
    }()
    
    var buttonBottomConstraint: NSLayoutConstraint?
    
    func reloadSubViews() {
        numberTextField.removeFromSuperview()
        messageLbl.removeFromSuperview()
        sendCodeBtn.removeFromSuperview()
        self.addSubview(numberTextField)
        self.addSubview(messageLbl)
        self.addSubview(sendCodeBtn)
        if UIScreen.main.bounds.height > 480 {
            setNumberTextField(yAnchor: 122)
            setMessageLbl(yAnchor: -66)
            setSendCodeButton(yAnchor: -136)
        } else {
            setNumberTextField(yAnchor: 70)
            setMessageLbl(yAnchor: 0)
            setSendCodeButton(yAnchor: -70)
        }
        /*
        if UIDevice.current.orientation.isPortrait {
            setNumberTextField(yAnchor: 122)
            self.layoutIfNeeded()
            print("portrait")
        } else {
            setNumberTextField(yAnchor: 65)
            self.layoutIfNeeded()
            print("landscape")
        }
        if UIDevice.current.orientation.isPortrait {
            setMessageLbl(yAnchor: -66)
        } else {
            setMessageLbl(yAnchor: 22)
        }
        if UIDevice.current.orientation.isPortrait {
            setSendCodeButton(yAnchor: -136)
        } else {
            setSendCodeButton(yAnchor: -30)
        }
        */
    }
    
    func setup() {
        self.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1.0)
        
        
        // TextField for number
        self.addSubview(numberTextField)
        
        /*
        if UIDevice.current.orientation.isPortrait {
            setNumberTextField(yAnchor: 122)
        } else {
            setNumberTextField(yAnchor: 65)
        }
        */
        
        // Message Label
        self.addSubview(messageLbl)
        
        /*
        if UIDevice.current.orientation.isPortrait {
            setMessageLbl(yAnchor: -66)
        } else {
            setMessageLbl(yAnchor: 22)
        }
        */
        
        // Send code button
        self.addSubview(sendCodeBtn)
        if UIScreen.main.bounds.height > 480 {
            setNumberTextField(yAnchor: 122)
            setMessageLbl(yAnchor: -66)
            setSendCodeButton(yAnchor: -136)
        } else {
            setNumberTextField(yAnchor: 70)
            setMessageLbl(yAnchor: 0)
            setSendCodeButton(yAnchor: -70)
        }
        
        /*
        if UIDevice.current.orientation.isPortrait {
            setSendCodeButton(yAnchor: -136)
        } else {
            setSendCodeButton(yAnchor: -30)
        }
        */
        
    }
    private func setNumberTextField(yAnchor: CGFloat) {
        numberTextField.widthAnchor.constraint(equalToConstant: 264).isActive = true
        numberTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: yAnchor).isActive = true
        numberTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        numberTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        numberTextField.borderStyle = .roundedRect
        numberTextField.keyboardType = .phonePad
        numberTextField.font = UIFont(name: FontBook.regular, size: 23)
        let textNumberColor = UIColor(red: 68/255, green: 180/255, blue: 142/255, alpha: 1.0)
        numberTextField.textColor = textNumberColor;
        numberTextField.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 156/255, alpha: 1.0)
        setPlaceholder()
    }
    
    private func setMessageLbl(yAnchor: CGFloat) {
        messageLbl.widthAnchor.constraint(equalToConstant: 276).isActive = true
        messageLbl.heightAnchor.constraint(equalToConstant: 44).isActive = true
        messageLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageLbl.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yAnchor).isActive = true
        messageLbl.numberOfLines = 2
        messageLbl.textAlignment = .center
        messageLbl.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1.0)
    }
    
    private func setSendCodeButton(yAnchor: CGFloat) {
        buttonBottomConstraint = sendCodeBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: yAnchor)
        buttonBottomConstraint?.isActive = true
        sendCodeBtn.widthAnchor.constraint(equalToConstant: 233).isActive = true
        sendCodeBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        //sendCodeBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: yAnchor).isActive = true
        sendCodeBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sendCodeBtn.layer.backgroundColor = UIColor(red: 255/255, green: 210/255, blue: 55/255, alpha: 1.0).cgColor
        sendCodeBtn.setTitleColor(UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0), for: .normal)
        sendCodeBtn.layer.cornerRadius = 30
        
    }
    private func setPlaceholder() {
        let mutableAttrString = NSMutableAttributedString()
        let regularAttribute = [
            NSFontAttributeName: UIFont(name: FontBook.regular, size: 23),
            NSForegroundColorAttributeName: UIColor(red: 68/255, green: 180/255, blue: 142/255, alpha: 1.0)
        ]
        let regularAttributedString = NSAttributedString(string: "Enter your cell #", attributes: regularAttribute)
        mutableAttrString.append(regularAttributedString)
        numberTextField.attributedPlaceholder = mutableAttrString
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

extension UIView {
    func addShadowToView(_ toView: UIView, radius: CGFloat,opacity: Float) {
        toView.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        toView.layer.shadowOpacity = opacity;
        toView.layer.shadowRadius = radius
        toView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
}
