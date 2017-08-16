//
//  TodoTopView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class TodoTopView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
        //fatalError("init(coder:) has not been implemented")
    }
    
    lazy var clockView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        
        return view
    }()
    
    lazy var keyView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var notificationView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var clockImageView : UIImageView = {
        
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "clockIcon")
        return imageview
        
    }()
    
    lazy var keyImageView : UIImageView = {
        
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "icon_DIY_DifferentSection")
        return imageview
        
    }()
    
    
    lazy var notificationImageView : UIImageView = {
        
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "icon_Failed_DifferentSection")
        return imageview
        
    }()
    
    lazy var clockLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var keyLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    
    lazy var notificationLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private var stackView : UIStackView!
    
    func setUpView() {
        
        stackView = UIStackView(arrangedSubviews: [clockView, keyView, notificationView])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //self.addSubview(clockView)
        //self.addSubview(keyView)
        //self.addSubview(notificationView)
        
        setUpClockView()
        setUpKeyView()
        setUpNotificationView()
        
    }
    
    func setUpClockView() {
        
        clockView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        clockView.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        clockView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        clockView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        clockView.layer.cornerRadius = 4
        
        clockView.addSubview(clockImageView)
        setUpClockImageView()
        clockView.addSubview(clockLabel)
        setUpClockLabel()
    }
    
    func setUpKeyView() {
        
        keyView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        keyView.leftAnchor.constraint(equalTo: clockView.rightAnchor, constant: 45).isActive = true
        keyView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        keyView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        keyView.addSubview(keyImageView)
        setUpKeyImageView()
        keyView.addSubview(keyLabel)
        setUpkeyLabel()
    }
    
    func setUpNotificationView() {
        
        notificationView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        notificationView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        notificationView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        notificationView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        
        notificationView.addSubview(notificationImageView)
        setUpNotificationImageView()
        notificationView.addSubview(notificationLabel)
        setUpNotificationLabel()
    }
    
    func setUpClockImageView() {
        
        clockImageView.centerYAnchor.constraint(equalTo: clockView.centerYAnchor).isActive = true
        clockImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        clockImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        clockImageView.leftAnchor.constraint(equalTo: clockView.leftAnchor, constant: 9).isActive = true
    }
    
    func setUpNotificationImageView() {
        
        notificationImageView.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor).isActive = true
        notificationImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        notificationImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        notificationImageView.leftAnchor.constraint(equalTo: notificationView.leftAnchor, constant: 9).isActive = true
    }
    
    func setUpKeyImageView() {
        
        keyImageView.centerYAnchor.constraint(equalTo: keyView.centerYAnchor).isActive = true
        keyImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        keyImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        keyImageView.leftAnchor.constraint(equalTo: keyView.leftAnchor, constant: 9).isActive = true
    }
    
    func setUpClockLabel() {
        
        clockLabel.leftAnchor.constraint(equalTo: clockImageView.rightAnchor, constant: 5).isActive = true
        clockLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        clockLabel.topAnchor.constraint(equalTo: clockView.topAnchor, constant: 1).isActive = true
        clockLabel.text = "(10)"
        clockLabel.font = UIFont(name: FontBook.semibold, size: 15)
        clockLabel.textColor = UIColor.white
        clockLabel.textAlignment = .center
        
    }
    
    func setUpNotificationLabel() {
        
        notificationLabel.leftAnchor.constraint(equalTo: notificationImageView.rightAnchor, constant: 5).isActive = true
        notificationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        notificationLabel.topAnchor.constraint(equalTo: notificationView.topAnchor).isActive = true
        notificationLabel.text = "(3)"
        notificationLabel.font = UIFont(name: FontBook.regular, size: 15)
        notificationLabel.textAlignment = .center
        notificationLabel.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        
    }
    
    func setUpkeyLabel() {
        
        keyLabel.leftAnchor.constraint(equalTo: keyImageView.rightAnchor, constant: 5).isActive = true
        keyLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        keyLabel.topAnchor.constraint(equalTo: keyView.topAnchor).isActive = true
        keyLabel.text = "(3)"
        keyLabel.font = UIFont(name: FontBook.regular, size: 15)
        keyLabel.textAlignment = .center
        keyLabel.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        
    }
    
    func setTextClockLabel(text: String) {
        clockLabel.text = text
        
    }
    
    func setTextNotificationLabel(text : String) {
        notificationLabel.text = text
    }
    
}
