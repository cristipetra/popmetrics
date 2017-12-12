//
//  TrafficReportViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatsMetricPageContentViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var topPageControl: UIPageControl!
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var containerStats: UIView!
    
    let statisticStore = StatsStore.getInstance()
    
    var statsMetric: StatisticMetric!
    
    var pageIndex: Int = 1
    var numberOfPages: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        statusLbl.text = ""
        
        setUpPageControlViews()
    
    }
    
    
    func setUpPageControlViews() {
        topPageControl.tintColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        topPageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)

        topPageControl.numberOfPages = numberOfPages
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "embedBreakdowns" {
            let vc = segue.destination as! BreakdownsTableViewController
            vc.statisticMetric = self.statsMetric
        }
        else if segue.identifier == "embedChart" {
            let vc = segue.destination as! ChartViewController
            vc.statisticMetric = self.statsMetric
        }
        
        
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


