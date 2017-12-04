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
    
    internal var statisticMetric: StatisticMetric!
    
    var reloadGraphDelegate: ReloadGraphProtocol!
    
    private var pageIndex = 1 {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellForTable()
     
        self.tableView.backgroundColor = PopmetricsColor.statisticsTableBackground
        self.tableView.alwaysBounceVertical = false
        self.tableView.separatorInset = .zero
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        self.tableView.separatorColor = PopmetricsColor.unselectedTabBarItemTint
        
    }
    
    func configure(card: StatisticsCard, _ pageIndex: Int) {
      
    }
    
    func configure(statisticMetric: StatisticMetric) {
        self.statisticMetric = statisticMetric
        self.statisticCard = statisticMetric.statisticCard!
    }
    
    internal func registerCellForTable() {
        tableView.register(TrafficVisits.self, forCellReuseIdentifier: "trafficVisits")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let _ = statisticMetric else {
            return 0
        }
        return statisticMetric!.getBreakDownGroups().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let breakdowns = statisticMetric.getBreakDownGroups()[section].breakdowns
        if let items = breakdowns {
            return items.count
        }
        return 0
    }
    
    internal func getStatisticMetricsForCardAtPageIndex() -> Results<StatisticMetric> {
        return statisticsStore.getStatisticMetricsForCardAtPageIndex(statisticCard, pageIndex)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trafficVisits", for: indexPath) as! TrafficVisits
        let rowIdx = indexPath.row

        let groups = statisticMetric.getBreakDownGroups()[indexPath.section]
        guard let _ = groups.breakdowns else {
            return cell
        }
        
        let metricBreakdown: MetricBreakdown = groups.breakdowns![rowIdx]
        
        cell.configure(metricBreakdown: metricBreakdown, statisticMetric: statisticMetric)
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = PopmetricsColor.unselectedTabBarItemTint
        headerView.addSubview(topDividerView)
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 0).isActive = true
        topDividerView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: 0).isActive = true
        topDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topDividerView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true
        
        let title = UILabel()
        title.font = UIFont(name: FontBook.extraBold, size: 24)
        title.textColor = PopmetricsColor.darkGrey
        headerView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 25).isActive = true
        title.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).isActive = true
        title.text = statisticMetric.getBreakDownGroups()[section].group!
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let metrics = getStatisticMetricsForCardAtPageIndex()[indexPath.row]
        NotificationCenter.default.post(name: Notification.Popmetrics.ReloadGraph, object: metrics)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
   
}
