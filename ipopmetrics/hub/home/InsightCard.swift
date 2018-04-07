//
//  RecommendedCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@objc protocol RecommendeCellDelegate: class {
    @objc func recommendedCellDidTapAction(_ feedCard: FeedCard)
    @objc func cellDidTapMoreInfo(_ feedCard: FeedCard)
}

class InsightCard: BaseHubCard {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.cardImageView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        updateTitleFont()
    }
    
    private func updateTitleFont() {
        if Utils.isPlusSize {
            titleLabel.font = UIFont(name: FontBook.extraBold, size: 30)
        }
    }
    
    override func updateHubCell( card: HubCard, hubController: HubControllerProtocol, options:[String:Any] = [:]) {
        super.updateHubCell(card:card, hubController:hubController, options:options)
        changeTitle(card.headerTitle)
        messageLabel?.text = card.message
        toolbarView.backgroundColor = UIColor.white
        
        if let imageUrl = card.imageUri {
            if imageUrl.isValidUrl() {
                cardImageView.af_setImage(withURL: URL(string: imageUrl)!)
            }
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
