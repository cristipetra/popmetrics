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
        let imageView = UIImageView(image: #imageLiteral(resourceName: "newLogo"))
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
    
    lazy var closeBtn : UIButton = {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "iconCalLeftBold"), for: .normal)
        
        return closeButton
    }()
    
    func reloadSubViews() {
        closeBtn.removeFromSuperview()
        digitextField.removeFromSuperview()
        sendCodeBtn.removeFromSuperview()
        resendCodeBtn.removeFromSuperview()
        contactBtn.removeFromSuperview()
        self.addSubview(closeBtn)
        self.addSubview(digitextField)
        self.addSubview(sendCodeBtn)
        self.addSubview(resendCodeBtn)
        self.addSubview(contactBtn)
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
            setContactButton(yAnchor: -90)
        } else {
            setNumberTextView(yAnchor: 70)
            setSendCodeButton(yAnchor: 30)
            setResendCodeButton(yAnchor: -130)
            setContactButton(yAnchor: -70)
        }
    }
    
    func setup() {
        self.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1.0)
        
        self.addSubview(closeBtn)
        setCloseButton(yAnchor: 40)
        
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
        
        //Contact button
        self.addSubview(contactBtn)
        /*
         if UIDevice.current.orientation.isPortrait {
         setContactButton(yAnchor: -90)
         } else {
         setContactButton(yAnchor: -30)
         }
         */
        setContactButton(yAnchor: -90)
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
        digitextField.borderStyle = .roundedRect
        digitextField.keyboardType = .numberPad
        digitextField.font = UIFont(name: "OpenSans", size: 23)
        let texDigitColor = UIColor(red: 68/255, green: 180/255, blue: 142/255, alpha: 1.0)
        digitextField.textColor = texDigitColor;
        digitextField.backgroundColor = UIColor(red: 255/255, green: 233/255, blue: 156/255, alpha: 1.0)
        setPlaceholder()
    }
    
    private func setSendCodeButton(yAnchor: CGFloat) {
        sendCodeBtn.widthAnchor.constraint(equalToConstant: 233).isActive = true
        sendCodeBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        sendCodeBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sendCodeBtn.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yAnchor).isActive = true
        sendCodeBtn.layer.backgroundColor = UIColor(red: 255/255, green: 210/255, blue: 55/255, alpha: 1.0).cgColor
        sendCodeBtn.setTitleColor(UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0), for: .normal)
        sendCodeBtn.layer.cornerRadius = 30
        //   addShadowToView(sendCodeBtn)
    }
    
    private func setResendCodeButton(yAnchor: CGFloat) {
        resendCodeBtn.titleLabel?.font = UIFont(name: "OpenSans-Bold", size: 12)
        resendCodeBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: yAnchor).isActive = true
        resendCodeBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        resendCodeBtn.setTitleColor(UIColor(red: 166/255, green: 135/255, blue: 28/255, alpha: 1.0), for: .normal)
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
