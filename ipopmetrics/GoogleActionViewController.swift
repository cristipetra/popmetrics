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
    
    let containerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height + 1000))
    
    let scrollView: UIScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addScrollView()
        addContainerView()
        addRecommendedActionView()
        addTaskView()
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
        taskView.heightAnchor.constraint(equalToConstant: 1008).isActive = true
    }

}
