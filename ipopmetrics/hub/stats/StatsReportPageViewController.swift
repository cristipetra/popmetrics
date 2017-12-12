//
//  StatsPageViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatsReportPageViewController: UIPageViewController {
    
    var statisticsCard: StatisticsCard!
    var numberOfPages: Int = 0
    var currentPageIndex: Int = 0
    var pageSegueIdentifier = "Page"
    var nextViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let metrics = StatsStore.getInstance().getStatisticMetricsForCard(statisticsCard)
        self.numberOfPages = metrics.count
        
        let firstPage = createViewController(sender: self)
        setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        
    }
    
    public func createViewController(sender: Any?) -> StatsMetricPageContentViewController {
        performSegue(withIdentifier: pageSegueIdentifier, sender: sender)
        return nextViewController! as! StatsMetricPageContentViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Page" {
            let vc = segue.destination as! StatsMetricPageContentViewController
            let metrics = StatsStore.getInstance().getStatisticMetricsForCard(statisticsCard)
            vc.statsMetric = metrics[currentPageIndex]
            vc.pageIndex = currentPageIndex
        }
        
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



