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
        statsPageVC.view.heightAnchor.constraint(equalToConstant: 778).isActive = true
        
        statsPageVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
    }
    
    func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Traffic Report", style: .plain, target: self, action: nil)
        text.tintColor = PopmetricsColor.darkGrey
        
        let titleFont = UIFont(name: FontBook.bold, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "iconCalLeftBold"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
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
        statusLbl.text = "Stats \(index + 1) of \(statisticStore.getNumberOfPages(statisticsCard))"
    }
}

