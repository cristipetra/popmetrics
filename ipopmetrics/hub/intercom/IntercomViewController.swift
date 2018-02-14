//
//  IntercomViewController.swift
//  Live
//
//  Created by Cristian Petra on 12/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import Intercom


class IntercomViewController: UIViewController {
    
    internal var leftButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Intercom.presentMessenger()
        self.tabBarController?.selectedIndex = 0
    }
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Messages", style: .plain, target: self, action: #selector(handlerClickMenu))
        text.tintColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1.0)
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .selected)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "Icon_Menu"), style: .plain, target: self, action: #selector(handlerClickMenu))

        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc func handlerClickMenu() {
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewNames.SBID_MENU_VC) as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
    }

}

extension IntercomViewController: UIViewControllerTransitioningDelegate{

}
