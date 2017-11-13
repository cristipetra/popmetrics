//
//  SettingsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 10/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var settings: [String] = ["First Name", "Cell Phone Number", "Professional Email", "First Name", "Cell Phone Number", "Professional Email"]
    var settingsDetails: [String] = ["First Name", "Cell Phone Number", "Professional Email"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingsCell = UINib(nibName: "SettingsTableCell", bundle: nil)
        tableView.register(settingsCell, forCellReuseIdentifier: "settingsCell")
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self.title = "Settings"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(settings.count)
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        //let cell = UITableViewCell()
        cell.textLabel?.text = settings[indexPath.row]
        cell.accessoryType = .detailDisclosureButton
        
        print(settings[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
