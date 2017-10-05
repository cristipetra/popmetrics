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
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var topToolbar: UIView!
    @IBOutlet weak var statusText: UILabel!
    
    internal var calendarItem: CalendarSocialPost!
    
    weak var maximizeDelegate: ChangeCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        
        let tapCard = UITapGestureRecognizer(target: self, action: #selector(handlerClickCard))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapCard)
        
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
            self.topToolbar.roundCorners(corners: [.topRight, .topLeft] , radius: 12)
            self.circleView.roundCorners(corners: .allCorners, radius: self.circleView.frame.size.width/2)
        }
    }
    
    func configure(_ item: CalendarSocialPost) {
        calendarItem = item;
        self.titleLbl.text = item.title
        let formatedDate = self.formatDate((item.scheduledDate)!)
        self.statusText.text = item.socialTextString
        self.timeLbl.text = formatedDate
        
        self.messageLbl.text = item.text
        
        self.backgroundImage.image = UIImage(named: item.image!)
        self.foregroundImage.image = UIImage(named: item.socialIcon)
        
        
        changeColor()
    }
    
    func changeColor() {
        statusText.textColor = calendarItem.socialTextStringColor
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd @ h:mma"
        dateFormatter.amSymbol = "a.m."
        dateFormatter.pmSymbol = "p.m."
        
        return dateFormatter.string(from: date)
    }
    
}
