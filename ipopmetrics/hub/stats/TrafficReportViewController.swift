//
//  TrafficReportViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TrafficReportViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var topPageControl: UIPageControl!
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var containerStats: UIView!
    
    let statsPageVC: StatsPageViewController = StatsPageViewController()
    let statisticStore = StatsStore.getInstance()
    
    internal var statisticsCard: StatisticsCard! {
        didSet {
            self.statsPageVC.statisticsCard = statisticsCard
            self.statsPageVC.numberOfPages = StatsStore.getInstance().getStatisticMetricsForCard(statisticsCard).count
        }
    }
    
    var pageIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        statusLbl.text = ""
        
        statsPageVC.indexDelegate = self
        addPageView()
        setUpPageControlViews()
     
    }
    
    func configure(statisticsCard: StatisticsCard) {
        self.statisticsCard = statisticsCard;
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width:self.scrollView.contentSize.width, height: self.containerView.frame.height)
    }
    
    func setUpPageControlViews() {
        topPageControl.tintColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        topPageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)

        let numberOfPages = statisticStore.getStatisticMetricsForCard(statisticsCard).count

    }
    
    func addPageView() {
        addChildViewController(statsPageVC)
        self.containerStats.addSubview(statsPageVC.view)
        statsPageVC.didMove(toParentViewController: self)
        
        statsPageVC.view.translatesAutoresizingMaskIntoConstraints = false
        statsPageVC.view.leftAnchor.constraint(equalTo: containerStats.leftAnchor, constant: 0).isActive = true
        statsPageVC.view.rightAnchor.constraint(equalTo: containerStats.rightAnchor, constant: 0).isActive = true
        
        statsPageVC.view.topAnchor.constraint(equalTo: containerStats.topAnchor, constant: 0).isActive = true
        statsPageVC.view.bottomAnchor.constraint(equalTo: containerStats.bottomAnchor, constant: 0).isActive = true
        statsPageVC.view.heightAnchor.constraint(equalToConstant: 970).isActive = true
        
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
}

extension TrafficReportViewController: IndexPageProtocol {
    
    func indexOfPage(index: Int) {
        self.topPageControl.currentPage = index
        self.pageIndex = index
    }
}

