//
//  ToDoCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//


import UIKit

class ToDoCell: UITableViewCell {
    
    @IBOutlet weak var toDoCountViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var toDoCountView: ToDoCountView!
    @IBOutlet weak var todoHeaderView: ToolbarViewCell!
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var footerView: FooterView!
    
    
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.feedBackgroundColor()
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.feedBackgroundColor()
        setCornerRadius()
        setBarContent()
        
        setUpShadowLayer()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setHeaderTitle(title: String) {   
        todoHeaderView.title.text = title
        todoHeaderView.title.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        
    }
    
    func setBarContent() {
        todoHeaderView.isLeftImageHidden = false
        todoHeaderView.leftImage.contentMode = .scaleAspectFit
        todoHeaderView.leftImage.image = UIImage(named: "iconTodoSnapshotCard")
        
        todoHeaderView.backgroundColor = PopmetricsColor.yellowBGColor
    }
    
    func setCornerRadius() {
        wrapperView.layer.cornerRadius = 14
        wrapperView.layer.masksToBounds = true
    }
    
    private func setShadows(view: AnyObject) {
        view.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.22).cgColor
        view.layer.shadowOpacity = 1.0;
        view.layer.shadowRadius = 2.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.topAnchor.constraint(equalTo: wrapperView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
        shadowLayer.leftAnchor.constraint(equalTo: wrapperView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: wrapperView.rightAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 12
    }
    
}

