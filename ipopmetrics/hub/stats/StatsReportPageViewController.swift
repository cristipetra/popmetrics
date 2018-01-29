//
//  StatsPageViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatsReportPageViewController: UIPageViewController {
    
    var statisticsCard: StatsCard!
    var numberOfPages: Int = 0
    var currentPageIndex: Int = 0
    var pageSegueIdentifier = "Page"
    var nextViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = PopmetricsColor.borderButton
        self.dataSource = self
        
        let metrics = StatsStore.getInstance().getStatsMetricsForCard(statisticsCard)
        self.numberOfPages = metrics.count
        
        let firstPage = createViewController(sender: self)
        setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        
        setupNavigationWithBackButton()
    }
    
    public func createViewController(sender: Any?) -> StatsMetricPageContentViewController {
        performSegue(withIdentifier: pageSegueIdentifier, sender: sender)
        return nextViewController! as! StatsMetricPageContentViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Page" {
            let vc = segue.destination as! StatsMetricPageContentViewController
            let metrics = StatsStore.getInstance().getStatsMetricsForCard(statisticsCard)
            vc.numberOfPages = numberOfPages
            vc.statsMetric = metrics[currentPageIndex]
            vc.pageIndex = currentPageIndex
        }
        
    }

    func setupNavigationWithBackButton() {
        
        let titleWindow = "WEBSITE REPORT"
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 5
        
        let titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: #selector(handlerClickBack))
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .selected)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        leftButtonItem.tintColor = PopmetricsColor.darkGrey
        
        self.navigationItem.leftBarButtonItems = [leftSpace, leftButtonItem, titleButton]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
// MARK: UIPageViewControllerDataSource

extension StatsReportPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if currentPageIndex < numberOfPages - 1 {
            currentPageIndex += 1
        } else {
            return nil
        }
        
        return  createViewController(sender: self)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if currentPageIndex > 0 {
            currentPageIndex -= 1
        } else {
            return nil
        }
       
        return createViewController(sender: self)
    }
    
}

public class PageSegue: UIStoryboardSegue {
    
    public override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        if let pageViewController = source as? StatsReportPageViewController {
            pageViewController.nextViewController =
                destination as? StatsMetricPageContentViewController
        }
    }
    
    public override func perform() {}
    
}



