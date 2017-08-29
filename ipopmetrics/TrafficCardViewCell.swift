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
    @IBOutlet weak var uniqueVisitsView: UIView!
    @IBOutlet weak var connectionLine: UIView!
    @IBOutlet weak var contentWrapperView: UIView!
    @IBOutlet weak var overallVisitsView: UIView!
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
        self.footerView.actionButton.imageButtonType = .traffic
        DispatchQueue.main.async {
            self.setDivider(view: self.overallVisitsView)
            self.setDivider(view: self.uniqueVisitsView)
            self.toolbarView.addGradient()
            self.footerView.addGradient()
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
    
    func setDivider(view : AnyObject) {
        let divider  = UIView(frame: CGRect(x: 0, y: view.frame.height - 0.5, width: view.frame.width, height: CGFloat(0.5)))
        divider.backgroundColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        view.addSubview(divider)
    }
    
}
