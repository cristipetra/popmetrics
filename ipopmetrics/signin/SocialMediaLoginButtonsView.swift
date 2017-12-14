//
//  SocialMediaLoginButtonsView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/12/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
open class SocialMediaLoginButtonsView: UIView {
    
    lazy var socialImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var separatorView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var socialButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: FontBook.semibold, size: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        
        return button
    }()
    
    lazy var imageBackground: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        addImageView()
        addSeparator()
        addButton()
        self.layer.cornerRadius = 4
    }
    
    private func addImageView() {
        self.addSubview(imageBackground)
        self.addSubview(socialImageView)
        socialImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9).isActive = true
        socialImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9).isActive = true
        socialImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        socialImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        imageBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9).isActive = true
        imageBackground.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageBackground.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 9).isActive = true
        imageBackground.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageBackground.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageBackground.layer.cornerRadius = 4
        socialImageView.contentMode = .center
    }
    
    private func addSeparator() {
        self.addSubview(separatorView)
        separatorView.widthAnchor.constraint(equalToConstant: 2).isActive = true
        separatorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 49).isActive = true
    }
    
    private func addButton() {
        self.addSubview(socialButton)
        socialButton.leftAnchor.constraint(equalTo: separatorView.rightAnchor, constant: 7).isActive = true
        socialButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        socialButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 2).isActive = true
        socialButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setButton(title: SocialMediaType) {
        switch title {
        case .facebook:
            socialButton.setTitle("Connect with \(title.rawValue)", for: .normal)
            socialImageView.image = UIImage(named:"iconFacebook")?.withRenderingMode(.alwaysTemplate)
            socialImageView.tintColor = UIColor(red: 69/255, green: 101/255, blue: 161/255, alpha: 1)
            self.backgroundColor = UIColor(red: 69/255, green: 101/255, blue: 161/255, alpha: 1)
            separatorView.backgroundColor = UIColor(red: 97/255, green: 129/255, blue: 183/255, alpha: 1)
        case .linkedIn:
            socialButton.setTitle("Connect with \(title.rawValue)", for: .normal)
            socialImageView.image = #imageLiteral(resourceName: "iconLinkedin").withRenderingMode(.alwaysTemplate)
            socialImageView.tintColor = UIColor(red: 21/255, green: 131/255, blue: 187/255, alpha: 1)
            self.backgroundColor = UIColor(red: 21/255, green: 131/255, blue: 187/255, alpha: 1)
            separatorView.backgroundColor = UIColor(red: 43/255, green: 145/255, blue: 191/255, alpha: 1)
        case .twitter:
            socialButton.setTitle("Connect with \(title.rawValue)", for: .normal)
            socialImageView.image = UIImage(named: "iconCtaTwitter")?.withRenderingMode(.alwaysTemplate)
            imageBackground.isHidden = true
            socialImageView.tintColor = UIColor.white
            separatorView.backgroundColor = UIColor(red: 143/255, green: 205/255, blue: 248/255, alpha: 1)
            self.backgroundColor = UIColor(red: 100/255, green: 182/255, blue: 239/255, alpha: 1)
        }
    }
    
}

enum SocialMediaType: String {
    case facebook = "Facebook"
    case linkedIn = "LinkedIn"
    case twitter = "Twitter"
}

