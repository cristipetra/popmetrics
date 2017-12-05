//
//  StatsPageViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatsPageViewController: UIPageViewController {
    
    var statisticsCard: StatisticsCard! {
        didSet {
            self.numberOfPages = StatsStore.getInstance().getStatisticMetricsForCard(statisticsCard).count
        }
    }
    
    fileprivate lazy var viewControllerList : [StatsSlideViewController] = {
        let overviewVC: StatsSlideViewController = StatsSlideViewController()
        
        return [overviewVC]
    }()
    
    var numberOfPages: Int = 1 {
        didSet {
            updateViewControllerList()
        }
    }
    
    weak var indexDelegate: IndexPageProtocol?
    
    var currentPageIndex: Int = 0 {
        didSet {
            indexDelegate?.indexOfPage(index: currentPageIndex - 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        
        if let firstVC = viewControllerList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: { (finished) in
                //firstVC.configure(card: self.statisticsCard)
            })
        }
    }
    
    func updateViewControllerList() {
        viewControllerList = []
        for index in 1...self.numberOfPages {
            let statsVC: StatsSlideViewController = StatsSlideViewController()
            let metrics = StatsStore.getInstance().getStatisticMetricsForCard(statisticsCard)
            statsVC.configure(staticMetric: metrics[index-1])
            
            statsVC.pageIndex = index
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
    
    func nextViewController() {
        guard let currentVC = self.viewControllers?.first as? StatsSlideViewController else { return }
        guard let nextVC = dataSource?.pageViewController(self, viewControllerAfter: currentVC) as? StatsSlideViewController else { return }
        
        setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        currentPageIndex = nextVC.pageIndex
    }
    
    func previousViewController() {
        guard let currentVC = self.viewControllers?.first as? StatsSlideViewController else { return }
        guard let previousVC = dataSource?.pageViewController(self, viewControllerBefore: currentVC) as? StatsSlideViewController else { return }
        
        setViewControllers([previousVC], direction: .forward, animated: true, completion: nil)
        currentPageIndex = previousVC.pageIndex    
    }
}

extension StatsPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
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
                currentPageIndex = currentViewController.pageIndex
            }
        }
    }
}

protocol IndexPageProtocol: class {
    func indexOfPage(index: Int)
}

