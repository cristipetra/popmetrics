//
//  GoogleMyBusinessPickerTableVC.swift
//  ipopmetrics
//
//  Created by Rares Pop on 27/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

final class GoogleMyBusinessPickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationsLabel: UILabel!
    
    func configure(account: MyBusinessAcccount) {
        
        nameLabel.text = account.accountName
        let count = account.locations.count
        var format = "%d locations"
        if count<1 {
            format = "%d location"
        }
        locationsLabel.text = String(format:format, account.locations.count)
    }
}


class GoogleMyBusinessPickerTableVC: UITableViewController {
  
    var accounts = [MyBusinessAcccount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configure(accounts: [MyBusinessAcccount]) {
        self.accounts = accounts
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoogleMyBusinessPickerTableViewCell", for: indexPath) as! GoogleMyBusinessPickerTableViewCell
        cell.configure(account:self.accounts[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = self.accounts[indexPath.row]
        let pvc = self.parent as! ConnectWizardGoogleMyBusinessVC
        pvc.didPickAccount(account)
    }


}
