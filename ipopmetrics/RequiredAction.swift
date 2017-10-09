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
    
    
    var item: FeedCard?
    var actionHandler: CardActionHandler?
    var indexPath: IndexPath?
    var infoDelegate: InfoButtonDelegate?
    
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
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


