//
//  GoogleActionViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class GoogleActionViewController: UIViewController {

    let taskView = TaskGoogleCitationView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 608))
    let containerView:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.size.height - 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addContainerView();
        
        addRecommendedActionView()
    }

    func addContainerView() {
        
        self.view.addSubview(containerView)

        //containerView.isScrollEnabled = true
        
        /*
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
         */
        containerView.backgroundColor = .red
    }
    
    func addRecommendedActionView() {
        
        self.containerView.addSubview(taskView)
        /*
        taskView.translatesAutoresizingMaskIntoConstraints = false
        taskView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        taskView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        taskView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        taskView.heightAnchor.constraint(equalToConstant: 1008).isActive = true
 */
        
    }

}
