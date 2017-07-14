//
//  HeaderCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 12/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class HeaderCardCell: UITableViewCell {
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var roundConnectionView: UIView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.cloudsColor()
        containerView.backgroundColor = UIColor.cloudsColor()
        roundConnectionView.layer.cornerRadius = 6
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func changeColor(section: Int) {
        switch section {
        case 0:
            connectionView.backgroundColor = UIColor.carrotColor()
            roundConnectionView.backgroundColor = UIColor.carrotColor()
            break
        case 1:
            connectionView.backgroundColor = UIColor.turquoiseColor()
            roundConnectionView.backgroundColor = UIColor.turquoiseColor()
            break
        default:
            
            break
        }
        
    }

  
}
