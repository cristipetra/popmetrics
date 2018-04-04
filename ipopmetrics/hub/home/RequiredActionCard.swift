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
import EZAlertController

class RequiredActionCard: UITableViewCell, HubCell {
    
    
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var connectionLineView: UIView!
    
    
    @IBOutlet weak var constraintHeightConnectionLine: NSLayoutConstraint!
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var primaryActionButton: UIButton!
    @IBOutlet weak var secondaryActionButton: UIButton!
    
    
    var card: HubCard?
    var hubController: HubControllerProtocol?
    var indexPath: IndexPath?
    var infoDelegate: InfoButtonDelegate?
    
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    // End extend view
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        //self.containerView.backgroundColor = PopmetricsColor.salmondColor
        setupToolbarView()
        setupCorners()
        setUpShadowLayer()
        
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateHubCell( card: HubCard, hubController: HubControllerProtocol) {
        self.card = card
        self.hubController = hubController
        if card.isTest {
            toolbarView.setUpCircleBackground(topColor: UIColor(named:"blue_bottle")!, bottomColor: UIColor(named:"blue_bottle")!)
        }
        
        if let imageUrl = card.imageUri {
            if imageUrl.isValidUrl() {
                cardImageView.af_setImage(withURL: URL(string: imageUrl)!)
            }
        }
        changeTitle(card.headerTitle)
        messageLabel?.text = card.message
        
        if card.primaryAction != "" {
            self.primaryActionButton.isHidden = false
            self.primaryActionButton.titleLabel?.text = card.primaryActionLabel
        }
        else {
            self.primaryActionButton.isHidden = true
        }
        
        if card.secondaryAction != "" {
            self.secondaryActionButton.isHidden = false
            self.secondaryActionButton.titleLabel?.text = card.secondaryActionLabel
        }
        else {
            self.secondaryActionButton.isHidden = true
        }
        
    }
    
    @IBAction func primaryActionHandler(_ sender: Any) {
        self.hubController?.handleCardAction(card:self.card!, actionType:"primary")
        
    }
    
    @IBAction func secondaryActionHandler(_ sender: Any) {
        self.hubController?.handleCardAction(card:self.card!, actionType:"secondary")
        
    }
    
    
    internal func changeVisibilityConnectionLine(isHidden: Bool) {
        if isHidden {
            constraintHeightConnectionLine.constant = 0
        } else {
            constraintHeightConnectionLine.constant = 37
        }
    }
    
    func changeTitle(_ title: String?) {
        let tooltipImage = UIImage(named: "iconTooltip")
        let attachment = NSTextAttachment()
        attachment.image = tooltipImage
        attachment.bounds = CGRect(x: 0, y: -5, width: 35, height: 35)
        let attrAttachement = NSAttributedString(attachment: attachment)
        if let headerTitle = title {
            let title = NSMutableAttributedString(string: "\(headerTitle) ")
            //title.append(attrAttachement)
            titleLabel.attributedText = title
        } else {
            titleLabel.text = ""
        }
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
            self.containerView.layer.masksToBounds = true
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        //titleLabel.font = UIFont(name: FontBook.alfaRegular, size: 20)
        
        //titleLabel.textColor = PopmetricsColor.darkGrey
    }
    
    func setMessage(message: String) {
        titleLabel.text = message
        //titleLabel.font = UIFont(name: FontBook.semibold, size: 15)
        //titleLabel.textColor = PopmetricsColor.darkGrey
        
    }
    
    func setupToolbarView() {
        let toolbarController: CardToolbarController  = CardToolbarController()
        toolbarController.setUpTopView(toolbarView: toolbarView)
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
