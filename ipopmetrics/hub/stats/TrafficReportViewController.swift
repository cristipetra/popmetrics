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
    @IBOutlet weak var bottomPageControl: UIPageControl!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var bottomContainerView: UIView!
    
    let statsPageVC: StatsPageViewController = StatsPageViewController()
    let statisticStore = StatisticsStore.getInstance()
    
    internal var statisticsCard: StatisticsCard! {
        didSet {
            self.statsPageVC.statisticsCard = statisticsCard
            self.statsPageVC.numberOfPages = StatisticsStore.getInstance().getNumberOfPages(statisticsCard)
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
        //statusLbl.text = "Stats \(pageIndex) of \(statisticStore.getNumberOfPages(statisticsCard))"
        
        bottomLbl.textColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
        bottomLbl.font = UIFont(name: FontBook.semibold, size: 15)
        bottomLbl.textAlignment = .center
        
        topPageControl.tintColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        topPageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)
        
        bottomPageControl.tintColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        bottomPageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)
        bottomPageControl.numberOfPages = statisticStore.getNumberOfPages(self.statisticsCard)
        bottomLbl.text = statisticStore.getStatisticMetricsForCardAtPageIndex(statisticsCard, pageIndex)[0].pageName
        topPageControl.numberOfPages = statisticStore.getNumberOfPages(self.statisticsCard)
        
    }
    
    func addPageView() {
        addChildViewController(statsPageVC)
        self.containerView.addSubview(statsPageVC.view)
        statsPageVC.didMove(toParentViewController: self)
        
        statsPageVC.view.translatesAutoresizingMaskIntoConstraints = false
        statsPageVC.view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        statsPageVC.view.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        //statsPageVC.view.topAnchor.constraint(equalTo: chartVC.view.bottomAnchor,constant: 1).isActive = true
        statsPageVC.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        statsPageVC.view.heightAnchor.constraint(equalToConstant: 758).isActive = true
        
        //statsPageVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        statsPageVC.view.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        
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
    
    @IBAction func handlerPrevPage(_ sender: Any) {
        statsPageVC.previousViewController()
    }
    
    @IBAction func handlerNextPage(_ sender: Any) {
        print("next page")
        statsPageVC.nextViewController()
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TrafficReportViewController: IndexPageProtocol {
    
    func indexOfPage(index: Int) {
        self.bottomPageControl.currentPage = index
        self.topPageControl.currentPage = index
        self.pageIndex = index
        bottomLbl.text = statisticStore.getStatisticMetricsForCardAtPageIndex(statisticsCard, (pageIndex + 1))[0].pageName
        //statusLbl.text = "Stats \(index + 1) of \(statisticStore.getNumberOfPages(statisticsCard))"
    }
}

