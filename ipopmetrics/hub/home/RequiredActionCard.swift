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

class RequiredActionCard: BaseHubCard {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        //self.containerView.backgroundColor = PopmetricsColor.salmondColor
    }
    
    override func updateHubCell( card: HubCard, hubController: HubControllerProtocol, options:[String:Any] = [String:Any]()) {
        super.updateHubCell(card:card, hubController:hubController, options:options)
        changeTitle(card.headerTitle)
        messageLabel?.text = card.message
        
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
    
}
