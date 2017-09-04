//
//  RecommendedActionViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 04/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class RecommendedActionViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toolBar: ToolbarViewCell!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var middleContainerView: UIView!
    @IBOutlet weak var impactMainProgressView: UIView!
    @IBOutlet weak var costMainProgressView: UIView!
    @IBOutlet weak var effortMainProgressView: UIView!
    @IBOutlet weak var connectionView: UIView!
    
    
    // Extend View
    lazy var impactProgress: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 137/255, alpha: 1)
        return view
    }()
    
    lazy var costProgress: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 137/255, alpha: 1)
        return view
    }()
    
    lazy var effortProgress: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 137/255, alpha: 1)
        return view
    }()
    
    lazy var shadowLayer: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.feedBackgroundColor()
        return view
    }()
    // end extend view
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.containerView.backgroundColor = UIColor.feedBackgroundColor()
        middleContainerView.layer.cornerRadius = 12
        
        setUpFooter()
        setUpToolbar()
        setUpShadowLayer()
        setUpProgressView()
        
        impactProgressValue(value: 30)
        costProgressValue(value: 40)
        effortProgressValue(value: 60)
        
        self.connectionView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        shadowLayer.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 12
        self.containerView.layer.cornerRadius = 12
    }
    
    private func setUpProgressView() {
        impactMainProgressView.addSubview(impactProgress)
        impactProgress.leftAnchor.constraint(equalTo: impactMainProgressView.leftAnchor).isActive = true
        impactProgress.topAnchor.constraint(equalTo: impactMainProgressView.topAnchor).isActive = true
        impactProgress.bottomAnchor.constraint(equalTo: impactMainProgressView.bottomAnchor).isActive = true
        
        costMainProgressView.addSubview(costProgress)
        costProgress.leftAnchor.constraint(equalTo: costMainProgressView.leftAnchor).isActive = true
        costProgress.topAnchor.constraint(equalTo: costMainProgressView.topAnchor).isActive = true
        costProgress.bottomAnchor.constraint(equalTo: costMainProgressView.bottomAnchor).isActive = true
        
        effortMainProgressView.addSubview(effortProgress)
        effortProgress.leftAnchor.constraint(equalTo: effortMainProgressView.leftAnchor).isActive = true
        effortProgress.topAnchor.constraint(equalTo: effortMainProgressView.topAnchor).isActive = true
        effortProgress.bottomAnchor.constraint(equalTo: effortMainProgressView.bottomAnchor).isActive = true
    }
    
    internal func impactProgressValue(value : CGFloat) {
        impactProgress.widthAnchor.constraint(equalToConstant: value).isActive = true
    }
    
    internal func costProgressValue(value : CGFloat) {
        costProgress.widthAnchor.constraint(equalToConstant: value).isActive = true
    }
    
    internal func effortProgressValue(value : CGFloat) {
        effortProgress.widthAnchor.constraint(equalToConstant: value).isActive = true
    }
    
    private func setUpToolbar() {
        toolBar.changeColorCircle(color: UIColor(red: 255/255, green: 189/255, blue: 80/255, alpha: 1))
        toolBar.title.text = "Recommended Action"
    }
    
    private func setUpFooter() {
        footerView.actionButton.leftHandImage = UIImage(named: "iconCtaTaskCard")
        footerView.approveLbl.text = "View Action"
    }
    
}
