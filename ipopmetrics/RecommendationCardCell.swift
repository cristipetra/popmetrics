//
//  RecommendationCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 13/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class RecommendationCardCell: UITableViewCell {
  
  @IBOutlet weak var titleImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var hashtagLabel: UILabel!
  @IBOutlet weak var bottomImage: UIImageView!
  @IBOutlet weak var connectionView: UIView!
  @IBOutlet weak var shadowLayer: UIView!
  
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var secondContanerView: UIView!
    
    var item: FeedItem?
    var actionHandler: CardActionHandler?
    var indexPath: IndexPath?
  
  
    func configure(_ item: FeedItem, handler: CardActionHandler) {
        self.titleLabel.text = item.headerTitle
        self.messageLabel.text = item.message
        
        if let iconImage = item.headerIconUri {
            self.titleImage.image = UIImage(named: iconImage)
        }
        
        if let imageUri = item.imageUri {
            self.bottomImage.image = UIImage(named: imageUri)
        }
        
        adjustLabelLineSpaceing()
    }
  
  override func awakeFromNib() {
    super.awakeFromNib()
     
    self.backgroundColor = UIColor.feedBackgroundColor()
    adjustLabelLineSpaceing()
    headerView.backgroundColor = UIColor.turquoiseColor()
    setCornerRadious()
    addShadow()
    
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
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
  
  func setCornerRadious() {
    secondContanerView.layer.cornerRadius = 14
    secondContanerView.layer.masksToBounds = true
  }
  
  func addShadow() {
    self.addShadowToView(shadowLayer, radius: 4, opacity: 0.4)
    shadowLayer.layer.cornerRadius = 14
    shadowLayer.layer.masksToBounds = false
  }
    
}

