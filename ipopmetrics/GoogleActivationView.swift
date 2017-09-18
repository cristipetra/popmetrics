//
//  GoogleActivationView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class GoogleActivationView: UIView {
    
    //View
    lazy var recommendedActionView: RecommendedActionGoogleCitationView = {
        let view = RecommendedActionGoogleCitationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 355))
        return view
    }()
    
    lazy var taskView: TaskGoogleCitationView = {
        let view = TaskGoogleCitationView(frame: CGRect(x: 0, y: 355, width: UIScreen.main.bounds.width, height: 608))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var popmetricsInsightView: IndividualTaskView = {
        let view = IndividualTaskView()
        return view
    }()
    
    lazy var recommendedReadingView: IndividualTaskView = {
        let view = IndividualTaskView()
        return view
    }()
    
    lazy var footerView: FooterView = {
        let view = FooterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // the view before the footer
    lazy var backgroundImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let statsView = IndividualTaskView()
    let aimeeView = IndividualTaskView()
    let instructionsView = IndividualTaskView()
    //End View
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup();
    }
    
    func setup() {
        addRecommendedActionView()
        setUpFooterView()
        addBackgroundBeforeFooter()
        footerView.setCorners = false
        
        addTaskView()
        addPopmetricsInsightView()
        addStatsView()
        addRecommendedReadingView()
        addAimeeView()
        addInstructionView()
        
        setFooterButton(isTaskSelected: false)
    }
    
    
    func addRecommendedActionView() {
        self.addSubview(recommendedActionView)
        
        recommendedActionView.translatesAutoresizingMaskIntoConstraints = false
        recommendedActionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        recommendedActionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        recommendedActionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        recommendedActionView.heightAnchor.constraint(equalToConstant: 355).isActive = true
    }
    
    func setUpFooterView() {
        
        self.addSubview(footerView)
        footerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        footerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //footerView.topAnchor.constraint(equalTo: testView.bottomAnchor,constant: 20).isActive = true
        footerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 93).isActive = true
        footerView.informationBtn.isHidden = true
        footerView.xButton.isHidden = true
    }
    
    func addBackgroundBeforeFooter() {
        self.addSubview(backgroundImageView)
        backgroundImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        backgroundImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        backgroundImageView.addSubview(imageView)
        imageView.image = UIImage(named: "end_of_feed")
        imageView.contentMode = .scaleToFill
    }
    
    func addTaskView() {
        self.addSubview(taskView)
        
        taskView.translatesAutoresizingMaskIntoConstraints = false
        taskView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        taskView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        taskView.topAnchor.constraint(equalTo: self.topAnchor, constant: 355).isActive = true
        taskView.heightAnchor.constraint(equalToConstant: 608).isActive = true
    }
    
    func addPopmetricsInsightView() {
        
        let insightViewTest = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 200))
        
        self.addSubview(popmetricsInsightView)
        popmetricsInsightView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        popmetricsInsightView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        popmetricsInsightView.topAnchor.constraint(equalTo: taskView.bottomAnchor,constant: 2).isActive = true
        popmetricsInsightView.titleLabel.text = "Popmetrics Insight"
        popmetricsInsightView.titleLabel.textColor = UIColor.white
        popmetricsInsightView.taskContainerView.addSubview(insightViewTest)
        popmetricsInsightView.containerView.backgroundColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        insightViewTest.backgroundColor = UIColor.cyan
        popmetricsInsightView.taskContainerView.isHidden = true
        popmetricsInsightView.expandButton.tintColor = UIColor.white
        insightViewTest.bottomAnchor.constraint(equalTo: popmetricsInsightView.taskContainerView.bottomAnchor).isActive = true
        popmetricsInsightView.expandButton.parentView = popmetricsInsightView
        //popmetricsInsightView.expandButton.addTarget(self, action: #selector(showHideContent(sender:)), for: .touchUpInside)
        //footerView.topAnchor.constraint(equalTo: test.containerStackView.bottomAnchor,constant: 10).isActive = true
        
    }
    
    func addStatsView() {
        
        let insightViewTest = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 200))
        //let trafficStats = TrafficStatusView(frame: CGRect(x: 0, y: 0, width: 375, height: 500))
        
        //thirdTest.taskContainerView.frame = needed view bounds
        
        self.addSubview(statsView)
        statsView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        statsView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        statsView.topAnchor.constraint(equalTo:popmetricsInsightView.bottomAnchor).isActive = true
        statsView.titleLabel.text = "Stats"
        statsView.setUpSubtitleview()
        statsView.taskContainerView.addSubview(insightViewTest)
        statsView.containerView.backgroundColor = UIColor.white
        statsView.backgroundColor = UIColor.belizeHoleColor()
        statsView.taskContainerView.isHidden = true
        statsView.subtitleLabel.isHidden = true
        insightViewTest.bottomAnchor.constraint(equalTo: statsView.taskContainerView.bottomAnchor).isActive = true
        statsView.expandButton.parentView = statsView
        //statsView.expandButton.addTarget(self, action: #selector(showHideContent(sender:)), for: .touchUpInside)
        
        //footerView.topAnchor.constraint(equalTo: thirdTest.containerStackView.bottomAnchor,constant: 10).isActive = true
        
    }
    
    func addRecommendedReadingView() {
        
        let insightViewTest2 = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 400))
        
        self.addSubview(recommendedReadingView)
        recommendedReadingView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        recommendedReadingView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        recommendedReadingView.topAnchor.constraint(equalTo:statsView.bottomAnchor).isActive = true
        recommendedReadingView.titleLabel.text = "Recommended Reading"
        recommendedReadingView.taskContainerView.addSubview(insightViewTest2)
        recommendedReadingView.containerView.backgroundColor = PopmetricsColor.darkGrey
        recommendedReadingView.titleLabel.textColor = UIColor.white
        recommendedReadingView.expandButton.tintColor = UIColor.white
        insightViewTest2.backgroundColor = UIColor.belizeHoleColor()
        recommendedReadingView.taskContainerView.isHidden = true
        insightViewTest2.bottomAnchor.constraint(equalTo: recommendedReadingView.taskContainerView.bottomAnchor).isActive = true
        recommendedReadingView.expandButton.parentView = recommendedReadingView
        //recommendedReadingView.expandButton.addTarget(self, action: #selector(showHideContent(sender:)), for: .touchUpInside)
    }
    
    func addAimeeView() {
        
        let insightViewTest = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 200))
        //let trafficStats = TrafficStatusView(frame: CGRect(x: 0, y: 0, width: 375, height: 500))
        
        //thirdTest.taskContainerView.frame = needed view bounds
        
        self.addSubview(aimeeView)
        aimeeView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        aimeeView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        aimeeView.topAnchor.constraint(equalTo:recommendedReadingView.bottomAnchor).isActive = true // setting top anchor to previous bottom anchor
        
        aimeeView.titleLabel.text = "Aimee's View"
        aimeeView.setUpSubtitleview()
        aimeeView.taskContainerView.addSubview(insightViewTest)
        aimeeView.containerView.backgroundColor = UIColor.white
        aimeeView.backgroundColor = UIColor.belizeHoleColor()
        aimeeView.taskContainerView.isHidden = true
        aimeeView.subtitleLabel.isHidden = true
        insightViewTest.bottomAnchor.constraint(equalTo: aimeeView.taskContainerView.bottomAnchor).isActive = true
        aimeeView.expandButton.parentView = aimeeView
        //aimeeView.expandButton.addTarget(self, action: #selector(showHideContent(sender:)), for: .touchUpInside)
        
        //this has to be set for the last view cuz the bottom view (footer view) needs to set its top anchor to be able to scroll
        
        //footerView.topAnchor.constraint(equalTo: aimeeView.containerStackView.bottomAnchor).isActive = true
        
    }
    
    func addInstructionView() {
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        separatorView.backgroundColor = UIColor(red: 189/255, green: 197/255, blue: 203/255, alpha: 1)
        
        self.addSubview(instructionsView)
        
        instructionsView.containerView.addSubview(separatorView)
        instructionsView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        instructionsView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        instructionsView.topAnchor.constraint(equalTo:aimeeView.bottomAnchor,constant: 1).isActive = true // setting top anchor to previous bottom anchor
        
        instructionsView.titleLabel.text = "View Instructions"
        instructionsView.setUpSubtitleview()
        //instructionsView.taskContainerView.addSubview(insightViewTest)
        instructionsView.containerView.backgroundColor = UIColor.white
        instructionsView.taskContainerView.isHidden = true
        instructionsView.titleLabel.font = UIFont(name: FontBook.bold, size: 15)
        instructionsView.subtitleLabel.isHidden = true
        //insightViewTest.bottomAnchor.constraint(equalTo: aimeeView.taskContainerView.bottomAnchor).isActive = true
        //instructionsView.bottomAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
        instructionsView.expandButton.setImage(UIImage(named:"iconCalRighttBold"), for: .normal)
        //aimeeView.expandButton.parentView = aimeeView
        //aimeeView.expandButton.addTarget(self, action: #selector(showHideContent(sender:)), for: .touchUpInside)
        
        //this has to be set for the last view cuz the bottom view (footer view) needs to set its top anchor to be able to scroll
        
        //footerView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true
        
    }
    
    func setFooterButton(isTaskSelected: Bool) {
        if isTaskSelected {
            footerView.actionButton.leftHandImage = UIImage(named: "icon2CtaTaskcard")
            footerView.actionButton.rightHandImage = UIImage(named: "")
            footerView.actionButton.backgroundColor = UIColor(red: 238/255, green: 127/255, blue: 111/255, alpha: 1)
            footerView.approveLbl.text = "Remove From Task"
            
        } else {
            footerView.actionButton.leftHandImage = UIImage(named: "icon2CtaTaskcard")
            footerView.actionButton.rightHandImage = UIImage(named: "")
            footerView.actionButton.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
            footerView.approveLbl.text = "Add to Task"
        }
        
    }

}
