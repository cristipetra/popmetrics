//
//  TrafficStatus.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TrafficStatus: UIView {
    
    @IBOutlet var contentView: UIView!
    
    var tableView: TrafficStatsTableViewController = TrafficStatsTableViewController()
    let chartVC = UIStoryboard(name: "ChartStatistics", bundle: nil).instantiateViewController(withIdentifier: "ChartViewId") as! ChartViewController
    
    var statisticsCard: StatisticsCard!
    let statisticStore = StatisticsStore.getInstance()
    
    var pageIndex: Int = 1{
        didSet {
            tableView.pageIndex = pageIndex
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func configure(card: StatisticsCard, _ pageIndex: Int = 1) {
        statisticsCard = card
        tableView.configure(card: statisticsCard, pageIndex)
    }
    
    func setup() {
        
        Bundle.main.loadNibNamed("TrafficStatus", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addChartView()
        addTableView()
    }
    
    internal func addTableView() {
        
        self.addSubview(tableView.view)
        tableView.didMove(toParentViewController: self.parentViewController)
        
        tableView.view.translatesAutoresizingMaskIntoConstraints = false
        tableView.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        //tableView.view.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        tableView.view.topAnchor.constraint(equalTo: chartVC.view.bottomAnchor, constant: 1).isActive = true
        tableView.view.heightAnchor.constraint(equalToConstant: 345).isActive = true
        
        tableView.automaticallyAdjustsScrollViewInsets = false
    }
    
    internal func addChartView() {
        
        self.addSubview(chartVC.view)
        chartVC.didMove(toParentViewController: self.parentViewController)
        
        chartVC.barChart.backgroundFillColor = UIColor.white//UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        chartVC.view.translatesAutoresizingMaskIntoConstraints = false
        chartVC.view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        chartVC.view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        chartVC.view.topAnchor.constraint(equalTo: self.topAnchor,constant: 33).isActive = true
        chartVC.view.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
    }
    
}
