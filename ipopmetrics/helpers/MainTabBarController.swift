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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check to see if the user didn't dismiss the intro
        // and that she/he still has unanswered items

        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        homeNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationID") as! UINavigationController
        homeNavigationController.tabBarItem.title = "Home"
        homeNavigationController.tabBarItem.image = #imageLiteral(resourceName: "Icon_Home_Selected")
        
        let tabs: [UIViewController] = [homeNavigationController, calendarViewController]
        
        let calendarVC = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarID")
        calendarViewController.pushViewController(calendarVC, animated: false)
        calendarVC.tabBarItem.title = "Calendar"
        calendarVC.tabBarItem.image = #imageLiteral(resourceName: "iconCalendarTab")
        
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
}
