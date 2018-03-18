//
//  RequiredActionLoadMoreView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit


class RequiredActionLoadMoreView: UIView {
    
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet var contentView: UIView!
    
    internal var loadMoreDelegate: RequiredActionLoadMore!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        loadNib()
        updateView()
    }
    
    private func updateView() {
        footerView.actionButton.changeTitle("Show me")
        footerView.leftButton.isHidden = true
        toolbarView.backgroundColor = PopmetricsColor.salmondColor
        toolbarView.changeTitle("")
        
        toolbarView.setUpCircleBackground(topColor: UIColor(red: 255/255, green: 194/255, blue: 188/255, alpha: 1), bottomColor: UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1))
        
        footerView.actionButton.addTarget(self, action: #selector(loadAllRequiredCards), for: .touchUpInside)
        
        changeFontInfoLbl()
    }
    
    private func changeFontInfoLbl() {
        if UIScreen.main.bounds.width <= 320 {
            infoLbl.font = UIFont(name: FontBook.extraBold, size: 29)
        }
    }
    
    @objc
    private func loadAllRequiredCards() {
        loadMoreDelegate.loadMoreRequiredCard()
    }
    
    func loadNib() {
        
        Bundle.main.loadNibNamed("RequiredActionLoadMore", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        //contentView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //contentView.leadingAnchor.constraint(equalTo: self.pa, constant: <#T##CGFloat#>)
        
        DispatchQueue.main.async {
            //self.innerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        }
        //addShadowToView(innerView, radius: 3, opacity: 0.6)
    }
    
    
}

