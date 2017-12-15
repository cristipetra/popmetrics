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
    @IBOutlet weak var leftConstraintLabel: NSLayoutConstraint!
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    
    lazy var headerShadow : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        toolbarView.title.text = ""
    }
    
    func setUpCornerRadious() {
    
    }
    
    func changeColor(color: UIColor) {
        toolbarView.backgroundColor = color
        toolbarView.changeColorCircle(color: color)
    }
    
    func changeTitleSection(title: String) {
        sectionTitleLabel.text = title.uppercased()
    }
    
    func changeTitleToolbar(title: String) {
        toolbarView.title.text = title
    }
    
    func setUpHeaderShadowView() {
        
        containerView.insertSubview(headerShadow, belowSubview: toolbarView)
        headerShadow.backgroundColor = toolbarView.backgroundColor
        headerShadow.leftAnchor.constraint(equalTo: toolbarView.leftAnchor).isActive = true
        headerShadow.rightAnchor.constraint(equalTo: toolbarView.rightAnchor).isActive = true
        headerShadow.topAnchor.constraint(equalTo:  toolbarView.topAnchor).isActive = true
        headerShadow.bottomAnchor.constraint(equalTo: toolbarView.bottomAnchor).isActive = true
        
        headerShadow.layer.masksToBounds = false
        addShadowToView(headerShadow, radius: 2, opacity: 0.5)
        headerShadow.layer.cornerRadius = 12
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
