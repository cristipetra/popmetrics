//
//  ToDoCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 18/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ToDoCardCell: UITableViewCell {
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var foregroundImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var circleView: UIView!
    
    lazy var approvedView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PopmetricsColor.darkGrey.withAlphaComponent(0.8)
        return view
        
    }()
    
    lazy var approvedButton : TwoImagesButton = {
        
        let button = TwoImagesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 54/255, green: 172/255, blue: 130/255, alpha: 1)
        button.layer.borderWidth = 0
        return button
        
    }()
    
    var todoItem: TodoItem!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        //setUpApprovedView()
        setupCorners()
    }
    
    func setupCorners() {
        DispatchQueue.main.async {
            self.circleView.roundCorners(corners: .allCorners, radius: self.circleView.frame.size.width/2)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setUpApprovedView(approved: Bool) {
        if( approved == false) {
            return
        }
        self.insertSubview(approvedView, at: 1)
        approvedView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        approvedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        approvedView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        approvedView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        approvedView.addSubview(approvedButton)
        approvedButton.centerXAnchor.constraint(equalTo: approvedView.centerXAnchor).isActive = true
        approvedButton.centerYAnchor.constraint(equalTo: approvedView.centerYAnchor).isActive = true
        approvedButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        approvedButton.heightAnchor.constraint(equalToConstant: 39).isActive = true
        
        if approved {
            approvedButton.imageButtonType = .approved
        } else {
            approvedButton.imageButtonType = .unapproved
        }
        
        approvedButton.rightImageView.image = nil
        approvedButton.layer.cornerRadius = 6
    }
    
    func configure(item: TodoItem) {
        todoItem = item
        setUpApprovedView(approved: item.isApproved)
    }
    
    func removeApprovedView() {
        approvedView.removeFromSuperview()
    }
    
    func sideShadow(view: UIView) {
        view.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        let shadowRect : CGRect = view.bounds.insetBy(dx: 0, dy: 0)
        view.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
    
}
