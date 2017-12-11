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
    
    internal var statisticMetric: StatisticMetric
    
    var reloadGraphDelegate: ReloadGraphProtocol!
    
    let HEIGHT_CELL = 90
    let HEIGHT_HEADER = 65
//    var constraintHeightTable: NSLayoutConstraint!
    
    init(statisticMetric: StatisticMetric) {
        self.statisticMetric = statisticMetric
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
          self.tableView.estimatedSectionHeaderHeight = 65
//          self.tableView.sectionHeaderHeight = 65
//
        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionFooterHeight = 5
//          self.tableView.sectionFooterHeight = 0
        
//
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 90
//          self.tableView.rowHeight = 90
        
//
//
        registerCellForTable()
     
        //self.tableView.backgroundColor = PopmetricsColor.statisticsTableBackground
        self.tableView.backgroundColor = PopmetricsColor.orange
        self.tableView.alwaysBounceVertical = false
        self.tableView.separatorInset = .zero
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        self.tableView.separatorColor = PopmetricsColor.unselectedTabBarItemTint
        
        self.tableView.isScrollEnabled = false
//        self.tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 200)
//        self.tableViewHeightConstraint.isActive = true
//
        self.tableView.sizeToFit()
        
    }
    
    internal func registerCellForTable() {
        tableView.register(BreakdownViewCell.self, forCellReuseIdentifier: "trafficVisits")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {

        return statisticMetric.getBreakDownGroups().count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let breakdowns = statisticMetric.getBreakDownGroups()[section].breakdowns
        if let items = breakdowns {
            return items.count
        }
        return 0
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
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HEIGHT_CELL)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(HEIGHT_HEADER)
    }
   
}
