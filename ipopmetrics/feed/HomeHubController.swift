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
    
    var requiredActionHandler = RequiredActionHandler()
    
    var firstCellSection = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
      
        // Style elements
        navigationItem.title = "Feed"
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:NSNotification.Name(rawValue: "CardActionNotification"), object:nil, queue:nil, using:catchCardActionNotification)
      
        let sectionHeaderNib = UINib(nibName: "HeaderCardCell", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "headerCell")
        
        let requiredActionCardNib = UINib(nibName: "RequiredActionCard", bundle: nil)
        tableView.register(requiredActionCardNib, forCellReuseIdentifier: "RequiredActionCard")
        
        let actionHistoryCardNib = UINib(nibName: "ActionHistoryCard", bundle: nil)
        tableView.register(actionHistoryCardNib, forCellReuseIdentifier: "ActionHistoryCard")
        
        let articleOfInterestCardNib = UINib(nibName: "ArticleOfInterestCard", bundle: nil)
        tableView.register(articleOfInterestCardNib, forCellReuseIdentifier: "ArticleOfInterestCard")
        
        let insightCardNib = UINib(nibName: "InsightCard", bundle: nil)
        tableView.register(insightCardNib, forCellReuseIdentifier: "InsightCard")
        
        let statsSummaryCardNib = UINib(nibName: "StatsSummaryCard", bundle: nil)
        tableView.register(statsSummaryCardNib, forCellReuseIdentifier: "StatsSummaryCard")
        
        let bestCourseCardNib = UINib(nibName: "BestCourseCard", bundle: nil)
        tableView.register(bestCourseCardNib, forCellReuseIdentifier: "BestCourseCard")
        
        let actionCardNib = UINib(nibName: "ActionCard", bundle: nil)
        tableView.register(actionCardNib, forCellReuseIdentifier: "ActionCard")
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.fetchItems(silent:false)
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        fetchItems(silent: false)
        
    }
    
    func fetchItems(silent:Bool) {
//        let path = Bundle.main.path(forResource: "sampleFeed", ofType: "json")
//        let jsonData : NSData = NSData(contentsOfFile: path!)!
        FeedApi().getItems("58fe437ac7631a139803757e") { responseDict, error in
            
            if error != nil {
                let message = "An error has occurred. Please try again later."
                self.presentAlertWithTitle("Error", message: message)
                return
            }
            if let code = responseDict?["code"] as? String {
                if "success" != code {
                    let message = responseDict?["message"] as! String
                    self.presentAlertWithTitle("Error", message: message)
                    return
                }
            }
            else {
                self.presentAlertWithTitle("Error", message: "An unexpected error has occured. Please try again later")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func catchCardActionNotification(notification:Notification) -> Void {
        
        self.hideProgressIndicator()
        guard let userInfo = notification.userInfo,
            let success    = userInfo["success"] as? Bool
            else {
                self.presentAlertWithTitle("Error", message: "Unexpected error!. Incomplete error recovery data.")
                return
            }
        
        if !success {
            self.presentAlertWithTitle("Error", message: userInfo["message"] as! String ?? "Unknown error")
        }
        
        
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
                if sectionIdx == 0 && rowIdx == 0 {
                    firstCellSection = true
                    let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! HeaderCardCell
                    cell.selectionStyle = .none
                    return cell
                } else {
                    firstCellSection = false
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RequiredActionCard", for: indexPath) as! RequiredActionViewCell
                    cell.selectionStyle = .none
                    cell.configure(item, handler:self.requiredActionHandler)
                    cell.indexPath = indexPath
                  return cell
                }
            
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
            
            case "best_course":
                let cell = tableView.dequeueReusableCell(withIdentifier: "BestCourseCard", for: indexPath) as! BestCourseViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell

            case "insight":
                let cell = tableView.dequeueReusableCell(withIdentifier: "InsightCard", for: indexPath) as! InsightViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
            return cell
            
            case "action":
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCard", for: indexPath) as! ActionViewCell
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
        return firstCellSection ? 50 : getCellHeight()
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
