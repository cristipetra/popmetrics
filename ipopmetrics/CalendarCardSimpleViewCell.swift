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
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var topToolbar: UIView!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // Extend view
    lazy var statusCardTypeView: StatusCardTypeView = {
        let view = StatusCardTypeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // End extend view
    
    
    internal var calendarItem: CalendarSocialPost!
    
    weak var maximizeDelegate: ChangeCellProtocol?
    weak var cancelCardDelegate : CalendarCardActionHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        
        let tapCard = UITapGestureRecognizer(target: self, action: #selector(handlerClickCard))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapCard)
        
        addStatusCardTypeView()
        setupCorners()
    }
    
    func handlerClickCard() {
        maximizeDelegate?.maximizeCell()
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
        self.titleLbl.text = item.title
        let formatedDate = self.formatDate((item.scheduledDate)!)
        self.statusText.text = item.socialTextTime
        self.timeLbl.text = formatedDate
        
        self.messageLbl.text = item.text
        
        //self.backgroundImage.image = UIImage(named: item.articleImage!)
        //self.foregroundImage.image = UIImage(named: item.socialIcon)
        
        statusCardTypeView.typeStatusView = .cancel
        
        statusCardTypeView.infoBtn.addTarget(self, action: #selector(cancelPostHandler), for: .touchUpInside)
        
        changeColor()
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
    
    internal func cancelPostHandler() {        
        cancelCardDelegate?.handleCardAction("cancel_one", calendarCard: self.calendarItem.calendarCard!, params: ["social_post": self.calendarItem])
    }
    
}
