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

    let statsPageVC: StatsPageViewController = StatsPageViewController()
    let chartVC = UIStoryboard(name: "ChartStatistics", bundle: nil).instantiateViewController(withIdentifier: "ChartViewId") as! ChartViewController
    
    internal let insight = StatisticsInsight()
    
    internal var statisticsCard: StatisticsCard! {
        didSet {
            self.statsPageVC.statisticsCard = statisticsCard
            self.statsPageVC.numberOfPages = StatisticsStore.getInstance().getNumberOfPages(statisticsCard)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()

        addChartView()
        addPageView()
    }
    
    func configure(statisticsCard: StatisticsCard) {
        self.statisticsCard = statisticsCard;
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width:self.scrollView.contentSize.width, height: self.containerView.frame.height)
    }
    
    func addChartView() {
        addChildViewController(chartVC)
        self.containerView.addSubview(chartVC.view)
        chartVC.didMove(toParentViewController: self)
        //chartVC.containerVIew.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        chartVC.barChart.backgroundFillColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        //chartVC.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.width, height: 400)
        chartVC.view.translatesAutoresizingMaskIntoConstraints = false
        chartVC.view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        chartVC.view.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        chartVC.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        chartVC.view.heightAnchor.constraint(equalToConstant: 360).isActive = true
        
        chartVC.containerView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        chartVC.barChart.backgroundFillColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        chartVC.view.translatesAutoresizingMaskIntoConstraints = false
        chartVC.view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        chartVC.view.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        chartVC.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        chartVC.view.heightAnchor.constraint(equalToConstant: 320).isActive = true
        
    }
    
    func addPageView() {
        addChildViewController(statsPageVC)
        self.containerView.addSubview(statsPageVC.view)
        statsPageVC.didMove(toParentViewController: self)
        statsPageVC.view.backgroundColor = UIColor.darkGray
        
        statsPageVC.view.translatesAutoresizingMaskIntoConstraints = false
        statsPageVC.view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        statsPageVC.view.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        statsPageVC.view.topAnchor.constraint(equalTo: chartVC.view.bottomAnchor,constant: 1).isActive = true
        statsPageVC.view.heightAnchor.constraint(equalToConstant: 562).isActive = true
        
        statsPageVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
    }
    
    func addInsight() {
        self.containerView.addSubview(insight)
        insight.frame = self.containerView.bounds
        
        insight.setup()
        insight.translatesAutoresizingMaskIntoConstraints = false
        insight.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        insight.topAnchor.constraint(equalTo: statsPageVC.view.bottomAnchor).isActive = true
        insight.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        insight.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        insight.heightAnchor.constraint(equalToConstant: 389).isActive = true

        statsPageVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

    }
    
    func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Traffic Report", style: .plain, target: self, action: nil)
        text.tintColor = PopmetricsColor.darkGrey

        let titleFont = UIFont(name: FontBook.bold, size: 18)
        text.setTitleTextAttributes([NSFontAttributeName: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false

        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "iconCalLeftBold"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black

        
    }
    
    func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    

}
