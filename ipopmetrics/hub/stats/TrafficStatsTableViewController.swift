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
    
    internal var statisticCard: StatisticsCard!
    
    var reloadGraphDelegate: ReloadGraphProtocol!
    
    internal var pageIndex = 1 {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellForTable()
     
        self.tableView.alwaysBounceVertical = false
        self.tableView.separatorInset = .zero
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
    }
    
    func configure(card: StatisticsCard, _ pageIndex: Int) {
        self.statisticCard = card
        self.pageIndex = pageIndex
    }
    
    internal func registerCellForTable() {
        tableView.register(TrafficVisits.self, forCellReuseIdentifier: "trafficVisits")
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
        return statisticsStore.getStatisticMetricsForCardAtPageIndex(statisticCard, pageIndex)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trafficVisits", for: indexPath) as! TrafficVisits
        let rowIdx = indexPath.row
        cell.configure(statisticMetric: getStatisticMetricsForCardAtPageIndex()[rowIdx])
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let metrics = getStatisticMetricsForCardAtPageIndex()[indexPath.row]
        NotificationCenter.default.post(name: Notification.Popmetrics.ReloadGraph, object: metrics)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
   
}
