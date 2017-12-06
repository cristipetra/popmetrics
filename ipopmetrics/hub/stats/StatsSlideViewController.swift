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
    
    internal var statistiscCard: StatisticsCard! {
        didSet {
            statusView.configure(card: statistiscCard, pageIndex)
        }
    }
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configure(card: StatisticsCard, _ pageIndex: Int = 1) {
        self.statistiscCard = card
        self.pageIndex = pageIndex
        statusView.configure(card: statistiscCard, pageIndex)
    }
    
    func configure(staticMetric: StatisticMetric) {
        statusView.configure(staticMetric: staticMetric)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
}

protocol ReloadGraphProtocol {
    func reloadGraph(statisticMetric: StatisticMetric)
}
