//
//  CalendarCardSimpleViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 12/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController

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
    
    internal var calendarItem: CalendarItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        
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
    
    func configure(_ item: CalendarItem) {
        calendarItem = item;
        self.titleLbl.text = item.articleTitle
        let formatedDate = self.formatDate((item.statusDate)!)
        self.statusText.text = item.socialTextString
        self.timeLbl.text = self.formatDate(item.statusDate!)
        
        self.messageLbl.text = item.articleText
        
        self.backgroundImage.image = UIImage(named: item.articleImage!)
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
