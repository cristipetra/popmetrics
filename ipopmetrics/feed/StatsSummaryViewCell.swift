//
//  StatsSummaryViewCell.swift
//  ipopmetrics
//
//  Created by Rares Pop on 19/05/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit


class StatsSummaryViewCell: UITableViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerImageIcon: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bottomImage: UIImageView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    var item: FeedItem?
    var actionHandler: CardActionHandler?
    
    func configure(_ item: FeedItem, handler: CardActionHandler) {
        self.headerLabel.text = item.headerTitle
//        self.messageLabel.text = item.message
        self.item = item
        self.actionHandler = handler
        
//        self.actionButton.setTitle(item.actionLabel, for: .normal)
        
        
        self.actionButton.addTarget(self, action:#selector(handleAction(_:)), for: .touchDown)
        
    }
    
    @objc func handleAction(_ sender: UIButton) {
        actionHandler?.handleRequiredAction(sender, item: self.item!)
    }
    
}
