//
//  TrafficStatsTableViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController
import RealmSwift

class TrafficStatsTableViewController: UITableViewController {
    
    var statisticsStore = StatisticsStore.getInstance()
    
    var reloadGraphDelegate: ReloadGraphProtocol!
    
    var pageIndex = 1 {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.tableView.alwaysBounceVertical = false
        self.tableView.separatorInset = .zero
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
    }
    
    func configure(card: StatisticsCard) {

    }
    
    internal func registerCellForTable() {
        tableView.register(TrafficVisits.self, forHeaderFooterViewReuseIdentifier: "trafficVisits")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getStatisticMetricsForCardAtPageIndex().count
    }
    
    internal func getStatisticMetricsForCardAtPageIndex() -> Results<StatisticMetric> {
        return statisticsStore.getStatisticMetricsForCardAtPageIndex(statisticsStore.getStatisticsCards()[0], pageIndex)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "trafficVisits", for: indexPath)
        let cell = UITableViewCell()
        let traffic = TrafficVisits()
        
        let rowIdx = indexPath.row
        
        traffic.configure(statisticMetric: getStatisticMetricsForCardAtPageIndex()[rowIdx])
        
        cell.addSubview(traffic)
        
        traffic.translatesAutoresizingMaskIntoConstraints = false
        traffic.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        traffic.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
        traffic.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
 
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Popmetrics.ReloadGraph, object: statisticsStore.getStatisticMetricsForCard(statisticsStore.getStatisticsCards()[0])[indexPath.row])
        
        
        if reloadGraphDelegate != nil {
            reloadGraphDelegate.reloadGraph(statisticMetric: statisticsStore.getStatisticMetricsForCard(statisticsStore.getStatisticsCards()[0])[indexPath.row])
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 8
        }
        return 115
    }

   
}
