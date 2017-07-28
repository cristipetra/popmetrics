//
//  CalendarViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 25/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController
import SwiftyJSON

class CalendarViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    ///fileprivate var sections: [FeedSection] = []
    fileprivate var sections: [CalendarSection] = []
    var reachedFooter = false
    var shouldMaximizeCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarCardNib = UINib(nibName: "CalendarCard", bundle: nil)
        tableView.register(calendarCardNib, forCellReuseIdentifier: "CalendarCard")
        
        let sectionHeaderNib = UINib(nibName: "CalendarHeader", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "headerCell")
        
        let sectionFooterNib = UINib(nibName: "CalendarFooter", bundle: nil)
        tableView.register(sectionFooterNib, forCellReuseIdentifier: "footerCell")
        
        let extendedCardNib = UINib(nibName: "CalendarCardMaximized", bundle: nil)
        tableView.register(extendedCardNib, forCellReuseIdentifier: "extendedCell")

        
        tableView.separatorStyle = .none
        
        fetchItemsLocally(silent: false)
    }
    
    func fetchItemsLocally(silent: Bool) {
        let path = Bundle.main.path(forResource: "sampleFeedCalendar", ofType: "json")
        let jsonData: NSData = NSData(contentsOfFile: path!)!
        let json = JSON(data: jsonData as Data)
        let calendarFeedStore = CalendarFeedStore.getInstance()
        for item in json["items"] {
            var calendarItem = CalendarItem()
            calendarItem.status = item.1["status"].description
            calendarItem.articleTitle = item.1["article_title"].description
            calendarItem.statusDate = Date(timeIntervalSince1970: Double(item.1["status_date"].description)!)
            calendarItem.articleImage = item.1["article_image"].description
            calendarItem.articleText = item.1["article_text"].description
            calendarItem.type = item.1["type"].description
            calendarItem.articleUrl = item.1["article_url"].description
            calendarItem.articleCategory = item.1["article_category"].description
            print(Double(item.1["status_date"].description));
            //calendarItem.articleCategory
            print(item.1["status"].description)
            //calendarFeedStore.app
            calendarFeedStore.storeItem(item: calendarItem)
        }
        
        calendarFeedStore.getFeed()
        
         self.sections = calendarFeedStore.getFeed()
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
            
            
            //self.sections = feedStore.getFeed()
            
            if !silent { self.tableView.reloadData() }
        }
        
    }

}


extension CalendarViewController: UITableViewDataSource, UITableViewDelegate, ChangeCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        let section = sections[sectionIdx]
        let item = section.items[rowIdx]
        
        if shouldMaximizeCell == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCard", for: indexPath) as! CalendarCardViewCell
            cell.configure(item)
            if indexPath.section == 0  {
                if indexPath.row == 0 {
                    cell.topStackViewVIew.isHidden = false
                } else {
                    cell.topStackViewVIew.isHidden = true
                }
            } else {
                cell.topStackViewVIew.isHidden = true
            }
            return cell
            
        } else {
            let maxCell = tableView.dequeueReusableCell(withIdentifier: "extendedCell", for: indexPath) as! CalendarCardMaximizedViewCell
            maxCell.configure(item)
            if indexPath.section == sections.count - 1 {
                if indexPath.row == (sections[indexPath.section].items.count - 1) {
                    maxCell.connectionStackView.isHidden = true
                    maxCell.notLastCell = false
                }
            }
            return maxCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CalendarHeaderViewCell
            if reachedFooter == true {
                headerCell.setupMinimizeView()
            }
            if shouldMaximizeCell == true {
                headerCell.minimizeLbl.text = "Minimize"
            }
            reachedFooter = false
            headerCell.maximizeDelegate = self
            return headerCell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if shouldMaximizeCell == false {
            return 130
        }
        return 367
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        reachedFooter = true
        if section == sections.last?.index {
            let footerCell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! CalendarFooterViewCell
            return footerCell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == sections.last?.index{
            return 80
        }
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if reachedFooter == true {
            if scrollView.contentOffset.y == 0 {
                
                print("SSS im on the top")
            }
        }
    }
    
    func maximizeCell() {
        if shouldMaximizeCell == true {
            shouldMaximizeCell = false
            tableView.reloadData()
            
        } else {
            shouldMaximizeCell = true
            tableView.reloadData()
        }   
    }
}
