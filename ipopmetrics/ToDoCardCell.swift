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
    
    lazy var approvedView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return view
        
    }()
    
    lazy var approvedButton : TwoImagesButton = {
        
        let button = TwoImagesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 54/255, green: 172/255, blue: 130/255, alpha: 1)
        return button
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        //setUpApprovedView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setUpApprovedView(approved : Bool) {
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
            approvedButton.imageButtonType = .rescheduled
        }
        
        approvedButton.rightImageView.image = nil
        approvedButton.layer.cornerRadius = 6
        
    }
    
    func removeApprovedView() {
        approvedView.removeFromSuperview()
        
    }
    
}
