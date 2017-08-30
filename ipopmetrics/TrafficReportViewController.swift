//
//  TrafficReportViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TrafficReportViewController: UIViewController {

    @IBOutlet var containerView: UIView!
    let statsPageVC: StatsPageViewController = StatsPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPageView()
    }
    
    
    func addPageView() {
        statsPageVC.view.frame = CGRect(x: 0, y: 300, width: self.containerView.frame.width, height: 562)
        addChildViewController(statsPageVC)
        self.containerView.addSubview(statsPageVC.view)
        statsPageVC.didMove(toParentViewController: self)
        statsPageVC.view.backgroundColor = UIColor.darkGray
    }
    

}
