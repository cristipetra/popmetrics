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

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var leftArrowBtn: UIButton!
    @IBOutlet weak var rightArrowBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topPageControl: UIPageControl!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var bottomPageControllView: UIView! 
    
    
    var tableView: TrafficStatsTableViewController = TrafficStatsTableViewController()
    let chartVC = UIStoryboard(name: "ChartStatistics", bundle: nil).instantiateViewController(withIdentifier: "ChartViewId") as! ChartViewController
    
    var statisticsCard: StatisticsCard!
    let statisticStore = StatisticsStore.getInstance()
    
    var pageIndex: Int = 1{
        didSet {
            tableView.pageIndex = pageIndex
            updateInfo()
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
    
    internal func updateInfo() {
        updateStatusLabelText()
        bottomLabel.text = statisticStore.getStatisticMetricsForCardAtPageIndex(statisticsCard, pageIndex)[0].pageName
        
        let numberOfPages = statisticStore.getNumberOfPages(statisticsCard)
        pageControl.numberOfPages = numberOfPages
        topPageControl.numberOfPages = numberOfPages
        
        pageControl.currentPage = pageIndex - 1
        topPageControl.currentPage = pageIndex - 1
    }
    
    internal func updateStatusLabelText() {
        statusLabel.text = "Stats \(pageIndex) of \(statisticStore.getNumberOfPages(statisticsCard)) "
    }
    
    func setup() {
        
        Bundle.main.loadNibNamed("TrafficStatus", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        bottomLabel.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        bottomLabel.font = UIFont(name: FontBook.semibold, size: 15)
        bottomLabel.textAlignment = .center
        
        self.backgroundColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 0.5)
        
        topPageControl.tintColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        topPageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)
        
        pageControl.tintColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)
     
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
        
        chartVC.containerView.backgroundColor = UIColor.white//UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        chartVC.barChart.backgroundFillColor = UIColor.white//UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        chartVC.view.translatesAutoresizingMaskIntoConstraints = false
        chartVC.view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        chartVC.view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        chartVC.view.topAnchor.constraint(equalTo: self.topAnchor,constant: 33).isActive = true
        chartVC.view.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
    }
    
}
