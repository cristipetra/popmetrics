//
//  PhoneView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 18/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

let phoneNumberMask = "+1 (###) ###-####"

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
        msgLbl.text = "Enter your cell number and we’ll send you\na magic code that you can use to login."
        msgLbl.font = UIFont(name: FontBook.regular, size: 15)
        
        return msgLbl
    }()
    
    lazy var logoView : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logoPop"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var sendCodeBtn : UIButton = {
        let sendCodeButton = UIButton()
        sendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        sendCodeButton.setTitle("Send Magic Code", for: .normal)
        
        return sendCodeButton
    }()
    
    lazy var backBtn : UIButton = {
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
        
        return backButton
    }()
    
    var buttonBottomConstraint: NSLayoutConstraint?
    
    func reloadSubViews() {
        backBtn.removeFromSuperview()
        numberTextField.removeFromSuperview()
        messageLbl.removeFromSuperview()
        sendCodeBtn.removeFromSuperview()
        logoView.removeFromSuperview()
        self.addSubview(backBtn)
        self.addSubview(numberTextField)
        self.addSubview(messageLbl)
        self.addSubview(sendCodeBtn)
        self.addSubview(logoView)
        if UIScreen.main.bounds.height > 480 {
            setBackButton(yAnchor: 40)
            setNumberTextField(yAnchor: 122)
            setMessageLbl(yAnchor: -66)
            setSendCodeButton(yAnchor: -136)
            setLogoView(yAnchor: 20)
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
        self.backgroundColor = .white
        
        self.addSubview(backBtn)
        
        
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
        self.addSubview(logoView)
        
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
            setBackButton(yAnchor: 20)
            setNumberTextField(yAnchor: 122)
            setMessageLbl(yAnchor: -66)
            setSendCodeButton(yAnchor: -136)
            setLogoView(yAnchor: 20)
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
    
    private func setBackButton(yAnchor: CGFloat) {
        backBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 27).isActive = true
        backBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: yAnchor).isActive = true
    }
    
    private func setLogoView(yAnchor: CGFloat) {
        logoView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logoView.topAnchor.constraint(equalTo: self.topAnchor, constant: yAnchor).isActive = true
    }
    
    private func setNumberTextField(yAnchor: CGFloat) {
        numberTextField.widthAnchor.constraint(equalToConstant: 264).isActive = true
        numberTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: yAnchor).isActive = true
        numberTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        numberTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        numberTextField.borderStyle = .none
        numberTextField.backgroundColor = Color.phoneNumberField
        numberTextField.cornerRadius = 5
        numberTextField.keyboardType = .phonePad
        setPlaceholder()
    }
    
    private func setMessageLbl(yAnchor: CGFloat) {
        messageLbl.widthAnchor.constraint(equalToConstant: 300).isActive = true
        messageLbl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        messageLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        messageLbl.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yAnchor).isActive = true
        messageLbl.numberOfLines = 2
        messageLbl.textAlignment = .center
        messageLbl.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1.0)
    }
    
    private func setSendCodeButton(yAnchor: CGFloat) {
        buttonBottomConstraint = sendCodeBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: yAnchor)
        buttonBottomConstraint?.isActive = true
        sendCodeBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        sendCodeBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60).isActive = true
        sendCodeBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60).isActive = true
        
        sendCodeBtn.borderWidth = 3
        sendCodeBtn.setTitleColor(Color.buttonTitle, for: .normal)
        sendCodeBtn.setTitleColor(.lightGray, for: .disabled)
        sendCodeBtn.cornerRadius = 22.5
        
    }
    
    private func setPlaceholder() {
        let mutableAttrString = NSMutableAttributedString()
        let regularAttribute = [
            NSAttributedStringKey.font: UIFont(name: FontBook.regular, size: 23),
            NSAttributedStringKey.foregroundColor: UIColor(red: 68/255, green: 180/255, blue: 142/255, alpha: 1.0)
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
