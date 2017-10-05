//
//  TrafficCardViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TrafficCardViewCell: UITableViewCell {
    
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    @IBOutlet weak var statisticsCountView: StatisticsCountView!
    @IBOutlet weak var connectionLine: UIView!
    @IBOutlet weak var statisticsCountViewHeightCounstraint: NSLayoutConstraint!
    @IBOutlet weak var contentWrapperView: UIView!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var wrapperView: UIView!
    
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setCornerRadius()
        setUpShadowLayer()
        
        self.footerView.approveLbl.textColor = UIColor.white
        self.footerView.actionButton.leftHandImage = UIImage(named: "iconTrafficReport")
        self.toolbarView.title.text = "Traffic stats: hutcheson.io"
        self.toolbarView.leftImage.image = UIImage(named: "iconHeaderTrafficStats")
        self.toolbarView.isLeftImageHidden = false
        self.toolbarView.leftImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.footerView.approveLbl.text = "View Traffic Report"
        self.footerView.setIsTrafficUnconnected()
        self.footerView.actionButton.imageButtonType = .traffic
        DispatchQueue.main.async {
            self.toolbarView.setupGradient()
            self.footerView.setupGradient()
        }
    }
    
    func setCornerRadius() {
        self.contentWrapperView.layer.cornerRadius = 12
        self.contentWrapperView.layer.masksToBounds = true
    }
    
    func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.topAnchor.constraint(equalTo: toolbarView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: contentWrapperView.bottomAnchor).isActive = true
        shadowLayer.leftAnchor.constraint(equalTo: contentWrapperView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: contentWrapperView.rightAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 12
    }
}
