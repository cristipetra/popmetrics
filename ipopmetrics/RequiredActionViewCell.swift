//
//  RequiredActionCard.swift
//  ipopmetrics
//
//  Created by Rares Pop on 16/05/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class RequiredActionViewCell: UITableViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerImageIcon: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bottomImage: UIImageView!
  
    @IBOutlet weak var actionButton: SimpleButton!
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var socialMediaLogo: UIImageView!
    @IBOutlet weak var socialMediaNameLabel: UILabel!
    @IBOutlet weak var connectionView: UIView!
  
    @IBOutlet weak var infoButton: SimpleButton!
    @IBOutlet weak var containerView: UIView!
  
  
    var item: FeedItem?
    var actionHandler: CardActionHandler?
    var indexPath: IndexPath?
 
    func configure(_ item: FeedItem, handler: CardActionHandler) {
        self.item = item
        self.actionHandler = handler
        
        self.actionButton.setTitle(item.actionLabel, for: .normal)
       
        self.actionButton.addTarget(self, action:#selector(handleAction(_:)), for: .touchDown)
      
        self.configureActionType();
 
      
        self.backgroundColor = UIColor.feedBackgroundColor()
        setCornerRadious()
        infoButton.setTitle("i", for: .normal)
      
        self.titleLabel.text  = item.headerTitle
        messageLabel.text = item.message
      adjustLabelLineSpaceing()
  }
  
  func adjustLabelLineSpaceing() {
    
    if let titleText = titleLabel.text {
        let attributedString = NSMutableAttributedString(string: titleText)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.maximumLineHeight = 26
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: (titleText.characters.count)))
        titleLabel.attributedText = attributedString
    }
    
    if let messageText = messageLabel.text {
        let attributedString = NSMutableAttributedString(string: messageText)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        style.maximumLineHeight = 26
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: (messageText.characters.count)))
        messageLabel.attributedText = attributedString
    }
    
  }

    func configureActionType() {
      
      switch item?.actionHandler {
      case ActionHandlerType.connectFacebook.rawValue?:
          self.actionButton.setTitle("Allow notifications", for: .normal)
          self.socialMediaNameLabel.isHidden = true
          self.bottomImage.image = UIImage(named: "image_card_notifications")
          self.socialMediaLogo.isHidden = true
      case ActionHandlerType.connectGoogleAnalytics.rawValue?:
          self.actionButton.setTitle("Connect Analytics", for: .normal)
          self.bottomImage.image = UIImage(named: "image_card_google")
          self.socialMediaNameLabel.text = "Google Analytics"
          self.socialMediaLogo.image = #imageLiteral(resourceName: "icon_google")
      case ActionHandlerType.connectTwitter.rawValue?:
          self.actionButton.setTitle("Connect Twitter", for: .normal)
          self.bottomImage.image = UIImage(named: "image_card_twitter")
          self.socialMediaNameLabel.text = "Twitter"
            self.socialMediaLogo.image = #imageLiteral(resourceName: "icon_twitter")
      case ActionHandlerType.connectLinkedin.rawValue?:
          self.actionButton.setTitle("Connect Linkedin", for: .normal)
          self.socialMediaNameLabel.text = "Linkedin"
          break;
      default:
        break;
      }
    }
    
    @objc func handleAction(_ sender: SimpleButton) {
        self.actionButton.isLoading = true        
        actionHandler?.handleRequiredAction(sender, item: self.item!)
    }
  
    func setCornerRadious() {
        containerView.layer.cornerRadius = 14
        containerView.layer.masksToBounds = true
    
        infoButton.layer.cornerRadius = infoButton.layer.frame.width / 2
        infoButton.layer.masksToBounds = true
    
        actionButton.layer.cornerRadius = 30
        actionButton.layer.masksToBounds = true
  }
    
}

enum ActionHandlerType: String {
    case connectFacebook = "connect_facebook"
    case connectGoogleAnalytics = "connect_google_analytics"
    case connectTwitter = "connect_twitter"
    case connectLinkedin = "connect_linkedin"
}
