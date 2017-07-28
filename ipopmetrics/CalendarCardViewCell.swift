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
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var timeLbl: ActiveLabel!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var topStackViewVIew: UIView!
    
    internal var calendarItem: CalendarItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        topStackViewVIew.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ item: CalendarItem) {
        calendarItem = item;
        self.titleLbl.text = item.articleTitle
        let formatedDate = self.formatDate((item.statusDate)!)
        self.timeLbl.text = item.socialTextString + " " + formatedDate
        
        self.messageLbl.text = item.articleText
        
        self.backgroundImage.image = UIImage(named: item.articleImage!)
        self.foregroundImage.image = UIImage(named: item.socialIcon)
        
        changeColor()
    }
    
    func changeColor() {
        let customColor = ActiveType.custom(pattern: "\\\(calendarItem.socialTextString)\\b")
        //let customColor1 = ActiveType.custom(pattern: "\\sScheduled\\b")
        
        timeLbl.enabledTypes.append(customColor)
        
        timeLbl.customize { (article) in
            article.customColor[customColor] = calendarItem.socialTextStringColor
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd @ h:mma"
        dateFormatter.amSymbol = "a.m."
        dateFormatter.pmSymbol = "p.m."
        
        return dateFormatter.string(from: date)
    }
    
}
