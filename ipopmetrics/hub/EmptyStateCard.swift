//
//  RecommendedCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class EmptyStateCard: BaseHubCard {
    
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.backgroundImageView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.toolbarView.backgroundColor = UIColor.white
    }
    
    override func updateHubCell(card: HubCard, hubController: HubControllerProtocol, options:[String:Any] = [:]) {
        super.updateHubCell(card:card, hubController:hubController, options:options)
        titleLabel.text = card.headerTitle
        messageLabel?.text = card.message
        
        if let imageUrl = card.imageUri {
            if imageUrl.isValidUrl() {
                backgroundImageView.af_setImage(withURL: URL(string: imageUrl)!)
            }
        }
        
    }
    
    internal func configure(todoCard: TodoCard) {
        
        titleLabel.text = todoCard.headerTitle
        messageLabel.text = todoCard.message!
        
        if let imageUrl = todoCard.imageUri {
            if let url = URL(string: imageUrl) {
              backgroundImageView.af_setImage(withURL: url)
            }
        }
        
    }
    
    internal func configure(calendarCard: CalendarCard) {
        titleLabel.text = calendarCard.headerTitle
        messageLabel.text = calendarCard.message!
        
        if let imageUrl = calendarCard.imageUri {
            if let url = URL(string: imageUrl) {
                backgroundImageView.af_setImage(withURL: url)
            }
        }
        
    }
    
    internal func configure(statsCard: StatsCard) {
        titleLabel.text = statsCard.headerTitle
        messageLabel.text = statsCard.message!
        
        if let imageUrl = statsCard.imageUri {
            if let url = URL(string: imageUrl) {
                backgroundImageView.af_setImage(withURL: url)
            }
        }
        
    }
    
}
