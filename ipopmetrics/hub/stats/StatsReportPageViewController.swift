//
//  StatsPageViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatsReportPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var statisticsCard: StatisticsCard!
    var viewControllerList: [StatsSlideViewController]!
    var numberOfPages: Int = 0
    var currentPageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        self.updateViewControllerList()
        
        if let firstVC = viewControllerList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: { (finished) in
            })
        }
    }
    
    func updateViewControllerList() {
        viewControllerList = []
        let metrics = StatsStore.getInstance().getStatisticMetricsForCard(statisticsCard)
        for index in 1...self.numberOfPages {
            let statsVC: StatsSlideViewController = StatsSlideViewController()
            statsVC.statsMetric = metrics[index-1]
            viewControllerList.append(statsVC)
        }
    }
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let statsVC : StatsSlideViewController = viewController as? StatsSlideViewController else {
            return nil
        }
        
        
        guard let indexOfVC = viewControllerList.index(of: statsVC) else {
            return nil
        }
        
        let previousIndex = indexOfVC - 1
        
        if previousIndex < 0 {
            
            return nil
        }
        
        guard viewControllerList.count > previousIndex else {
            return nil
        }
        
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let statsVC : StatsSlideViewController = viewController as? StatsSlideViewController else {
            return nil
        }
        
        guard let currentVCIndex = viewControllerList.index(of: statsVC) else {
            return nil
        }
        
        let nextIndex = currentVCIndex + 1
        
        guard viewControllerList.count != nextIndex else {
            return nil
        }
        
        guard viewControllerList.count > nextIndex else {
            return nil
        }
        
        return viewControllerList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0] as? StatsSlideViewController {
                // currentPageIndex = currentViewController.pageIndex
            }
        }
    }
}

