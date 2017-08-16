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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var scheduleLbl: UILabel!
    @IBOutlet weak var roundConnectionView: UIView!
    @IBOutlet weak var minimizeContainerView: UIView!
    @IBOutlet weak var minimizeRoundConnectionView: UIView!
    @IBOutlet weak var minimizeScheduleLbl: UILabel!
    @IBOutlet weak var minimizeBtn: UIButton!
    @IBOutlet weak var minimizeLbl: UILabel!
    
    weak var maximizeDelegate: ChangeCellProtocol?
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.feedBackgroundColor()
        containerView.backgroundColor = UIColor.feedBackgroundColor()
        minimizeContainerView.isHidden = true
        setUpCornerRadious()
        minimizeBtn.addTarget(self, action: #selector(expandSchedule), for: .touchUpInside)
        
    }
    
    func setUpCornerRadious() {
        
        roundConnectionView.layer.cornerRadius = roundConnectionView.layer.frame.width / 2
        minimizeRoundConnectionView.layer.cornerRadius = roundConnectionView.layer.frame.width / 2
        
    }
    
    func setupMinimizeView() {
        minimizeContainerView.isHidden = false
        minimizeContainerView.backgroundColor = UIColor.white
        containerView.backgroundColor = UIColor.feedBackgroundColor()
        
    }
    
    func expandSchedule() {
        print("expand")
        maximizeDelegate?.maximizeCell()
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
