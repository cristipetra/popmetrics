//
//  HeaderCardViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class HeaderCardViewCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var roundConnectionView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    
    lazy var headerShadow : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.feedBackgroundColor()
        containerView.backgroundColor = UIColor.feedBackgroundColor()
        
        setUpCornerRadious()
        
        connectionView.isHidden = true
        roundConnectionView.isHidden = true
        //titleLeftAnchor.constant = 19
    }
    
    func setUpCornerRadious() {
        roundConnectionView.layer.cornerRadius = 6
    }
    
    func changeColor(color: UIColor) {
        toolbarView.backgroundColor = color
        toolbarView.changeColorCircle(color: color)
        roundConnectionView.backgroundColor = color
        connectionView.backgroundColor = color
    }
    
    //  func changeTitle(title: String) {
    //    toolbarView.title.text = title
    //    titleLbl.text = title
    //  }
    
    func changeTitleSection(title: String) {
        titleLbl.text = title
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
