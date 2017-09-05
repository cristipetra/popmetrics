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
    @IBOutlet weak var stat1ValueLabel: UILabel!
    @IBOutlet weak var stat1MetricLabel: UILabel!
    @IBOutlet weak var stat1ChangeLabel: UILabel!

    @IBOutlet weak var stat2ValueLabel: UILabel!
    @IBOutlet weak var stat2MetricLabel: UILabel!
    @IBOutlet weak var stat2ChangeLabel: UILabel!

    @IBOutlet weak var stat3ValueLabel: UILabel!
    @IBOutlet weak var stat3MetricLabel: UILabel!
    @IBOutlet weak var stat3ChangeLabel: UILabel!
    
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    
    var item: FeedCard?
    var actionHandler: CardActionHandler?
    
    func configure(_ item: FeedCard, handler: CardActionHandler) {
        self.headerLabel.text = item.headerTitle
        
//        self.stat1ValueLabel.text = String(describing:item.statsSummaryItems[0].value)
//        self.stat1MetricLabel.text = item.statsSummaryItems[0].label
//        self.stat1ChangeLabel.text = String(describing:item.statsSummaryItems[0].change)+"%"
//        
//        self.stat2ValueLabel.text = String(describing:item.statsSummaryItems[1].value)
//        self.stat2MetricLabel.text = item.statsSummaryItems[1].label
//        self.stat2ChangeLabel.text = String(describing:item.statsSummaryItems[1].change)+"%"
//        
//        self.stat3ValueLabel.text = String(describing:item.statsSummaryItems[2].value)
//        self.stat3MetricLabel.text = item.statsSummaryItems[2].label
//        self.stat3ChangeLabel.text = String(describing:item.statsSummaryItems[2].change)+"%"
        
        self.item = item
        self.actionHandler = handler
        
        self.actionButton.setTitle(item.actionLabel, for: .normal)
        
        
        self.actionButton.addTarget(self, action:#selector(handleAction(_:)), for: .touchDown)
        
    }
    
    @objc func handleAction(_ sender: SimpleButton) {
        actionHandler?.handleRequiredAction(sender, item: self.item!)
    }
    
}
