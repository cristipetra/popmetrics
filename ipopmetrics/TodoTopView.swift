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
        setUpView(view: .unapproved)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView(view: .unapproved)
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
        imageview.image = UIImage(named: "blackIconClock")!
        return imageview
    }()
    
    lazy var keyImageView : UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "iconDiy")!.withRenderingMode(.alwaysTemplate)
        return imageview
        
    }()
    
    lazy var notificationImageView : UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "iconFailedDifferentSection")!.withRenderingMode(.alwaysTemplate)
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
    
    lazy var viewDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var stackView : UIStackView!
    
    func setUpView(view: StatusArticle) {
        
        stackView = UIStackView(arrangedSubviews: [clockView, notificationView])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        initialSetup(view: clockView, label: clockLabel, image: clockImageView)
        //initialSetup(view: keyView, label: keyLabel, image: keyImageView)
        initialSetup(view: notificationView, label: notificationLabel, image: notificationImageView)
        //setActive(section: .unapproved)
        
        self.addSubview(viewDivider)
        viewDivider.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        viewDivider.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        viewDivider.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        viewDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        viewDivider.backgroundColor = PopmetricsColor.dividerBorder
    }
    
    func setUpClockView(selected: Bool) {
        
        //clockView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //clockView.leftAnchor.constraint(equalTo: stackView.leftAnchor,constant: 5).isActive = true
        clockView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        clockView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        clockView.layer.cornerRadius = 4
        if selected {
            clockView.backgroundColor = UIColor.white
        } else {
            clockView.backgroundColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        }
        //clockView.addSubview(clockImageView)
        setUpClockImageView(selected: selected)
        //clockView.addSubview(clockLabel)
        setUpClockLabel(selected: selected)
    }
    
    func setUpKeyView(selected: Bool) {
        
        //keyView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //keyView.leftAnchor.constraint(equalTo: clockView.rightAnchor, constant: 45).isActive = true
        //keyView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        //keyView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        if selected {
            keyView.backgroundColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        } else {
            keyView.backgroundColor = UIColor.white
        }
        //keyView.addSubview(keyImageView)
        setUpKeyImageView(selected: selected)
        //keyView.addSubview(keyLabel)
        setUpkeyLabel(selected: selected)
        keyView.isHidden = true
    }
    
    func setUpNotificationView(selected: Bool) {
        //notificationView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        //notificationView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 5).isActive = true
        notificationView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        notificationView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        if selected {
            notificationView.backgroundColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        } else {
            notificationView.backgroundColor = UIColor.white
        }
        //notificationView.addSubview(notificationImageView)
        setUpNotificationImageView(selected: selected)
        //notificationView.addSubview(notificationLabel)
        setUpNotificationLabel(selected: selected)
    }
    
    func setUpClockImageView(selected: Bool) {
        
        //clockImageView.centerYAnchor.constraint(equalTo: clockView.centerYAnchor).isActive = true
        //clockImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        //clockImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        //clockImageView.leftAnchor.constraint(equalTo: clockView.leftAnchor, constant: 9).isActive = true
        if selected {
            clockImageView.tintColor = UIColor.white
        } else {
            clockImageView.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        }
    }
    
    func setUpNotificationImageView(selected: Bool) {
        
        //notificationImageView.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor).isActive = true
        //notificationImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        //notificationImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        //notificationImageView.leftAnchor.constraint(equalTo: notificationView.leftAnchor, constant: 9).isActive = true
        if selected {
            notificationImageView.tintColor = UIColor.white
        } else {
            notificationImageView.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        }
    }
    
    func setUpKeyImageView(selected: Bool) {
        /*
         keyImageView.centerYAnchor.constraint(equalTo: keyView.centerYAnchor).isActive = true
         keyImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
         keyImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
         keyImageView.leftAnchor.constraint(equalTo: keyView.leftAnchor, constant: 9).isActive = true
         */
        if selected {
            keyImageView.tintColor = UIColor.white
        } else {
            keyImageView.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        }
    }
    
    func setUpClockLabel(selected: Bool) {
        
        //clockLabel.leftAnchor.constraint(equalTo: clockImageView.rightAnchor, constant: 5).isActive = true
        clockLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //clockLabel.topAnchor.constraint(equalTo: clockView.topAnchor, constant: 1).isActive = true
        //clockLabel.text = "(10)"
        clockLabel.font = UIFont(name: FontBook.semibold, size: 15)
        if selected {
            clockLabel.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        } else {
            clockLabel.textColor = UIColor.white
        }
        clockLabel.textAlignment = .center
        
    }
    
    func setUpNotificationLabel(selected: Bool) {
        
        //notificationLabel.leftAnchor.constraint(equalTo: notificationImageView.rightAnchor, constant: 5).isActive = true
        notificationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //notificationLabel.topAnchor.constraint(equalTo: notificationView.topAnchor).isActive = true
        //notificationLabel.text = "(3)"
        notificationLabel.font = UIFont(name: FontBook.regular, size: 15)
        notificationLabel.textAlignment = .center
        notificationLabel.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        if selected {
            notificationLabel.textColor = UIColor.white
        } else {
            notificationLabel.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        }
        
    }
    
    func setUpkeyLabel(selected: Bool) {
        
        //keyLabel.leftAnchor.constraint(equalTo: keyImageView.rightAnchor, constant: 5).isActive = true
        keyLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //keyLabel.topAnchor.constraint(equalTo: keyView.topAnchor).isActive = true
        //keyLabel.text = "(3)"
        keyLabel.font = UIFont(name: FontBook.regular, size: 15)
        keyLabel.textAlignment = .center
        keyLabel.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        if selected {
            keyLabel.textColor = UIColor.white
        } else {
            keyLabel.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        }
        
    }
    
    private func initialSetup(view: UIView, label: UILabel, image: UIImageView) {
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        view.widthAnchor.constraint(equalToConstant: 72).isActive = true
        view.layer.cornerRadius = 4
        initialLabelAndImageSetup(label: label, view: view, image: image)
    }
    
    private func initialLabelAndImageSetup(label: UILabel, view: UIView, image: UIImageView) {
        view.addSubview(image)
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 5).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //label.text = "(3)"
        label.font = UIFont(name: FontBook.regular, size: 15)
        label.textAlignment = .center
        label.text = "(0)"
        //label.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        image.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: 18).isActive = true
        image.widthAnchor.constraint(equalToConstant: 18).isActive = true
        image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 9).isActive = true
        
    }
    
    func setTextClockLabel(text: String) {
        clockLabel.text = text
        
    }
    
    func setTextNotificationLabel(text : String) {
        notificationLabel.text = text
    }
    func setActive(section: StatusArticle) {
        switch section {
        case .unapproved:
            setUpClockView(selected: true)
            setUpKeyView(selected: false)
            setUpNotificationView(selected: false)
            return
        case .failed:
            setUpClockView(selected: false)
            setUpKeyView(selected: false)
            setUpNotificationView(selected: true)
            return
        case .completed:
            setUpClockView(selected: false)
            setUpKeyView(selected: true)
            setUpNotificationView(selected: false)
            return
        default:
            return
        }
    }
}
