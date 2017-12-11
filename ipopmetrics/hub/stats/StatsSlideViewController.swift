//
//  StatsSlideViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController

class StatsSlideViewController: UIViewController {
    
    var slideView: MetricReportView!
    
    var statsMetric: StatisticMetric!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slideView = MetricReportView(metric: self.statsMetric)
        
        self.view.addSubview(slideView)

        slideView.translatesAutoresizingMaskIntoConstraints = false
        slideView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        slideView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        slideView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        //statusView.heightAnchor.constraint(equalToConstant: 1500).isActive = true
        
        self.view.bottomAnchor.constraint(equalTo: slideView.bottomAnchor, constant: 0).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

protocol ReloadGraphProtocol {
    func reloadGraph(statisticMetric: StatisticMetric)
}
