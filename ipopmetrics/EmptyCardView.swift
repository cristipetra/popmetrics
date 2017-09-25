//
//  EmptyCardView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 18/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class EmptyCardView: UITableViewCell {
    
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var messageLabelTop: NSLayoutConstraint!
    @IBOutlet weak var middleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    @IBOutlet weak var wrapperView: UIView!
    
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PopmetricsColor.weekDaysGrey
        return view
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView(type: FeedType, toDoStatus: ToDoStatus = .unapproved, calendarStatus: StatusArticle = .scheduled) {

        switch type {
        case .statistics:
            self.toolbarView.setupGradient()
            self.footerView.setupGradient()
            self.setUpShadowLayer()
            self.setCornerRadius()
            self.footerView.approveLbl.textColor = PopmetricsColor.trafficEmptyApproveLbl
            self.toolbarView.title.text = "Traffic stats: Unconnected"
            self.toolbarView.leftImage.image = UIImage(named: "iconHeaderTrafficStats")
            self.toolbarView.isLeftImageHidden = false
            self.toolbarView.leftImage.widthAnchor.constraint(equalToConstant: 10).isActive = true
            self.footerView.approveLbl.text = "View Traffic Report"
            self.footerView.actionButton.imageButtonType = .traffic
            self.footerView.actionButton.changeToDisabled()
        //self.footerView.setIsTrafficUnconnected()
        case .todo:
            self.setUpShadowLayer()
            self.setCornerRadius()
            self.addDivider()
            self.footerView.hideButton(button: self.footerView.actionButton)
            self.footerView.approveLbl.alpha = 0
            self.footerView.disableButton(button: self.footerView.xButton)
            self.footerView.disableButton(button: self.footerView.loadMoreBtn)
            self.footerView.loadMoreLbl.alpha = 0.3
            messageLabelTop.constant = 13
            middleViewHeight.constant = 81
            switch toDoStatus {
            case .unapproved:
                self.toolbarView.backgroundColor = PopmetricsColor.yellowUnapproved
                self.toolbarView.circleView.backgroundColor = PopmetricsColor.yellowUnapproved
                self.toolbarView.title.text = "Manual Actions"
                self.messageLabel.text = "No automated actions activated just yet."
            case .manual:
                self.toolbarView.backgroundColor = PopmetricsColor.purpleToDo
                self.toolbarView.circleView.backgroundColor = PopmetricsColor.purpleToDo
                self.toolbarView.title.text = "Manual Actions"
                self.messageLabel.text = "No manual actions activated just yet."
            case .failed:
                self.toolbarView.backgroundColor = PopmetricsColor.salmondColor
                self.toolbarView.circleView.backgroundColor = PopmetricsColor.salmondColor
                self.toolbarView.title.text = "Failed Actions"
                self.messageLabel.text = "Of course no failed actions yet :)"
            default:
                break
            }
            break
        case .calendar:
            self.setUpShadowLayer()
            self.setCornerRadius()
            self.addDivider()
            self.footerView.hideButton(button: self.footerView.actionButton)
            self.footerView.approveLbl.alpha = 0
            self.footerView.hideButton(button: self.footerView.xButton)
            self.footerView.disableButton(button: self.footerView.loadMoreBtn)
            self.footerView.hideButton(button: self.footerView.informationBtn)
            self.footerView.loadMoreLbl.alpha = 0.3
            messageLabelTop.constant = 13
            middleViewHeight.constant = 81
            switch calendarStatus {
            case .scheduled:
                self.toolbarView.backgroundColor = PopmetricsColor.blueURLColor
                self.toolbarView.circleView.backgroundColor = PopmetricsColor.blueURLColor
                self.toolbarView.title.text = "Scheduled Posts"
                self.messageLabel.text = "No actions have been scheduled just yet."
            case .completed:
                self.toolbarView.backgroundColor = PopmetricsColor.calendarCompleteGreen
                self.toolbarView.circleView.backgroundColor = PopmetricsColor.calendarCompleteGreen
                self.toolbarView.title.text = "Completed Actions"
                self.messageLabel.text = "No actions have been completed just yet."
            default:
                break
            }
        default:
            break
        }
        self.messageLabel.adjustLabelSpacing(spacing: 0, lineHeight: 24, letterSpacing: 0.3)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCornerRadius() {
        self.wrapperView.layer.cornerRadius = 12
        self.wrapperView.layer.masksToBounds = true
    }
    func addDivider() {
        self.addSubview(divider)
        divider.bottomAnchor.constraint(equalTo: self.footerView.topAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divider.leftAnchor.constraint(equalTo: self.wrapperView.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: self.wrapperView.rightAnchor).isActive = true
    }
    
    func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.topAnchor.constraint(equalTo: toolbarView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
        shadowLayer.leftAnchor.constraint(equalTo: wrapperView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: wrapperView.rightAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 12
    }
}

enum ToDoStatus: String {
    case failed = "todo_failed"
    case unapproved = "todo_unapproved"
    case manual = "manual"
}
