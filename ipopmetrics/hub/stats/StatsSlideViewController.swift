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
    
    var statusView: TrafficStatus = TrafficStatus(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    internal var statistiscCard: StatisticsCard!
    
    private var staticMetric: StatisticMetric!
    
    internal var pageIndex: Int = 1 {
        didSet {
            statusView.pageIndex = pageIndex 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.addSubview(statusView)
        statusView.tableView.didMove(toParentViewController: self)
        statusView.chartVC.didMove(toParentViewController: self)
        
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        statusView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        statusView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        //statusView.heightAnchor.constraint(equalToConstant: 1500).isActive = true
        
        self.view.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 0).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    func configure(card: StatisticsCard) {
        self.statistiscCard = card
        //self.pageIndex = pageIndex
     statusView.configure(card: statstaticMetricscCard)
    }
     */
    
    func configure(staticMetric: StatisticMetric) {
        self.statistiscCard = staticMetric.statisticCard!
        statusView.configure(staticMetric: staticMetric)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

protocol ReloadGraphProtocol {
    func reloadGraph(statisticMetric: StatisticMetric)
}
