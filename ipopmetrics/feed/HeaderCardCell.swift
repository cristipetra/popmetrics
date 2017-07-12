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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.backgroundColor = UIColor(red: 240, green: 240, blue: 240, alpha: 1)
    roundConnectionView.layer.cornerRadius = 6
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
}
