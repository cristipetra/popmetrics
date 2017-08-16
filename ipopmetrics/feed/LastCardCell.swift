//
//  LastCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class LastCardCell: UITableViewCell {
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var imageTitle: UIImageView!
    @IBOutlet weak var xbutton: UIButton!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    internal var shadowView: UIView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        setCornerRadiou()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCornerRadiou() {
        
        secondContainerView.layer.cornerRadius = 14
        secondContainerView.layer.masksToBounds = true
        
    }
}
