//
//  TrafficStatus.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class MetricReportView: UIScrollView {
    
    @IBOutlet var contentView: UIView!
    
    var breakdownsTableViewController: BreakdownsTableViewController!
    var chartVC: ChartViewController!
    
    var statisticMetric: StatisticMetric!
    
    let statisticStore = StatsStore.getInstance()
    

    
    init (metric: StatisticMetric) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.statisticMetric = metric
        
        self.chartVC = UIStoryboard(name: "ChartStatistics", bundle: nil).instantiateViewController(withIdentifier: "ChartViewId") as! ChartViewController
        self.chartVC.statisticMetric = self.statisticMetric
        
        self.addSubview(chartVC.view)
        // chartVC.didMove(toParentViewController: self.parentViewController)
        
        chartVC.view.translatesAutoresizingMaskIntoConstraints = false
        chartVC.view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        chartVC.view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        chartVC.view.topAnchor.constraint(equalTo: self.topAnchor,constant: 0).isActive = true
        chartVC.view.heightAnchor.constraint(equalToConstant: 320).isActive = true

        
        self.breakdownsTableViewController = BreakdownsTableViewController(statisticMetric: self.statisticMetric)
        self.addSubview(breakdownsTableViewController.view)
        
        breakdownsTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        breakdownsTableViewController.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        breakdownsTableViewController.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        breakdownsTableViewController.view.topAnchor.constraint(equalTo: chartVC.view.bottomAnchor, constant: 10).isActive = true
        breakdownsTableViewController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    
    func configure(staticMetric: StatisticMetric) {
        chartVC.configure(statisticMetric: staticMetric)
    }
    
    
}
