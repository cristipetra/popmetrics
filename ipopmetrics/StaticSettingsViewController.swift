//
//  StaticSettingsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 13/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StaticSettingsViewController: UITableViewController {

    let sectionTitles = ["USER IDENTITY", "NOTIFICATIONS", "BRAND IDENTITY", "SOCIAL ACCOUNTS", "DATA ACCOUNTS", "WEB OVERLAY"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = PopmetricsColor.tableBackground
        tableView.allowsSelection = false
        
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "SETTINGS", style: .plain, target: self, action: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 61
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView: UIView  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 61))
        var title: UILabel = UILabel()
        title.font = UIFont(name: FontBook.regular, size: 12)
        title.textColor = PopmetricsColor.textGraySettings
        title.text = sectionTitles[section]
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
        
        return contentView
    }

}
