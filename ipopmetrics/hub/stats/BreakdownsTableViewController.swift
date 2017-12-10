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

class BreakdownsTableViewController: UITableViewController {
    
    var statisticsStore = StatsStore.getInstance()
    
    internal var statisticCard: StatisticsCard!
    
    internal var statisticMetric: StatisticMetric!
    
    var reloadGraphDelegate: ReloadGraphProtocol!
    
    let HEIGHT_CELL = 90
    let HEIGHT_HEADER = 65
//    var constraintHeightTable: NSLayoutConstraint!
    
    private var pageIndex = 1 {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
//        self.tableView.sectionHeaderHeight = UITableView
//          self.tableView.estimatedSectionHeaderHeight = 65
          self.tableView.sectionHeaderHeight = 65
//
//        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedSectionFooterHeight = 5
          self.tableView.sectionFooterHeight = 5
        
//
//        self.tableView.rowHeight = UITableViewAutomaticDimension
          self.tableView.rowHeight = 90
        
//
//        self.tableView.estimatedRowHeight = 90
//
        registerCellForTable()
     
        //self.tableView.backgroundColor = PopmetricsColor.statisticsTableBackground
        self.tableView.backgroundColor = PopmetricsColor.orange
        self.tableView.alwaysBounceVertical = false
        self.tableView.separatorInset = .zero
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        self.tableView.separatorColor = PopmetricsColor.unselectedTabBarItemTint
        
        self.tableView.isScrollEnabled = false
//        constraintHeightTable = tableView.heightAnchor.constraint(equalToConstant: 200)
//        constraintHeightTable.isActive = true
//
        self.tableView.sizeToFit()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        if(statisticCard == nil) { return }
        
        let metrics = statisticsStore.getStatisticMetricsForCard(statisticCard)  // not returning proper number static metrics
        let sections = statisticMetric!.getBreakDownGroups()
        
        let value = CGFloat(metrics.count * HEIGHT_CELL) + CGFloat(3 * HEIGHT_HEADER)
        
        print("statistics")
        print("metrics:  \(metrics.count)")
        print("sections: \(sections.count)")
        print(value)
        
//        constraintHeightTable.constant = CGFloat(14
//            * HEIGHT_CELL) + CGFloat(sections.count * HEIGHT_HEADER) + 10
    }
    
    func configure(statisticMetric: StatisticMetric) {
        self.statisticMetric = statisticMetric
        self.statisticCard = statisticMetric.statisticCard!
        tableView.reloadData()
    }
    
    internal func registerCellForTable() {
        tableView.register(BreakdownViewCell.self, forCellReuseIdentifier: "trafficVisits")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "trafficVisits", for: indexPath) as! BreakdownViewCell
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
        
        if let group = statisticMetric.getBreakDownGroups()[section].group {
            title.text = group
        }
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let metrics = getStatisticMetricsForCardAtPageIndex()[indexPath.row]
        NotificationCenter.default.post(name: Notification.Popmetrics.ReloadGraph, object: metrics)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_CELL)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(HEIGHT_HEADER)
    }
   
}
