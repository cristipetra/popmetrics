//
//  FeedTableViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import GoogleSignIn
import MGSwipeTableCell
import DGElasticPullToRefresh

class HomeHubViewController: BaseTableViewController, GIDSignInUIDelegate {
    
    fileprivate var sharingInProgress = false
    
    fileprivate var sections: [FeedSection] = []
    
    fileprivate var completed = 0
    fileprivate var total = 100
    
    fileprivate var selectedIndexPath: IndexPath?
    
    var requiredActionHandler = RequiredActionHandler()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self

        
        // Style elements
        navigationItem.title = "Feed"
//        tableView.separatorStyle = .none
        
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:NSNotification.Name(rawValue: "SyncNotification"), object:nil, queue:nil, using:catchSyncNotifications)
        
        let requiredActionCardNib = UINib(nibName: "RequiredActionCard", bundle: nil)
        tableView.register(requiredActionCardNib, forCellReuseIdentifier: "RequiredActionCard")
        
        let actionHistoryCardNib = UINib(nibName: "ActionHistoryCard", bundle: nil)
        tableView.register(actionHistoryCardNib, forCellReuseIdentifier: "ActionHistoryCard")
        
        let articleOfInterestCardNib = UINib(nibName: "ArticleOfInterestCard", bundle: nil)
        tableView.register(articleOfInterestCardNib, forCellReuseIdentifier: "ArticleOfInterestCard")
        
        let statsSummaryCardNib = UINib(nibName: "StatsSummaryCard", bundle: nil)
        tableView.register(statsSummaryCardNib, forCellReuseIdentifier: "StatsSummaryCard")
        
        self.fetchItems()
        
        
        
        
//        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
//        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
//        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
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
            
            
//            self?.tableView.dg_stopLoading()
//            }, loadingView: loadingView)
//        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
//        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        
        
    }
    
    func fetchItems() {
        let path = Bundle.main.path(forResource: "sampleFeed", ofType: "json")
        let jsonData : NSData = NSData(contentsOfFile: path!)!
        
        let dict = try! JSONSerialization.jsonObject(with: jsonData as Data, options: []) as! [String:Any]
        
        let feedStore = FeedStore.getInstance()
        feedStore.storeFeed(dict)
        self.sections = feedStore.getFeed()
        
    }
    
    
    fileprivate func reloadData() {
        // self.fetchItems()
        
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
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
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        let section = sections[sectionIdx]
        let item = section.items[rowIdx]
        
        
        switch(item.type) {
            case "required_action":
                let cell = tableView.dequeueReusableCell(withIdentifier: "RequiredActionCard", for: indexPath) as! RequiredActionViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell
            
            case "action_history":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActionHistoryCard", for: indexPath) as! ActionHistoryViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell
            
            case "article_of_interest":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleOfInterestCard", for: indexPath) as! ArticleOfInterestViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell
            
            case "stats_summary":
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatsSummaryCard", for: indexPath) as! StatsSummaryViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell

            
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "RequiredActionCard", for: indexPath) as! RequiredActionViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell

        }
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if SID_DETAILS_NAV_VC == segue.identifier {
//            let dest = segue.destination as! PropertyDetailsNavigationController
//            dest.property = getPropertyForIndexPath(selectedIndexPath!)
//        }
    }

    
    fileprivate func getCellHeight() -> CGFloat {
        let a =  CGFloat(((tableView.frame.width * 9.0) / 16.0) + 16) // 16 is the padding
        return 340
        // return a
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
    
    
    ///
    
    @objc func handleRequiredAction(_ sender : UIButton){
        print("handling required action")
    }
    
    
    
    
}
