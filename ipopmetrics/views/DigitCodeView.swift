//
//  DigitCodeView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

let codeMask = "######"

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
    
    lazy var logoView : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logoPop"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var instrLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Enter the 6-digit code."
        label.font = UIFont(name: FontBook.regular, size: 15)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var resendCodeBtn : UIButton = {
        let resendCodeButton = UIButton()
        resendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        resendCodeButton.setAttributedTitle("Resend code".attributed.font(UIFont(name: FontBook.semibold, size: 12)!)
                                                                    .underline().color(Color.buttonTitle),
                                            for: .normal)
        return resendCodeButton
    }()
    
    lazy var contactBtn : UIButton = {
        let contactButton = UIButton()
        contactButton.translatesAutoresizingMaskIntoConstraints = false
        contactButton.setTitle("Contact concierge", for: .normal)
        
        return contactButton
    }()
    
    lazy var closeBtn : UIButton = {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
        
        return closeButton
    }()
    
    func reloadSubViews() {
        closeBtn.removeFromSuperview()
        digitextField.removeFromSuperview()
        sendCodeBtn.removeFromSuperview()
        resendCodeBtn.removeFromSuperview()
//        contactBtn.removeFromSuperview()
        logoView.removeFromSuperview()
        instrLabel.removeFromSuperview()
        self.addSubview(logoView)
        self.addSubview(closeBtn)
        self.addSubview(digitextField)
        self.addSubview(sendCodeBtn)
        self.addSubview(resendCodeBtn)
        self.addSubview(instrLabel)
//        self.addSubview(contactBtn)
        setResendCodeButton(yAnchor: -130)
        /*
         if UIDevice.current.orientation.isPortrait {
         setNumberTextView(yAnchor: 122)
         self.layoutIfNeeded()
         print("portrait")
         } else {
         setNumberTextView(yAnchor: 65)
         self.layoutIfNeeded()
         print("landscape")
         }
         */
        setNumberTextView(yAnchor: 122)
        
        setSendCodeButton(yAnchor: 30)
        /*
         if UIDevice.current.orientation.isPortrait {
         setResendCodeButton(yAnchor: -130)
         } else {
         setResendCodeButton(yAnchor: -60)
         }
         
         if UIDevice.current.orientation.isPortrait {
         setContactButton(yAnchor: -90)
         } else {
         setContactButton(yAnchor: -30)
         }
         */
        if UIScreen.main.bounds.height > 480 {
            setCloseButton(yAnchor: 40)
            setNumberTextView(yAnchor: 122)
            setSendCodeButton(yAnchor: 30)
            setResendCodeButton(yAnchor: -130)
//            setContactButton(yAnchor: -90)
            setLogoView(yAnchor: 20)
            setInstructionLabel(yAnchor: 18)
        } else {
            setNumberTextView(yAnchor: 70)
            setSendCodeButton(yAnchor: 30)
            setResendCodeButton(yAnchor: -130)
            setContactButton(yAnchor: -70)
        }
    }
    
    func setup() {
        self.backgroundColor = .white
        
        self.addSubview(closeBtn)
        setCloseButton(yAnchor: 40)
        
        self.addSubview(logoView)
        setLogoView(yAnchor: 20)
        
        // TextField for number
        self.addSubview(digitextField)
        /*
         if UIDevice.current.orientation.isPortrait {
         setNumberTextView(yAnchor: 122)
         self.layoutIfNeeded()
         print("portrait")
         } else {
         setNumberTextView(yAnchor: 65)
         self.layoutIfNeeded()
         print("landscape")
         }
         */
        setNumberTextView(yAnchor: 122)
        
        // Send code button
        self.addSubview(sendCodeBtn)
        setSendCodeButton(yAnchor: 30)
        
        //Resend code button
        self.addSubview(resendCodeBtn)
        /*
         if UIDevice.current.orientation.isPortrait {
         setResendCodeButton(yAnchor: -130)
         } else {
         setResendCodeButton(yAnchor: -60)
         }
         */
        setResendCodeButton(yAnchor: -130)
        
        
        addSubview(instrLabel)
        setInstructionLabel(yAnchor: 18)
        //Contact button
//        self.addSubview(contactBtn)
        /*
         if UIDevice.current.orientation.isPortrait {
         setContactButton(yAnchor: -90)
         } else {
         setContactButton(yAnchor: -30)
         }
         */
//        setContactButton(yAnchor: -90)
    }
    
    private func setCloseButton(yAnchor: CGFloat) {
        closeBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 27).isActive = true
        closeBtn.topAnchor.constraint(equalTo: self.topAnchor, constant: yAnchor).isActive = true
        
    }
    
    private func setNumberTextView(yAnchor: CGFloat) {
        digitextField.widthAnchor.constraint(equalToConstant: 264).isActive = true
        digitextField.topAnchor.constraint(equalTo: self.topAnchor, constant: yAnchor).isActive = true
        digitextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        digitextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        digitextField.keyboardType = .numberPad
        digitextField.borderStyle = .none
        digitextField.backgroundColor = Color.phoneNumberField
        digitextField.cornerRadius = 5
        setPlaceholder()
    }
    
    private func setSendCodeButton(yAnchor: CGFloat) {
        sendCodeBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        sendCodeBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yAnchor).isActive = true
        sendCodeBtn.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60).isActive = true
        sendCodeBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60).isActive = true
        sendCodeBtn.setTitleColor(UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0), for: .normal)
        sendCodeBtn.borderWidth = 3
        sendCodeBtn.setTitleColor(Color.buttonTitle, for: .normal)
        sendCodeBtn.setTitleColor(.lightGray, for: .disabled)
        sendCodeBtn.cornerRadius = 22.5
        //   addShadowToView(sendCodeBtn)
    }
    
    private func setLogoView(yAnchor: CGFloat) {
        logoView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logoView.topAnchor.constraint(equalTo: self.topAnchor, constant: yAnchor).isActive = true
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
}

