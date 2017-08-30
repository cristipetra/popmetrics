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
        
        addChartView()
        addPageView()
    }
    
    func addChartView() {
        let chartVC = UIStoryboard(name: "ChartStatistics", bundle: nil).instantiateViewController(withIdentifier: "ChartViewId") as! ChartViewController
        
        chartVC.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: 400)
        addChildViewController(chartVC)
        self.containerView.addSubview(chartVC.view)
        chartVC.didMove(toParentViewController: self)
        
    }
    
    func addPageView() {
        statsPageVC.view.frame = CGRect(x: 0, y: 300, width: self.containerView.frame.width, height: 562)
        addChildViewController(statsPageVC)
        self.containerView.addSubview(statsPageVC.view)
        statsPageVC.didMove(toParentViewController: self)
        statsPageVC.view.backgroundColor = UIColor.darkGray
    }
    

}
