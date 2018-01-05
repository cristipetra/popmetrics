//
//  ToDoCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 18/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ObjectMapper
import Reachability

class SocialPostInCardCell: UITableViewCell {
    
    @IBOutlet weak var aproveButton: ActionTodoButton!
    @IBOutlet weak var denyPostBtn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var cardImage: UIImageView!
    
    @IBOutlet weak var circleView: UIView!
    
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var containerCornerBottom: UIView!
    @IBOutlet weak var containerBottom: UIView!
    @IBOutlet weak var constraintContainerBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintToolbarHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    private var todoItem: TodoSocialPost!;
    var indexPath: IndexPath!
    
    weak var actionSocialDelegate: ActionSocialPostProtocol!
    weak var bannerDelegate: BannerProtocol!
    
    // Extend view
    lazy var statusCardTypeView: StatusCardTypeView = {
        let view = StatusCardTypeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // End extend view
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        
        self.selectionStyle = .none
        self.circleView.roundCorners(corners: .allCorners, radius: self.circleView.frame.size.width / 2)
        addShadowToView(shadowView, radius: 4, opacity: 0.5)

        
        aproveButton.changeTitle("Approve")
        
        setupCorners()
    }
    
    func configure(item: TodoSocialPost) {
        todoItem = item
        cardImage.image = nil
        
        messageLbl.text = todoItem.articleText
        
        if let imageUri = todoItem.articleImage {
            let url = URL(string: imageUri)
            if let _ = url {
                cardImage.af_setImage(withURL: url!)
            }
        }
        
        aproveButton.addTarget(self, action: #selector(animationHandler), for: .touchUpInside)
        denyPostBtn.addTarget(self, action: #selector(denyPostHandler), for: .touchUpInside)
        
        setupStatusCardView()
    }
    
    func setIndexPath(indexPath: IndexPath, numberOfCellsInSection: Int) {
        if( indexPath.row != 0 ) {
            constraintToolbarHeight.constant = 0
        } else {
            constraintToolbarHeight.constant = 29
        }
        
        if( indexPath.row != (numberOfCellsInSection - 1) ) {
            constraintContainerBottom.constant = 0
        }
        self.indexPath = indexPath
    }
    
    private func displayErrorNetwork() {
        let notificationObj = ["alert":"",
                               "subtitle": "You need to be online to perform this action.",
                               "type": "failure",
                               "sound":"default"
        ]
        let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
        let todoHubController = self.parentViewController as! TodoHubController
        todoHubController.showBannerForNotification(pnotification)
    }
    
    @objc func animationHandler() {
        if !ReachabilityManager.shared.isNetworkAvailable {
            displayErrorNetwork()
            return
        }
        
        aproveButton.removeTarget(self, action: #selector(animationHandler), for: .touchUpInside)
        let indexPath = IndexPath()
        actionSocialDelegate.approvePostFromSocial!(post: todoItem, indexPath: indexPath)
        //todoItem.isApproved = true
        
        //I am assuming it's succesfull
        try! todoItem.realm?.write {
            todoItem.isApproved = true
        }
        
        setupStatusCardView()
/*
        //aproveButton.animateButton(decreaseWidth: 120, increaseWidth: 10, imgLeftSpace: 10)
        //aproveButton.removeTarget(self, action: #selector(animationHandler), for: .touchUpInside)
        let todoHubController = self.parentViewController as! TodoHubController
//        TodoHubController.approvePostFromSocial(todoItem)
        actionSocialDelegate.approvePostFromSocial!(post: todoItem, indexPath: indexPath)
*/
    }
    
    @objc func denyPostHandler() {
        if !ReachabilityManager.shared.isNetworkAvailable {
            displayErrorNetwork()
            return
        }
        
        TodoApi().denyPost(todoItem.postId!, callback: {
            () -> Void in
            let notificationObj = ["alert":"Post denied",
                                   "subtitle":"The article will be ignored in future recommendations.",
                                   "type": "info",
                                   "sound":"default"
            ]
            let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
            
            let todoHubController = self.parentViewController as! TodoHubController
            todoHubController.showBannerForNotification(pnotification)
            todoHubController.removeSocialPost(self.todoItem, indexPath: self.indexPath)
        })
    }
    
    func setupCorners() {
        self.containerCornerBottom.cornerRadius = 14
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupStatusCardView() {
        let isApproved = todoItem.isApproved
        print("approved \(isApproved)")
        if !isApproved {
            denyPostBtn.isHidden = false
            aproveButton.changeTitle("Approve")
        } else {
            aproveButton.changeTitle("Approved")
            denyPostBtn.isHidden = true
            aproveButton.removeTarget(self, action: #selector(animationHandler), for: .touchUpInside)
        }
    }
    
    func setStatusCardViewType() {
        /*
        if(todoItem.status == "approved") {
            statusCardTypeView.typeStatusView = .approved
        } else if(todoItem.status == "denied") {
            statusCardTypeView.typeStatusView = .denied
        }
         */
    }
    
//    func addStatusCardTypeView() {
//        self.addSubview(statusCardTypeView)
//        statusCardTypeView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        statusCardTypeView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
//        statusCardTypeView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        statusCardTypeView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        statusCardTypeView.layer.cornerRadius = 6
//    }
    
    func sideShadow(view: UIView) {
        view.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        let shadowRect : CGRect = view.bounds.insetBy(dx: 0, dy: 0)
        view.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
    
}
