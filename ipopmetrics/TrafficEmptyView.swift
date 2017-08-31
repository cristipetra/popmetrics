//
//  TrafficEmptyView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 31/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TrafficEmptyView: UITableViewCell {
    
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    @IBOutlet weak var wrapperView: UIView!
    
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        messageLabel.adjustLabelSpacing(spacing: 0, lineHeight: 24, letterSpacing: 0.3)
        self.toolbarView.setupGradient()
        self.footerView.setupGradient()
        self.setUpShadowLayer()
        self.setCornerRadius()
        self.footerView.approveLbl.textColor = PopmetricsColor.trafficEmptyApproveLbl
        self.toolbarView.title.text = "Traffic stats: Unconnected"
        self.toolbarView.leftImage.image = UIImage(named: "iconHeaderTrafficStats")
        self.toolbarView.isLeftImageHidden = false
        self.toolbarView.leftImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
        self.footerView.approveLbl.text = "View Traffic Report"
        self.footerView.actionButton.imageButtonType = .traffic
        self.footerView.actionButton.changeToDisabled()
        self.footerView.setIsTrafficUnconnected()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCornerRadius() {
        self.wrapperView.layer.cornerRadius = 12
        self.wrapperView.layer.masksToBounds = true
    }
    
    func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.topAnchor.constraint(equalTo: toolbarView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
        shadowLayer.leftAnchor.constraint(equalTo: wrapperView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: wrapperView.rightAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 12
    }
}
