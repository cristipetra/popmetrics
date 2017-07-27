//
//  CalendarCardMaximizedViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 27/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class CalendarCardMaximizedViewCell: UITableViewCell {
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var connectionStackView: UIStackView!
    @IBOutlet weak var topContainerVIew: UIView!
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var connectionContainerView: UIView!
    
    var notLastCell = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.connectionContainerView.backgroundColor = UIColor.feedBackgroundColor()

        
        setUpCorners()
    }
    
    func setUpCorners() {
        topHeaderView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        print("notLastCell status : \(notLastCell)")
        if notLastCell == true {
            topContainerVIew.layer.cornerRadius = 22
            imageContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        } else {
            topContainerVIew.roundCorners(corners: [.topLeft, .topRight], radius: 10)
            imageContainerView.layer.cornerRadius = 0
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
