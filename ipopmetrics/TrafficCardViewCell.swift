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
    @IBOutlet weak var overallVisitsView: UIView!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var wrapperView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setCornerRadius()
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCornerRadius() {
        self.wrapperView.layer.cornerRadius = 14
        self.wrapperView.layer.masksToBounds = true
    }
    
    private func setShadows(view: AnyObject) {
        view.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.22).cgColor
        view.layer.shadowOpacity = 1.0;
        view.layer.shadowRadius = 2.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    func setDivider(view : AnyObject) {
        let divider  = UIView(frame: CGRect(x: 0, y: view.frame.height - 0.5, width: view.frame.width, height: CGFloat(0.5)))
        divider.backgroundColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        view.addSubview(divider)
    }
    
}
