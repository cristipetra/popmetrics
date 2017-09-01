//
//  StatsPageViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatsPageViewController: UIPageViewController {
    
    fileprivate lazy var viewControllerList : [StatsSlideViewController] = {
        let overviewVC: StatsSlideViewController = StatsSlideViewController()
        let engagementVC: StatsSlideViewController = StatsSlideViewController()
        let typesVC: StatsSlideViewController = StatsSlideViewController()
        
        return [overviewVC, engagementVC, typesVC]
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        if let firstVC = viewControllerList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: { (finished) in
                firstVC.configure()
            })
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
            statsVC.indexOfPage = indexOfVC
            return nil
        }
        
        guard viewControllerList.count > previousIndex else {
            return nil
        }
        
        statsVC.indexOfPage = indexOfVC
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
            statsVC.indexOfPage = currentVCIndex
            return nil
        }
        
        guard viewControllerList.count > nextIndex else {
            return nil
        }
        
        statsVC.indexOfPage = currentVCIndex
        return viewControllerList[nextIndex]
    }
}
