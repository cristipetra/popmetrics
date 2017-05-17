//
//  FeedTableViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import DGElasticPullToRefresh

class HomeHubViewController: BaseTableViewController {
    
    fileprivate var sharingInProgress = false
    
    fileprivate var items = [[String:Any]]()
    
    fileprivate var completed = 0
    fileprivate var total = 100
    
    fileprivate var selectedIndexPath: IndexPath?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style elements
        navigationItem.title = "Feed"
        tableView.separatorStyle = .none
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:NSNotification.Name(rawValue: "SyncNotification"), object:nil, queue:nil, using:catchSyncNotifications)
        
        
        self.fetchItems()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Add your logic here
            // Do not forget to call dg_stopLoading() at the end
            
//            FeedApi().getItems(sinceDate: Date()){responseDict, error in
//                if error != nil {
//                    let message = "An error has occurred. Please try again later."
//                    self?.presentAlertWithTitle("Error", message: message)
//                    return
//                }
//                let success = responseDict?["success"] as! Bool
//                if (!success) {
//                    let message = responseDict?["message"] as! String
//                    self?.presentAlertWithTitle("Authentication failed.", message:message)
//                    return
//                }
//                
//                let store = FeedItemsStore.getInstance()
//                let itemsDict = responseDict?["items"] as! [[String:Any]]
//                if itemsDict != nil {
//                    for itemDict in itemsDict {
//                        var feedItem: FeedItem? = nil
//                        
//                        if let itemId = itemDict["id"] as? String {
//                            if let existingItem = store.findItemWithSrvId(itemId) {
//                                feedItem = existingItem
//                            }
//                        }
//                        if feedItem == nil {
//                            feedItem = store.createFeedItem(dict: itemDict)
//                        } else {
//                            _ = store.updateFeedItem(item: feedItem!, dict: itemDict)
//                        }
//                        
//                    }
//                store.saveState()
//                }
//            }
            
            
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        
        
    }
    
    func fetchItems() {
        let path = Bundle.main.path(forResource: "sampleFeed", ofType: "json")
        let jsonData : NSData = NSData(contentsOfFile: path!)!
        
        self.items = try! JSONSerialization.jsonObject(with: jsonData as Data, options: []) as! [[String:Any]]
        
    }
    
    
    fileprivate func reloadData() {
        self.fetchItems()
        
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
        
        if items.count > 0 {
            showNoFeeds(false)
        } else {
            showNoFeeds(true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func catchSyncNotifications(notification:Notification) -> Void {
        
        self.hideProgressIndicator()
        guard let userInfo = notification.userInfo,
            let success    = userInfo["success"] as? Bool
            // let property  = userInfo["property"] as? Property
            else {
                print("Incomplete user info found in PropertySync notification")
                return
        }
        
        if !success {
            self.presentAlertWithTitle("Error", message: "Home synchronization with the cloud has failed")
        }
        
//        if self.sharingInProgress {
//            self.sharingInProgress = false
//            let textToShare = PropertyUtils.getPropertyShareMessage(property)
//            let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
//            self.present(activityVC, animated: true, completion: nil)
//            return
//        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 1
        if !hasRequiredActions() {
            sections = 2
        }
        return sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasRequiredActions() && section == 0 {
            return 1
        }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 && !hasRequiredActions() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableActionRequiredTableViewCell") as! FeedTableActionRequiredTableViewCell
            cell.selectionStyle = .none
            cell.completion = (completed, total)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        cell.selectionStyle = .none
        cell.rightButtons = createSwipeButtons()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 && !hasRequiredActions() {
            // take action
            
        }
        
        selectedIndexPath = indexPath
//        performSegue(withIdentifier: SID_DETAILS_NAV_VC, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if SID_DETAILS_NAV_VC == segue.identifier {
//            let dest = segue.destination as! PropertyDetailsNavigationController
//            dest.property = getPropertyForIndexPath(selectedIndexPath!)
//        }
    }

    
    fileprivate func getCellHeight() -> CGFloat {
        return CGFloat(((tableView.frame.width * 9.0) / 16.0) + 16) // 16 is the padding
    }
    
    fileprivate func showNoFeeds(_ state: Bool) {
        if state {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            label.text = "No feeds available as of yet"
            label.textColor = PopmetricsColor.textDark
            label.textAlignment = .center
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }
    
    fileprivate func hasRequiredActions() -> Bool {
        return (completed == total)
    }
    
    fileprivate func createSwipeButtons() -> [MGSwipeButton] {
        let deleteBtn = MGSwipeButton(
            title: "Action",
            icon: UIImage(named: "ic_delete_white"),
            backgroundColor: PopmetricsColor.redMedium,
            callback: { (sender: MGSwipeTableCell!) -> Bool in
                
                let alert = UIAlertController(title: "Action 1?",
                                              message: "Are you sure ? ... ", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (alert: UIAlertAction!) -> Void in
                    
//                    let cell =  sender as! FeedTableViewCell
//                    cell.property.deletedAt = NSDate()
//                    PropertiesStore.getInstance().saveState()
                }
                let noAction = UIAlertAction(title: "No", style: .default) { (alert: UIAlertAction!) -> Void in
                    //print("You pressed Cancel")
                }
                
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                self.present(alert, animated: true, completion:nil)
                
                return true
        }
        )
        deleteBtn.centerIconOverText()
        deleteBtn.setPadding(8)
        
        let shareBtn = MGSwipeButton(
            title: "Action2",
            icon: UIImage(named: "ic_share_white"),
            backgroundColor: PopmetricsColor.blueMedium,
            callback: { (sender: MGSwipeTableCell!) -> Bool in
                print("Pressed Share")
                return true
                
        }
        )
        shareBtn.centerIconOverText()
        shareBtn.setPadding(8)
        
        //        let reviewBtn = MGSwipeButton(
        //            title: "Review",
        //            icon: UIImage(named: "ic_favorite_white"),
        //            backgroundColor: HomzenColor.grayMedium,
        //            callback: { (sender: MGSwipeTableCell!) -> Bool in
        //                print("Pressed Review")
        //                return true
        //        }
        //        )
        //        reviewBtn.centerIconOverText()
        //        reviewBtn.setPadding(8)
        
        return [deleteBtn, shareBtn]
    }
    
    
    
}
