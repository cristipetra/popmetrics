//
//  CalendarCardMaximizedViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 27/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ActiveLabel

class CalendarCardMaximizedViewCell: UITableViewCell {
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var connectionStackView: UIStackView!
    @IBOutlet weak var topContainerVIew: UIView!
    @IBOutlet weak var topHeaderView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var connectionContainerView: UIView!
    
    @IBOutlet weak var messageLbl: ActiveLabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleDate: ActiveLabel!
    @IBOutlet weak var socialNetworkLbl: UILabel!
    @IBOutlet weak var socialPostImage: UIImageView!
    @IBOutlet weak var actionBtn: RoundButton!
    
    private var calendarItem: CalendarItem!
    
    
    var notLastCell = true
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.connectionContainerView.backgroundColor = UIColor.feedBackgroundColor()

        
        setUpCorners()
    }
    
    func configure(_ item: CalendarItem) {
        self.calendarItem = item;
        self.titleLbl.text = item.articleTitle
        var formatedDate = self.formatDate((item.statusDate)!)
        self.articleDate.text = item.socialTextString + " " + formatedDate
        self.messageLbl.text = item.articleText
        self.socialNetworkLbl.text = item.socialPost + ": " + item.articleCategory!
        self.socialPostImage.image = UIImage(named: item.socialIcon)
        self.articleImage.image = UIImage(named: item.articleImage!)
        updateBtnView()
        
        changeColor()
    }
    
    func changeColor() {
        let customColor = ActiveType.custom(pattern: "\\\(calendarItem.socialTextString)\\b")
    
        articleDate.enabledTypes.append(customColor)
        
        articleDate.customize { (article) in
            article.customColor[customColor] = calendarItem.socialTextStringColor
        }
        
        let colorTextUrl = ActiveType.custom(pattern: "\\s\(calendarItem.articleUrl)\\b")
        let colorTextUrl1 = ActiveType.custom(pattern: "\\sAlch.my/AGGA\\b")
        print("article url")
        print(calendarItem.articleText)
        print(calendarItem.articleUrl)
        messageLbl.enabledTypes.append(colorTextUrl)
        messageLbl.enabledTypes.append(colorTextUrl1)
        messageLbl.customize { (textUrl) in
            textUrl.customColor[colorTextUrl] = calendarItem.socialTextStringColor
            textUrl.customColor[colorTextUrl1] = calendarItem.socialTextStringColor
        }
    }
    
    internal func updateBtnView() {
        self.actionBtn.isHidden = !isActionBtnVisible()
        self.actionBtn.setTitle(getTitleBtn(), for: .normal)
        self.actionBtn.backgroundColor = getBtnColor()
    }
    
    internal func isActionBtnVisible() -> Bool {
        if calendarItem.status == StatusArticle.executed.rawValue {
            return false
        }
        return true
    }
    
    internal func getBtnColor() -> UIColor {
        switch calendarItem.status! {
        case StatusArticle.scheduled.rawValue:
            return UIColor(red: 255/255, green: 119/255, blue: 106/255, alpha: 1.0)
        case StatusArticle.failed.rawValue:
            return PopmetricsColor.blueMedium
        default:
            return PopmetricsColor.blueMedium
        }
    }
    
    internal func getTitleBtn() -> String {
        switch calendarItem.status! {
        case StatusArticle.scheduled.rawValue:
            return "Cancel"
        case StatusArticle.failed.rawValue:
            return "Reschedule"
        default:
            return ""
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd @ h:mma"
        dateFormatter.amSymbol = "a.m."
        dateFormatter.pmSymbol = "p.m."
        
        return dateFormatter.string(from: date)
    }
    
    internal func setUpCorners() {
        topHeaderView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        print("notLastCell status : \(notLastCell)")
        if notLastCell == true {
            topContainerVIew.layer.cornerRadius = 22
            imageContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        } else {
            topContainerVIew.roundCorners(corners: [.topLeft, .topRight], radius: 10)
            imageContainerView.layer.cornerRadius = 0
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private let elementProp: Dictionary<String, ElementProperties> = [
        StatusArticle.failed.rawValue: ElementProperties(colorBtn: PopmetricsColor.salmondColor, colorTxt: UIColor.red, isBtnVisible: true, titleBtn: "Reschedule")
    ]
    
}

struct ElementProperties {
    var colorBtn: UIColor
    var colorTxt: UIColor
    var isBtnVisible: Bool
    var titleBtn: String
}
