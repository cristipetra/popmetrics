//
//  MainNavigationTabBarController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.selectedIndex = 0
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
