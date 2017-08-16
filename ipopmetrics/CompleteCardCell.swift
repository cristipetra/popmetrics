//
//  CompleteCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class CompleteCardCell: UITableViewCell {
    
    lazy var containerView : UIView = {
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var shadowContainerView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.feedBackgroundColor()
        return view
        
    }()
    
    lazy var bottomView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    lazy var buttonContainerView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var topImageView : UIImageView = {
        
        let topImageView = UIImageView()
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return topImageView
    }()
    
    lazy var titleLabel : UILabel = {
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "You're all caught up."
        title.font = UIFont(name: FontBook.bold, size: 23)
        title.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        return title
    }()
    
    
    lazy var xButton : UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    lazy var messageLabel : UILabel = {
        
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.text = "Find more actions to improve your business in the Home Feed!"
        message.font = UIFont(name: FontBook.semibold, size: 14)
        message.textColor = UIColor(red: 189/255, green: 197/255, blue: 203/255, alpha: 1)
        return message
    }()
    
    lazy var toHomeFeedButton : UIButton = {
        
        let homeFeedBtn = UIButton(type: UIButtonType.system)
        homeFeedBtn.translatesAutoresizingMaskIntoConstraints = false
        homeFeedBtn.setTitle("To Home Feed", for: .normal)
        homeFeedBtn.backgroundColor = UIColor.white
        return homeFeedBtn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.contentView.insertSubview(shadowContainerView, belowSubview: containerView)
        
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(topImageView)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(xButton)
        self.containerView.addSubview(messageLabel)
        self.containerView.addSubview(bottomView)
        self.containerView.addSubview(buttonContainerView)
        
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        shadowContainerView.layer.masksToBounds = false
        addShadowToView(shadowContainerView, radius: 3, opacity: 0.5)
        shadowContainerView.layer.cornerRadius = 10
        
        setContainerView()
        setShadowView()
        setBottomView()
        setButtonContainerView()
        setToHomeFeedBtn()
        setTopImageView()
        setMessageLbl()
        setXButton()
        setTitleLbl()
    }
    
    func setContainerView() {
        
        containerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    func setShadowView() {
        
        shadowContainerView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        shadowContainerView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        shadowContainerView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -8).isActive = true
        shadowContainerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
    }
    
    func setBottomView() {
        
        bottomView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
    }
    
    func setButtonContainerView() {
        
        buttonContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30).isActive = true
        buttonContainerView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 60).isActive = true
        buttonContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -60).isActive = true
        buttonContainerView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20).isActive = true
        //buttonContainerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.buttonContainerView.addSubview(toHomeFeedButton)
        //buttonContainerView.roundCorners(corners: .allCorners, radius: 16)
        //addShadowToViewBtn(buttonContainerView)
    }
    
    func setToHomeFeedBtn() {
        toHomeFeedButton.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor, constant: 0).isActive = true
        toHomeFeedButton.rightAnchor.constraint(equalTo: buttonContainerView.rightAnchor, constant: 0).isActive = true
        toHomeFeedButton.centerYAnchor.constraint(equalTo: self.buttonContainerView.centerYAnchor).isActive = true
        
        toHomeFeedButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    
        addShadowToViewBtn(toHomeFeedButton)
        toHomeFeedButton.tintColor = UIColor.black
        toHomeFeedButton.layer.cornerRadius = 22
        
    }
    
    func setMessageLbl() {
        
        messageLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 23).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18).isActive = true
        messageLabel.numberOfLines = 2
        
    }
    
    func setTitleLbl() {
        
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 29).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: topImageView.rightAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: xButton.leftAnchor, constant:30).isActive = true
        titleLabel.numberOfLines = 2
    }
    
    func setXButton() {
        
        xButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24).isActive = true
        xButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        xButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        xButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        xButton.setImage(UIImage(named: "icon_close"), for: .normal)
        xButton.tintColor = UIColor.black
        
    }
    
    func setTopImageView() {
        
        topImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 24).isActive = true
        topImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 31).isActive = true
        topImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        topImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        topImageView.image = UIImage(named: "iconCheck")
        topImageView.contentMode = .scaleAspectFit
        
    }
    
}
