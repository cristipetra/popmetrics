//
//  AboutViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 03/01/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {

    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = PopmetricsColor.tableBackground
        setUpNavigationBar()
        
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func updateView() {
        versionLabel.text = UIApplication.versionBuild()
        contactLabel.text = Config.mailSettings
    }
    
    private func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "ABOUT POPMETRICS", style: .plain, target: self, action: nil)
        text.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.dismissToDirection(direction: .left)
    }
    
}
