//
//  CalendarViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 25/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController

class CalendarViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var sections: [FeedSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarCardNib = UINib(nibName: "CalendarCard", bundle: nil)
        tableView.register(calendarCardNib, forCellReuseIdentifier: "CalendarCard")
        
        fetchItems(silent: false)
    }
    
    func fetchItems(silent:Bool) {
        //        let path = Bundle.main.path(forResource: "sampleFeed", ofType: "json")
        //        let jsonData : NSData = NSData(contentsOfFile: path!)!
        FeedApi().getItems("58fe437ac7631a139803757e") { responseDict, error in
            
            if error != nil {
                let message = "An error has occurred. Please try again later."
                EZAlertController.alert("Error", message: message)
                return
            }
            if let code = responseDict?["code"] as? String {
                if "success" != code {
                    let message = responseDict?["message"] as! String
                    EZAlertController.alert("Error", message: message)
                    return
                }
            }
            else {
                EZAlertController.alert("Error", message: "An unexpected error has occured. Please try again later")
                return
            }
            let dict = responseDict?["data"]
            let code = responseDict?["code"] as! String
            let feedStore = FeedStore.getInstance()
            if "success" == code {
                if dict != nil {
                    feedStore.storeFeed(dict as! [String : Any])
                }
            }
            
            
            self.sections = feedStore.getFeed()
            
            if !silent { self.tableView.reloadData() }
        }
        
    }

}


extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCard", for: indexPath) as! CalendarCardViewCell
        return cell

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
