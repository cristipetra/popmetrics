//
//  TrafficReportViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatsMetricPageContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topPageControl: UIPageControl!
    @IBOutlet weak var statusLbl: UILabel!

    @IBOutlet weak var tableView: UITableView!
    
    let statisticStore = StatsStore.getInstance()
    
    var statsMetric: StatisticMetric!
    
    var pageIndex: Int = 1
    var numberOfPages: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        statusLbl.text = ""
        
        setUpPageControlViews()
        
        tableView.register(BreakdownViewCell.self, forCellReuseIdentifier: "BreakdownCell")
        
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 65
        
        tableView.sectionFooterHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionFooterHeight = 5

//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 90
        tableView.estimatedRowHeight = 90
        
        
        tableView.backgroundColor = PopmetricsColor.statisticsTableBackground

        tableView.alwaysBounceVertical = false

        tableView.separatorColor = PopmetricsColor.unselectedTabBarItemTint
    
    }
    
    
    func setUpPageControlViews() {
        topPageControl.tintColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        topPageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)

        topPageControl.numberOfPages = numberOfPages
    }
    
    
    private func setUpNavigationBar() {
        let titleWindow = "WEBSITE REPORT"
        
        let titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: nil)
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        leftButtonItem.tintColor = PopmetricsColor.darkGrey
        
        self.navigationItem.leftBarButtonItems = [leftButtonItem, titleButton]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Table delegates and data source
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return statsMetric.getBreakDownGroups().count + 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 260
        }
        else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        }
        else {
            return 65
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        let breakdowns = statsMetric.getBreakDownGroups()[section-1].breakdowns
        if let items = breakdowns {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! ChartViewCell
            cell.configure(statisticMetric: statsMetric)
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BreakdownCell", for: indexPath) as! BreakdownViewCell
            let rowIdx = indexPath.row
            
            let groups = statsMetric.getBreakDownGroups()[indexPath.section-1]
            guard let _ = groups.breakdowns else {
                return cell
            }
        
            let metricBreakdown: MetricBreakdown = groups.breakdowns![rowIdx]
            
            cell.configure(metricBreakdown: metricBreakdown, statisticMetric: statsMetric)
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView() // empty
        }
        
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
        
        if let group = statsMetric.getBreakDownGroups()[section-1].group {
            title.text = group
        }
        
        return headerView
    }
    
   
    
}



