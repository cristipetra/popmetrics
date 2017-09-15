//
//  GoogleActionViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class GoogleActionViewController: UIViewController {

    let taskView = TaskGoogleCitationView(frame: CGRect(x: 0, y: 355, width: UIScreen.main.bounds.width, height: 608))
    let recommendedActionView = RecommendedActionGoogleCitationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 355))
    
    let containerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height + 620))
    
    let scrollView: UIScrollView = UIScrollView()
    
    let popmetricsInsightView = IndividualTaskView()
    let recommendedReadingView = IndividualTaskView()
    let statsView = IndividualTaskView()
    let aimeeView = IndividualTaskView()
    let instructionsView = IndividualTaskView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        
        setUpNavigationBar()
        
        addScrollView()
        addContainerView()
        addRecommendedActionView()
        addTaskView()
        
        addPopmetricsInsightView()
        addStatsView()
        addRecommendedReadingView()
        addAimeeView()
        addInstructionView()
    }
    
    func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "Social Post", style: .plain, target: self, action: nil)
        text.tintColor = UIColor(red: 67/255, green: 78/255, blue: 84/255, alpha: 1.0)
        let titleFont = UIFont(name: FontBook.bold, size: 18)
        text.setTitleTextAttributes([NSFontAttributeName: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "iconCalLeftBold"), style: .plain, target: self, action: #selector(handlerClickBack))
        //self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addScrollView() {
        self.view.addSubview(scrollView)
        scrollView.isDirectionalLockEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
    }

    func addContainerView() {
        
        self.scrollView.addSubview(containerView)
        /*
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
         */
        scrollView.contentSize = containerView.bounds.size
    }
    
    func addRecommendedActionView() {
        self.containerView.addSubview(recommendedActionView)
        
        recommendedActionView.translatesAutoresizingMaskIntoConstraints = false
        recommendedActionView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        recommendedActionView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        recommendedActionView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        recommendedActionView.heightAnchor.constraint(equalToConstant: 355).isActive = true
    }
    
    func addTaskView() {
        self.containerView.addSubview(taskView)
        
        taskView.translatesAutoresizingMaskIntoConstraints = false
        taskView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        taskView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        taskView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 355).isActive = true
        taskView.heightAnchor.constraint(equalToConstant: 608).isActive = true
    }
    
    func addPopmetricsInsightView() {
        
        let insightViewTest = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 200))
        
        self.containerView.addSubview(popmetricsInsightView)
        popmetricsInsightView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        popmetricsInsightView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
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
        
        self.containerView.addSubview(statsView)
        statsView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        statsView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
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
        
        self.containerView.addSubview(recommendedReadingView)
        recommendedReadingView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        recommendedReadingView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
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
        
        self.containerView.addSubview(aimeeView)
        aimeeView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        aimeeView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        
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
        
        self.containerView.addSubview(instructionsView)
        
        instructionsView.containerView.addSubview(separatorView)
        instructionsView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        instructionsView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        
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
    

}
