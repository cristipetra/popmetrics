//
//  TodoCardMaximizedViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 06/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ActiveLabel

class TodoCardMaximizedViewCell: UITableViewCell {
    
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
    
    @IBOutlet weak var connectionLineWidth: NSLayoutConstraint!
    
    var postIndex = 0
    var approveDenyDelegate : TodoCardActionHandler?
    var toDoStackView : UIStackView!
    
    private var todoItem: TodoSocialPost!
    
    var notLastCell = true
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

    lazy var statusCardTypeView: StatusCardTypeView = {
        let view = StatusCardTypeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addStatusCardTypeView()
        setUpMaximizeToDo()
    }
    
    func configure(_ item: TodoSocialPost) {
        self.todoItem = item;
        
        self.titleLbl.text = item.articleTitle
        //var formatedDate = self.formatDate((item.statusDate)!)
        var formatedDate = self.formatDate(Date())
        self.articleDate.text = " " + formatedDate
        self.messageLbl.text = item.articleText
        
        self.socialNetworkLbl.text = item.socialPost + ": " + item.articleCategory!
        self.postIconImageView.image = UIImage(named: item.socialIcon)
        //        self.articleImage.image = UIImage(named: item.articleImage!)
        
        self.connectionLine.backgroundColor = PopmetricsColor.darkGrey
        //self.topHeaderView.backgroundColor = item.getSectionColor
        
        self.topHeaderView.circleView.backgroundColor = item.getSectionColor
        if let card = item.todoCard {
                self.topHeaderView.title.text = card.getCardToolbarTitle
        }
        
        setupStatusCardView( approved: (item.status == "approved" || item.status == "denied"))
        
        connectionLineWidth.constant =  5
    }
    
    func addStatusCardTypeView() {
        self.addSubview(statusCardTypeView)
        statusCardTypeView.topAnchor.constraint(equalTo: topContainerVIew.topAnchor, constant: 29).isActive = true
        statusCardTypeView.bottomAnchor.constraint(equalTo: topContainerVIew.bottomAnchor).isActive = true
        statusCardTypeView.leftAnchor.constraint(equalTo: topContainerVIew.leftAnchor).isActive = true
        statusCardTypeView.rightAnchor.constraint(equalTo: topContainerVIew.rightAnchor).isActive = true
    }
    
    
    func changeColor() {
        let customColor = ActiveType.custom(pattern: "\\\(todoItem.socialTextString)\\b")
        
        articleDate.enabledTypes.append(customColor)
        
        articleDate.customize { (article) in
            article.customColor[customColor] = todoItem.socialTextStringColor
        }
        
        let colorTextUrl = ActiveType.custom(pattern: "\\s\(todoItem.articleUrl)\\b")
        
        messageLbl.enabledTypes.append(colorTextUrl)
        messageLbl.customize { (textUrl) in
            textUrl.customColor[colorTextUrl] = todoItem.socialURLColor
        }
    }
    
    internal func updateBtnView() {
        self.actionBtn.isHidden = !isActionBtnVisible()
        self.actionBtn.setTitle(getTitleBtn(), for: .normal)
        self.actionBtn.backgroundColor = getBtnColor()
    }
    
    internal func isActionBtnVisible() -> Bool {
        if todoItem.status == StatusArticle.executed.rawValue {
            return false
        }
        return true
    }
    
    func setUpMaximizeToDo() {
        actionBtn.isHidden = true
        
        toDoStackView = UIStackView(arrangedSubviews: [denyButton, approveButton])
        toDoStackView.axis = .horizontal
        toDoStackView.alignment = .center
        toDoStackView.distribution = .equalSpacing
        toDoStackView.spacing = 50
        
        topContainerVIew.addSubview(toDoStackView)
        toDoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        toDoStackView.centerXAnchor.constraint(equalTo: topContainerVIew.centerXAnchor).isActive = true
        toDoStackView.centerYAnchor.constraint(equalTo: articleImage.centerYAnchor, constant: -20).isActive = true
        
        approveButton.addTarget(self, action: #selector(approvePostHandler), for: .touchUpInside)
        
        denyButton.addTarget(self, action: #selector(denyPosHandler), for: .touchUpInside);
    }
    
    func approvePostHandler() {
        approveDenyDelegate?.handleCardAction("approve_one", todoCard: self.todoItem.todoCard!,
                                             params:["social_post":self.todoItem])
    }
    
    func denyPosHandler() {
        approveDenyDelegate?.handleCardAction("deny_one", todoCard: self.todoItem.todoCard!, params: ["social_post": self.todoItem])
    }
    
    func setupStatusCardView(approved: Bool) {
        print("approved \(approved)")
        if( approved == false) {
            self.statusCardTypeView.isHidden = true
        } else {
            setStatusCardViewType()
            self.statusCardTypeView.isHidden = false
        }
    }
    
    func setStatusCardViewType() {
        if(todoItem.status == "approved") {
            statusCardTypeView.typeStatusView = .approved
        } else if(todoItem.status == "denied") {
            statusCardTypeView.typeStatusView = .denied
        }
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
        switch todoItem.status! {
        case StatusArticle.scheduled.rawValue:
            return UIColor(red: 255/255, green: 119/255, blue: 106/255, alpha: 1.0)
        case StatusArticle.failed.rawValue:
            return PopmetricsColor.blueMedium
        default:
            return PopmetricsColor.blueMedium
        }
    }
    
    internal func getTitleBtn() -> String {
        switch todoItem.status! {
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
