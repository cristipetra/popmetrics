//
//  RequiredAction.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//


import UIKit
import SwiftRichString
import TwitterKit
import NotificationBannerSwift
import SafariServices

class RequiredAction: UITableViewCell {
    
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var connectionLineView: UIView!
    
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTopConstraint: NSLayoutConstraint!
    
    var item: FeedCard?
    var actionHandler: CardActionHandler?
    var indexPath: IndexPath?
    var infoDelegate: InfoButtonDelegate?
    
    // Extend view
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    // End extend view
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpTopView()
        setupCorners()
        setUpShadowLayer()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ item: FeedCard, handler: CardActionHandler) {
        self.item = item
        self.actionHandler = handler
        
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.titleLabel.text  = item.headerTitle
        messageLabel.text = item.message
        
        //Todo move from here addTarget
        if(item.actionLabel == "Notifications") {
            footerView.actionButton.imageButtonType = .allowNotification
            self.footerView.actionButton.addTarget(self, action:#selector(handleActionNotifications(_:)), for: .touchDown)
        } else {
            self.footerView.actionButton.addTarget(self, action:#selector(handleActionTwitter(_:)), for: .touchDown)
            self.footerView.informationBtn.addTarget(self, action: #selector(handleInfoButtonPressed(_:)), for: .touchDown)
        }
        
        titleLabel.textColor = PopmetricsColor.darkGrey
        messageLabel.textColor = PopmetricsColor.darkGrey
        
        if(item.actionHandler == RequiredActionHandler.RequiredActionType.email.rawValue) {
            displayEmailView()
        }
    }
    
    private func displayEmailView() {
        setEmailFieldPlaceholder()
    }
    
    private func setEmailFieldPlaceholder() {
        
        self.containerView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 11).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -10).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 49).isActive = true
        emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.emailTextField.frame.height))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = UITextFieldViewMode.always
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "youremail@email.com", attributes: [NSForegroundColorAttributeName: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1), NSFontAttributeName: UIFont(name: FontBook.semibold, size: 15)!])
        emailTextField.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        emailTextField.layer.cornerRadius = 4
        
        messageHeightConstraint.constant = 70
        messageHeightConstraint.isActive = true
        
        messageTopConstraint.constant = 73
        messageTopConstraint.isActive = true
        
        titleLabel.numberOfLines = 2
        setUpFooterViewForEmail()
    }
    
    private func setUpFooterViewForEmail() {
        footerView.setEmailViewType()
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
            self.containerView.layer.masksToBounds = true
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont(name: FontBook.alfaRegular, size: 20)
        
        titleLabel.textColor = PopmetricsColor.darkGrey
    }
    
    func setMessage(message: String) {
        titleLabel.text = message
        titleLabel.font = UIFont(name: FontBook.semibold, size: 15)
        titleLabel.textColor = PopmetricsColor.darkGrey
        
    }
    
    func setUpTopView() {
        
        toolbarView.isLeftImageHidden = false
        toolbarView.leftImage.image = UIImage(named: "iconAlertMessage")
        toolbarView.leftImage.contentMode = .scaleAspectFit
        toolbarView.backgroundColor = UIColor(red: 255/255, green: 119/255, blue: 106/255, alpha: 1)
        
        let headsUpStyle = Style.default { (style) -> (Void) in
            
            style.font = FontAttribute(FontBook.bold, size: 15)
            style.color = UIColor.white
        }
        
        let requiredAction = Style.default {
            
            $0.font = FontAttribute(FontBook.regular, size: 15)
            $0.color = UIColor.white
        }
        
        let headerTitle = "Heads Up: ".set(style: headsUpStyle) + "Required Action".set(style: requiredAction)
        toolbarView.title.attributedText = headerTitle
    }
    
    func handleActionNotifications(_ sender: SimpleButton) {
        openUrl(string: Config.howToTurnNotificationLink)
    }
    
    @objc func handleInfoButtonPressed(_ sender: SimpleButton) {
        infoDelegate?.sendInfo(sender)
    }
    
    @objc func handleActionTwitter(_ sender: SimpleButton) {
        actionHandler?.handleRequiredAction(sender, item: self.item!)
    }
    
    
    @objc func handleInfoButtonPressed1() {
    }
    
    func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.topAnchor.constraint(equalTo: toolbarView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        shadowLayer.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 12
    }
    
}

extension RequiredAction {
    func openUrl(string: String) {
        let url = URL(string: string)
        let safari = SFSafariViewController(url: url!)
        self.parentViewController?.present(safari, animated: true)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.parentViewController?.dismiss(animated: true)
    }
}

enum BannerType {
    case success
    case failed
}


