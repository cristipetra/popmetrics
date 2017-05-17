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
        return
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check to see if the user didn't dismiss the intro
        // and that she/he still has unanswered items

        // let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
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
