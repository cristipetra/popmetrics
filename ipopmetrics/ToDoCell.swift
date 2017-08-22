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
    @IBOutlet weak var goToButton: TwoImagesButton!
    @IBOutlet weak var toDoCountView: ToDoCountView!
    @IBOutlet weak var wrapperView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.goToButton.backgroundColor = PopmetricsColor.yellowBGColor
        self.backgroundColor = UIColor.feedBackgroundColor()
        setCornerRadius()
        setShadows(view: goToButton)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCornerRadius() {
        
        wrapperView.layer.cornerRadius = 14
        wrapperView.layer.masksToBounds = true
        self.goToButton.layer.borderWidth = 2.0
        self.goToButton.layer.borderColor = UIColor.black.cgColor
        self.goToButton.layer.cornerRadius = self.goToButton.frame.height / 2
    }
    
    private func setShadows(view: AnyObject) {
        view.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.22).cgColor
        view.layer.shadowOpacity = 1.0;
        view.layer.shadowRadius = 2.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
}

