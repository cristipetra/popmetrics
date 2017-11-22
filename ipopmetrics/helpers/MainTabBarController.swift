//
//  MainNavigationTabBarController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var homeNavigationController: UINavigationController!;
    var calendarViewController: UINavigationController = UINavigationController();
    var todoNavigationViewController: UINavigationController = UINavigationController();
    var statisticsNavigationViewController: UINavigationController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check to see if the user didn't dismiss the intro
        // and that she/he still has unanswered items
        
        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        self.tabBar.tintColor = PopmetricsColor.textGrey
        self.tabBar.unselectedItemTintColor = PopmetricsColor.unselectedTabBarItemTint
        
        homeNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationID") as! UINavigationController
        homeNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        homeNavigationController.tabBarItem.image = UIImage(named: TabIcons.Active.active_home.rawValue)?.withRenderingMode(.alwaysOriginal)
        
        let todoVC = UIStoryboard(name: "Todo", bundle: nil).instantiateViewController(withIdentifier: "todo")
        todoNavigationViewController.pushViewController(todoVC, animated: false)
        todoVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        todoVC.tabBarItem.image = UIImage(named: TabIcons.Inactiv.inactive_todo.rawValue)?.withRenderingMode(.alwaysOriginal)
        
        let calendarVC = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarID")
        calendarViewController.pushViewController(calendarVC, animated: false)
        calendarVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        calendarVC.tabBarItem.image = UIImage(named: TabIcons.Inactiv.inactive_calendar.rawValue)?.withRenderingMode(.alwaysOriginal)
        
        let statisticsVC = UIStoryboard(name: "Statistics", bundle: nil).instantiateViewController(withIdentifier: "statistics")
        
        statisticsNavigationViewController.pushViewController(statisticsVC, animated: false)
        statisticsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        statisticsVC.tabBarItem.image = UIImage(named: TabIcons.Inactiv.inactive_statistics.rawValue)?.withRenderingMode(.alwaysOriginal)
        
        let tabs: [UIViewController] = [homeNavigationController, todoNavigationViewController, calendarViewController, statisticsNavigationViewController]
        self.setViewControllers(tabs, animated: false)
    }
    
    /*
     override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
     if (self.viewControllers?.first as? UINavigationController)?.viewControllers.last is PropertyCaptureViewController {
     return UIInterfaceOrientationMask.AllButUpsideDown
     }
     return UIInterfaceOrientationMask.Portrait
     }
     
     override func shouldAutorotate() -> Bool {
     return true
     }
     */
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("the selected index is : \(tabBar.items?.index(of: item))")
        let selectedIndex = tabBar.items?.index(of: item)
        let tabInfo = MainTabInfo.getInstance()
        tabInfo.lastItemIndex = tabInfo.currentItemIndex
        tabInfo.currentItemIndex = selectedIndex!
        
        setTabItemImages()
    }
    
    func setTabItemImages() {
        
        if let count = self.tabBar.items?.count {
            for i in 0...(count-1) {
                let imageNameForSelectedState   = TabIcons.Active.allActive[i]
                let imageNameForUnselectedState = TabIcons.Inactiv.allInactive[i]
                
                self.tabBar.items?[i].selectedImage = UIImage(named: imageNameForSelectedState.rawValue)?.withRenderingMode(.alwaysOriginal)
                self.tabBar.items?[i].image = UIImage(named: imageNameForUnselectedState.rawValue)?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
    
}

enum TabIcons {
    
    enum Active: String {
        case active_home = "active_home"
        case active_todo = "active_todo"
        case active_calendar = "active_calendar"
        case active_statistics = "active_statistics"
        
        static let allActive = [active_home, active_todo, active_calendar, active_statistics]
    }
    
    enum Inactiv: String {
        case inactive_home = "inactive_home"
        case inactive_todo = "inactive_todo"
        case inactive_calendar = "inactive_calendar"
        case inactive_statistics = "inactive_statistics"
        
        static let allInactive = [inactive_home, inactive_todo, inactive_calendar, inactive_statistics]
    }
    
}
