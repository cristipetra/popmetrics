
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
    
    @IBOutlet weak var socialIconView: SocialIconView!
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var containerCornerBottom: UIView!
    @IBOutlet weak var containerBottom: UIView!
    @IBOutlet weak var constraintContainerBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintToolbarHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    internal var todoItem: TodoSocialPost!;
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

        addShadowToView(shadowView, radius: 4, opacity: 0.5)
        
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
        
        socialIconView.socialType = todoItem.type
        
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
        
        if todoItem.type == "facebook" {
            displayFacebook()
            return
        }
        
        aproveButton.removeTarget(self, action: #selector(animationHandler), for: .touchUpInside)
        let indexPath = IndexPath()
        actionSocialDelegate.approvePostFromSocial!(post: todoItem, indexPath: indexPath)
        //todoItem.isApproved = true
        
        aproveButton.animateButton()
        
        //I am assuming it's succesfull
        try! todoItem.realm?.write {
            todoItem.isApproved = true
        }
        
        setupStatusCardView()

    }
    
    func displayFacebook() {
        actionSocialDelegate.displayFacebookDetails!(post: todoItem, indexPath: indexPath)
    }
    
    @objc func denyPostHandler() {
        if !ReachabilityManager.shared.isNetworkAvailable {
            displayErrorNetwork()
            return
        }
        
        TodoApi().denyPost(todoItem.postId!, callback: {
            () -> Void in
            let notificationObj = ["title":"Post denied",
                                   "subtitle":"The article will be ignored in future recommendations.",
                                   "type": "info",
                                   "sound":"default"
            ]
            let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
            
            let todoHubController = self.parentViewController as! TodoHubController
            //todoHubController.showBannerForNotification(pnotification)
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
            aproveButton.displayUnapproved()
        } else {
            aproveButton.displayApproved()
            denyPostBtn.isHidden = true
            aproveButton.removeTarget(self, action: #selector(animationHandler), for: .touchUpInside)
        }
    }

    func sideShadow(view: UIView) {
        view.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        let shadowRect : CGRect = view.bounds.insetBy(dx: 0, dy: 0)
        view.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
    
}
