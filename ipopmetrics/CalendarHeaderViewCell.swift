//
//  CalendarHeaderViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 26/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

protocol ChangeCellProtocol: class {
    func maximizeCell()
}

class CalendarHeaderViewCell: UITableViewCell {
    
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var roundConnectionView: UIView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.feedBackgroundColor()
        containerView.backgroundColor = UIColor.feedBackgroundColor()
        
        setUpCornerRadious()
    }
    
    func setUpCornerRadious() {
        roundConnectionView.layer.cornerRadius = 6
    }
    
    func changeColor(color: UIColor) {
        //toolbarView.backgroundColor = color
        toolbarView.changeColorCircle(color: color)
        roundConnectionView.backgroundColor = color
        connectionView.backgroundColor = color
    }
    
    func changeTitle(title: String) {
        toolbarView.title.text = title
        sectionTitleLabel.text = title
    }

}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
