//
//  GoogleActionViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class GoogleActionViewController: UIViewController {
    
    let recommendedActionView = RecommendedActionGoogleCitationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 355))
    let taskView = TaskGoogleCitationView(frame: CGRect(x: 0, y: 355, width: UIScreen.main.bounds.width, height: 608))
    
    lazy var footerView: FooterView = {
        let view = FooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let aimeeView = IndividualTaskView()
    let instructionsView = IndividualTaskView()
    
    var footerTopConstraint: NSLayoutConstraint!
    var footerBottomConstraint: NSLayoutConstraint!
    var isFooterVisible = false
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let backgroundImage = UIImage(named: "end_of_feed")?.withRenderingMode(.alwaysTemplate)
        self.containerView.backgroundColor = UIColor(patternImage: backgroundImage!)
        setUpNavigationBar()
        addRecommendedActionView()
        setTaskView()
        addAimeeView()
        addInstructionView()
        setUpFooterView()
        //footerView.setCorners = false
        setFooterButton(isTaskSelected: true)
    }
    func addRecommendedActionView() {
        
        self.containerView.addSubview(recommendedActionView)
        
        recommendedActionView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        recommendedActionView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        recommendedActionView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        self.containerView.addSubview(taskView)
        taskView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        taskView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        taskView.topAnchor.constraint(equalTo: recommendedActionView.bottomAnchor).isActive = true
        
    }
    
    func setUpFooterView() {
        
        self.containerView.addSubview(footerView)
        footerView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        
        footerBottomConstraint = footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,constant: 93)
        //footerTopConstraint = footerView.topAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0)
        //footerTopConstraint.isActive = true
        
        footerBottomConstraint.isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 93).isActive = true
        //footerView.informationBtn.isHidden = true
        footerView.xButton.isHidden = true
        footerView.addShadow(radius: 2, opacity: 0.3, offset: CGSize(width: 0.0, height: -3.0))
        footerView.backgroundColor = UIColor.white
    
    }
    
    func setTaskView() {
        taskView.setUpLabel(impactLevel: "medium impact", cost: "30", effort: "3 hours")
        taskView.setCostStyle(cost: "30")
        taskView.setEffortStyle(effort: "3")
        taskView.setImpactLevel(impact: "Medium")
    }
    
    
    
    func addAimeeView() {
        
        let numberOfRows = 6
        let aimeeContentView = AimeeView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: numberOfRows * 60 + 32))
        aimeeContentView.numberOfRows = numberOfRows
        self.containerView.addSubview(aimeeView)
        aimeeView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        aimeeView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        
        aimeeView.topAnchor.constraint(equalTo:taskView.bottomAnchor).isActive = true
        aimeeView.titleLabel.text = "Aimee's View"
        aimeeView.taskContainerView.addSubview(aimeeContentView)
        aimeeView.containerView.backgroundColor = UIColor.white
        aimeeView.backgroundColor = UIColor.white
        aimeeView.taskContainerView.isHidden = true
        aimeeView.subtitleLabel.isHidden = true
        aimeeContentView.bottomAnchor.constraint(equalTo: aimeeView.taskContainerView.bottomAnchor).isActive = true
        aimeeContentView.topAnchor.constraint(equalTo: aimeeView.taskContainerView.topAnchor).isActive = true
        aimeeView.expandButton.parentView = aimeeView
        aimeeView.expandButton.addTarget(self, action: #selector(showHideContent(sender:)), for: .touchUpInside)
    }
    
    func addInstructionView() {
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        separatorView.backgroundColor = UIColor(red: 189/255, green: 197/255, blue: 203/255, alpha: 1)
        
        self.containerView.addSubview(instructionsView)
        
        instructionsView.containerView.addSubview(separatorView)
        instructionsView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        instructionsView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        instructionsView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -114).isActive = true
        instructionsView.topAnchor.constraint(equalTo:aimeeView.bottomAnchor,constant: 1).isActive = true
        instructionsView.titleLabel.text = "View Instructions"
        instructionsView.setUpSubtitleview()
        instructionsView.containerView.backgroundColor = UIColor.white
        instructionsView.taskContainerView.isHidden = true
        instructionsView.titleLabel.font = UIFont(name: FontBook.bold, size: 15)
        instructionsView.subtitleLabel.isHidden = true
        instructionsView.expandButton.transform = instructionsView.expandButton.transform.rotated(by: (3 * .pi / 2))
        instructionsView.addShadow(radius: 2, opacity: 0.3, offset: CGSize(width: 0.0, height: 3.0))
    }
    
    func showHideContent(sender: ButtonWithContainer) {
        var rotateDirection :CGFloat = 0
        if sender.parentView.isContentHidden == true {
            rotateDirection = -(CGFloat.pi)
        } else {
            rotateDirection = (.pi)
        }
        
        UIView.animate(withDuration: 0.4) {
            sender.transform = sender.transform.rotated(by: rotateDirection)
            sender.parentView.isContentHidden = !sender.parentView.isContentHidden
            if sender.parentView.isContentHidden == true {
                sender.parentView.taskContainerView.alpha = 1
            } else {
                sender.parentView.taskContainerView.alpha = 0
            }
        }
    }
    
    func setFooterButton(isTaskSelected: Bool) {
        if isTaskSelected {
            footerView.actionButton.leftHandImage = UIImage(named: "iconGoogle")
            footerView.actionButton.rightHandImage = UIImage(named: "")
            footerView.actionButton.backgroundColor = PopmetricsColor.yellowBGColor
            footerView.approveLbl.text = "Connect Google"
        } else {
            footerView.actionButton.leftHandImage = UIImage(named: "icon2CtaTaskcard")
            footerView.actionButton.rightHandImage = UIImage(named: "")
            footerView.actionButton.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
            footerView.approveLbl.text = "Add to Task"
        }
    }
    
    func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "Connect Google Analytics", style: .plain, target: self, action: nil)
        text.tintColor = UIColor(red: 67/255, green: 78/255, blue: 84/255, alpha: 1.0)
        let titleFont = UIFont(name: FontBook.bold, size: 18)
        text.setTitleTextAttributes([NSFontAttributeName: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "iconCalLeftBold"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GoogleActionViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if ((scrollView.contentOffset.y + 60) >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            
            self.containerView.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.6, animations: {
                if self.isFooterVisible == false {
                    self.footerBottomConstraint.constant = 0
                }
                self.isFooterVisible = true
                self.containerView.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.footerBottomConstraint.constant = 93
                self.isFooterVisible = false
                self.containerView.layoutIfNeeded()
            })
        }
    }
    
}

extension UIView {
    func addShadow(radius: CGFloat,opacity: Float, offset: CGSize = CGSize(width: 0.0, height: 0.0)) {
        self.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        self.layer.shadowOpacity = opacity;
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
    }
}
