//
//  ActionHistoryViewCell.swift
//  ipopmetrics
//
//  Created by Rares Pop on 17/05/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit


class ActionHistoryViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerImageIcon: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bottomImage: UIImageView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    func configure(_ item: FeedItem) {
        self.headerLabel.text = item.headerTitle
//        self.messageLabel.text = item.message
    }
    
}
