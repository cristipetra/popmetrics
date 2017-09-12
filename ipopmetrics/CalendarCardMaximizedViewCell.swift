//
//  CalendarCardMaximizedViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 27/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ActiveLabel

protocol ApproveDenySinglePostProtocol: class {

    func approveSinglePostHandler(index: Int)
}

class CalendarCardMaximizedViewCell: UITableViewCell {
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var connectionStackView: UIStackView!
    @IBOutlet weak var topContainerVIew: UIView!
    @IBOutlet weak var topHeaderView: ToolbarViewCell!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var connectionContainerView: UIView!
    @IBOutlet weak var connectionLine: UIView!
    @IBOutlet weak var topImageButton: UIButton!
    @IBOutlet weak var dateLbl: ActiveLabel!
    @IBOutlet weak var messageLbl: ActiveLabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleIcon: UIImageView!
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleDate: ActiveLabel!
    @IBOutlet weak var postIconImageView: UIImageView!
    @IBOutlet weak var socialNetworkLbl: UILabel!
    @IBOutlet weak var actionBtn: RoundedCornersButton!
    
    
    var postIndex = 0
    weak var approveDenyDelegate : ApproveDenySinglePostProtocol?
    var toDoStackView : UIStackView!
    
    private var calendarItem: CalendarSocialPost!
    
    var isLastCell = false
    
    lazy var denyButton : UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "icon_deny"), for: .normal)
        
        return button
    }()
    
    lazy var approveButton : UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "icon_quepost"), for: .normal)
        return button
    }()
    
    lazy var approvedView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PopmetricsColor.darkGrey.withAlphaComponent(0.8)
        return view
        
    }()
    
    lazy var approvedButton : TwoImagesButton = {
        
        let button = TwoImagesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 54/255, green: 172/255, blue: 130/255, alpha: 1)
        return button
        
    }()
    
    lazy var approvedConnectionView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.connectionContainerView.backgroundColor = UIColor.feedBackgroundColor()

        setUpCorners()
    }
    
    func configure(_ item: CalendarSocialPost) {
        self.calendarItem = item;
        self.titleLbl.text = item.title
        //var formatedDate = self.formatDate((item.statusDate)!)
        var formatedDate = self.formatDate(Date())
        self.articleDate.text = " " + formatedDate
        self.messageLbl.text = item.text
        
        self.socialNetworkLbl.text = item.socialPost + ": " + item.type
        self.postIconImageView.image = UIImage(named: item.socialIcon)
//      self.articleImage.image = UIImage(named: item.articleImage!)
        
        self.connectionLine.backgroundColor = item.getSectionColor
        //self.topHeaderView.backgroundColor = item.getSectionColor

        self.topHeaderView.circleView.backgroundColor = item.getSectionColor
        self.topHeaderView.backgroundColor = item.getSectionColor
        //self.topHeaderView.title.text = "\(item.socialTextString)"
        self.topHeaderView.title.text = ""
        
        // updateBtnView()
        
        // changeColor()
    }
    
    func changeColor() {
        let customColor = ActiveType.custom(pattern: "\\\(calendarItem.socialTextString)\\b")
    
        articleDate.enabledTypes.append(customColor)
        
        articleDate.customize { (article) in
            article.customColor[customColor] = calendarItem.socialTextStringColor
        }
        
        let colorTextUrl = ActiveType.custom(pattern: "\\s\(calendarItem.url)\\b")
        
        messageLbl.enabledTypes.append(colorTextUrl)
        messageLbl.customize { (textUrl) in
            textUrl.customColor[colorTextUrl] = calendarItem.socialURLColor
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
    
    func approvePostHandler() {
        approveDenyDelegate?.approveSinglePostHandler(index: postIndex)
    }
    
    func setUpApprovedView(approved: Bool) {
        self.insertSubview(approvedView, at: 1)
        approvedView.topAnchor.constraint(equalTo: topContainerVIew.topAnchor).isActive = true
        approvedView.bottomAnchor.constraint(equalTo: topContainerVIew.bottomAnchor).isActive = true
        approvedView.leftAnchor.constraint(equalTo: topContainerVIew.leftAnchor).isActive = true
        approvedView.rightAnchor.constraint(equalTo: topContainerVIew.rightAnchor).isActive = true
        
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
    
    func setUpApprovedConnectionView() {
        connectionContainerView.addSubview(approvedConnectionView)
        approvedConnectionView.topAnchor.constraint(equalTo: connectionContainerView.topAnchor).isActive = true
        approvedConnectionView.bottomAnchor.constraint(equalTo: connectionContainerView.bottomAnchor).isActive = true
        approvedConnectionView.leftAnchor.constraint(equalTo: connectionLine.leftAnchor,constant: -1.5).isActive = true
        approvedConnectionView.rightAnchor.constraint(equalTo: connectionLine.rightAnchor, constant: 1.5).isActive = true
        connectionLine.backgroundColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
    }
    
    internal func getBtnColor() -> UIColor {
        switch calendarItem.status {
        case StatusArticle.scheduled.rawValue:
            return UIColor(red: 255/255, green: 119/255, blue: 106/255, alpha: 1.0)
        case StatusArticle.failed.rawValue:
            return PopmetricsColor.blueMedium
        default:
            return PopmetricsColor.blueMedium
        }
    }
    
    internal func getTitleBtn() -> String {
        switch calendarItem.status {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpCorners()
    }
    
    internal func setUpCorners() {
        DispatchQueue.main.async {
            self.topContainerVIew.roundCorners(corners: [.topRight, .topLeft] , radius: 10)
            self.topImageButton.layer.cornerRadius = 16
            if self.isLastCell == false {
                self.imageContainerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
                self.topContainerVIew.roundCorners(corners: [.bottomLeft, .bottomRight, .topLeft, .topRight] , radius: 10)
            }
            self.topContainerVIew.layer.masksToBounds = true
        }
        self.layoutIfNeeded()
    }
}
