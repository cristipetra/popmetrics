//
//  BusinessContactDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/01/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class BusinessContactDetailsViewController: SettingsBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = PopmetricsColor.tableBackground
        
        setupNavigationBar()
        self.titleWindow = "CONTACT DETAILS"
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView: UIView  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        let title: UILabel = UILabel()
        title.font = UIFont(name: FontBook.regular, size: 13)
        title.textColor = PopmetricsColor.textGraySettings
        title.text = "PRIMARY LOCATION"
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        if section == 0 {
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        } else {
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
        }
        
        return contentView
    }

}
