//
//  SettingsGAViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsGAViewController: UITableViewController {

    var currentBrand: Brand?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tracker: UILabel!
    
    @IBOutlet weak var connectionEmailLabel: UILabel!
    @IBOutlet weak var connectionDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.name.text = currentBrand?.googleAnalytics?.name ?? "N/A"
        self.tracker.text = currentBrand?.googleAnalytics?.tracker ?? "N/A"
        
        if let date = currentBrand?.googleAnalytics?.connectionDate {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            self.connectionDateLabel.text = df.string(from: date)
        }
        self.connectionEmailLabel.text = currentBrand?.googleAnalytics?.connectionEmail ?? "N/A"
    }
    
    func setupNavigationBar() {
        
        let text = UIBarButtonItem(title: "GOOGLE ANALYTICS ACCOUNT", style: .plain, target: self, action: nil)
        text.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 17)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }



}
