//
//  ToDoCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 18/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ToDoCardCell: UITableViewCell {
    
    @IBOutlet weak var denyPostBtn: UIButton!
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var foregroundImage: UIImageView!
    @IBOutlet weak var aproveButton: TwoColorButton!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    
    var todoItem: TodoSocialPost!;
    
    
    // Extend view
    lazy var statusCardTypeView: StatusCardTypeView = {
        let view = StatusCardTypeView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // End extend view
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        addStatusCardTypeView()
        setupCorners()
        
        
        
        //        DispatchQueue.main.async {
        //            self.approveBtn.layer.masksToBounds = false
        //            self.approveBtn.layer.cornerRadius = self.approveBtn.frame.height / 2
        //            self.addShadowToViewBtn(self.approveBtn)
        //        }
    }
    
    func configure(item: TodoSocialPost) {
        todoItem = item
        
        messageLbl.text = todoItem.articleText
        messageLbl.adjustLabelSpacing(spacing: 0, lineHeight: 18, letterSpacing: 0.4)
        setupStatusCardView( approved: (item.status == "approved" || item.status == "denied"))
        
        aproveButton.addTarget(self, action: #selector(animationHandler), for: .touchUpInside)
    }
    
    func animationHandler() {
        animateButton(button: aproveButton)
    }
    
    internal func animateButton(button: TwoColorButton) {
        self.buttonWidthConstraint.constant += -115
        //   self.buttonLeadingConstraint.constant += 95
        //        button.label.text = ""
        //        button.label.isHidden = true
        button.image = UIImage(named: "iconCheck")
        button.changeImgConstrain(value: 10)
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            self.layoutIfNeeded()
        }) { (completion) in
            button.alpha = 1.0
        }
    }
    
    func setupCorners() {
        DispatchQueue.main.async {
            self.circleView.roundCorners(corners: .allCorners, radius: self.circleView.frame.size.width / 2)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
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
    
    func addStatusCardTypeView() {
        self.addSubview(statusCardTypeView)
        statusCardTypeView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        statusCardTypeView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        statusCardTypeView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        statusCardTypeView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        statusCardTypeView.layer.cornerRadius = 6
    }
    
    func sideShadow(view: UIView) {
        view.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        let shadowRect : CGRect = view.bounds.insetBy(dx: 0, dy: 0)
        view.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
    
}
