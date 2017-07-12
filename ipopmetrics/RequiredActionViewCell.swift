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
 
      
      self.backgroundColor = UIColor.cloudsColor()
      setCornerRadious()
      infoButton.setTitle("i", for: .normal)

    }
  
    func configureActionType() {
      
      switch item?.actionHandler {
      case ActionHandlerType.connectFacebook.rawValue?:
          self.actionButton.setTitle("Allow notifications", for: .normal)
          self.socialMediaNameLabel.isHidden = true
          self.socialMediaLogo.isHidden = true
      case ActionHandlerType.connectGoogleAnalytics.rawValue?:
          self.actionButton.setTitle("Connect Analytics", for: .normal)
          self.socialMediaNameLabel.text = "Google Analytics"
          self.socialMediaLogo.image = #imageLiteral(resourceName: "icon_google")
      case ActionHandlerType.connectTwitter.rawValue?:
          self.actionButton.setTitle("Connect Twitter", for: .normal)
          self.socialMediaNameLabel.text = "Twitter"
          let colorTwitter = UIColor(red: 65/255.0, green: 155/255.0, blue: 249/255.0, alpha: 1.0)
          self.socialMediaLogo.image = UIImage.fontAwesomeIcon(code: "fa-twitter", textColor: colorTwitter, size: CGSize(width: 64, height: 48))
      case ActionHandlerType.connectLinkedin.rawValue?:
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
