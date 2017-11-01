//
//  CalendarCardSimpleViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 12/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class CalendarCardSimpleViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var foregroundImage: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var messageLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var textStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelPostButton: UIButton!
    @IBOutlet weak var textStackViewTopConstraint: NSLayoutConstraint!
    
    // Extend view
    lazy var statusCardTypeView: StatusCardTypeView = {
        let view = StatusCardTypeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // End extend view
    
    
    internal var calendarItem: CalendarSocialPost!
    
    weak var cancelCardDelegate : CalendarCardActionHandler?
    weak var actionSociaDelegate: ActionSocialPostProtocol?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        
        self.isUserInteractionEnabled = true
        
        setupCorners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCorners() {
        DispatchQueue.main.async {
            self.circleView.roundCorners(corners: .allCorners, radius: self.circleView.frame.size.width/2)
        }
    }
    
    func configure(_ item: CalendarSocialPost) {
        calendarItem = item;
        
        let formatedDate = self.formatDate((item.scheduledDate)!)
        self.statusText.text = item.socialTextTime
        self.timeLbl.text = formatedDate
        
        if item.text != "" {
            self.messageLbl.text = item.text
        }
        
        DispatchQueue.main.async {
            self.setMessageLabel()
        }
        
        //self.backgroundImage.image = UIImage(named: item.articleImage!)
        //self.foregroundImage.image = UIImage(named: item.socialIcon)
        
        statusCardTypeView.typeStatusView = .cancel
        
        statusCardTypeView.infoBtn.addTarget(self, action: #selector(cancelPostHandler), for: .touchUpInside)
        
        changeColor()
    }
    
    private func setMessageLabel() {
        messageLbl.adjustLabelSpacing(spacing: 0, lineHeight: 18, letterSpacing: 0.3)
        if messageLbl.frame.width < 250 {
            if messageLbl.frame.width < 200 {
                messageLblTopConstraint.constant = 5
                messageLblHeightConstraint.constant = 90
                textStackViewTopConstraint.constant = 12
                messageLbl.adjustLabelSpacing(spacing: 0, lineHeight: 15, letterSpacing: 0.2)
                messageLbl.font = messageLbl.font.withSize(12)
                textStackView.axis = .vertical
                textStackView.alignment = .trailing
                textStackViewHeightConstraint.constant = 28
            } else {
                messageLblHeightConstraint.constant = 90
                messageLblTopConstraint.constant = 3
                textStackViewTopConstraint.constant = 22
            }
        }
    }
    
    internal func addStatusCardTypeView() {
        if( statusCardTypeView.isDescendant(of: self)) {
            return
        }
        
        self.addSubview(statusCardTypeView)
        statusCardTypeView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        statusCardTypeView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        statusCardTypeView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        statusCardTypeView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        statusCardTypeView.layer.cornerRadius = 6
    }
    
    
    internal func changeColor() {
        statusText.textColor = calendarItem.socialTextStringColor
    }
    
    internal func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd @ h:mma"
        dateFormatter.amSymbol = "a.m."
        dateFormatter.pmSymbol = "p.m."
        
        return dateFormatter.string(from: date)
    }
    
    @objc internal func cancelPostHandler() {
        actionSociaDelegate?.cancelPostFromSocial!(post: calendarItem, indexPath: indexPath)
        //cancelCardDelegate?.handleCardAction("cancel_one", calendarCard: self.calendarItem.calendarCard!, params: ["social_post": self.calendarItem])
    }
    
}
