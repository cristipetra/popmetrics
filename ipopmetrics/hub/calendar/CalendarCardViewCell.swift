//
//  CalendarCardViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 25/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ActiveLabel

class CalendarCardViewCell: UITableViewCell {
    
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
    
    @IBOutlet weak var constraintHeightContainerLine: NSLayoutConstraint!
    @IBOutlet weak var footerView: TableFooterView!
    @IBOutlet weak var constraintHeightFooter: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightToolbar: NSLayoutConstraint!
    internal var calendarItem: CalendarSocialPost!
    
    weak var cancelCardDelegate : CalendarCardActionHandler?
    weak var actionSociaDelegate: ActionSocialPostProtocol?
    internal var indexPath: IndexPath!
    
    private var heightToolbar: Int = 29
    
    // Extend view
    lazy var statusCardTypeView: StatusCardTypeView = {
        let view = StatusCardTypeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // End extend view
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        
        self.backgroundColor = .clear
        
        self.setMessageLabel()
        
        self.constraintHeightFooter.constant = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setPositions(_ indexPath: IndexPath, itemsToLoad: Int, countPosts: Int) {
        self.indexPath = indexPath
        
        if indexPath.row != 0 {
            constraintHeightToolbar.constant = 0
        } else {
            constraintHeightToolbar.constant = 29
        }

        var posFooter = itemsToLoad >= countPosts ? countPosts : itemsToLoad
        
        print(posFooter)
        
        if (indexPath.row != posFooter - 1) {
            constraintHeightFooter.constant = 0
            constraintHeightContainerLine.constant = 0
        } else {
            constraintHeightFooter.constant = 80
            constraintHeightContainerLine.constant = 20
        }
        
        constraintHeightFooter.constant = 0

        self.layoutIfNeeded()
    }
    
    func configure(_ item: CalendarSocialPost) {
        
        calendarItem = item;
        
        let formatedDate = self.formatDate((item.scheduledDate)!)
        
        self.timeLbl.text = formatedDate
        self.statusText.text = item.socialTextTime
        
        if item.text != "" {
            self.messageLbl.text = item.text
        }
        
        if let imageUrl = item.image {
            if imageUrl.isValidUrl() {
                self.backgroundImage.af_setImage(withURL: URL(string: imageUrl)!)
            }
        }
        
        statusCardTypeView.typeStatusView = .cancel
        
        cancelPostButton.addTarget(self, action: #selector(cancelPostHandler), for: .touchUpInside)
        
        changeColor()
        
        if item.section == CalendarSectionType.completed.rawValue {
            cancelPostButton.isHidden = true
        } else {
            cancelPostButton.isHidden = false
        }
        
        footerView.changeFeedType(feedType: FeedType.calendar)
        //footerView.buttonActionHandler = self
        footerView.xButton.isHidden = true
        //updateStateLoadMore(footerView, section: section)
     
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
    
    @objc internal func cancelPostHandler() {
        actionSociaDelegate?.cancelPostFromSocial!(post: calendarItem, indexPath: indexPath)
    }
    
}
