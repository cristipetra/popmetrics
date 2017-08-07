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
import BubbleTransition

class HomeHubViewController: BaseTableViewController, GIDSignInUIDelegate {
    
    fileprivate var sharingInProgress = false
    
    fileprivate var sections: [FeedSection] = []
    
    var requiredActionHandler = RequiredActionHandler()
    
    var shouldDisplayCell = true
    var isInfoCellType = false;
    
    let transition = BubbleTransition();
    var transitionButton:UIButton = UIButton();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
      
        // Style elements
        setUpNavigationBar()
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:NSNotification.Name(rawValue: "CardActionNotification"), object:nil, queue:nil, using:catchCardActionNotification)
      
        let sectionHeaderNib = UINib(nibName: "HeaderCardCell", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "headerCell")
        
        let requiredActionCardNib = UINib(nibName: "RequiredActionCard", bundle: nil)
        tableView.register(requiredActionCardNib, forCellReuseIdentifier: "RequiredActionCard")
      
        let recommendationCardNib = UINib(nibName: "RecommendationCard", bundle: nil)
        tableView.register(recommendationCardNib, forCellReuseIdentifier: "RecommendationCard")
        
        let approvalCardNib = UINib(nibName: "ApprovalCard", bundle: nil)
        tableView.register(approvalCardNib, forCellReuseIdentifier: "ApprovalCard")
        
        let approvalCardInfoNib = UINib(nibName: "ApprovalCardInfo", bundle: nil)
        tableView.register(approvalCardInfoNib, forCellReuseIdentifier: "ApprovalCardInfo")
        
        let dailyInsightNib = UINib(nibName: "DailyInsightsCardCell", bundle: nil)
        tableView.register(dailyInsightNib, forCellReuseIdentifier: "DailyInsightsCard")
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")
      
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
            
            
            // Add temp recommendation sections
            let tmpSectionRecommendation:FeedSection = FeedSection()
            tmpSectionRecommendation.name = "Recommendation"
            tmpSectionRecommendation.index  = 2;
            
            let recommendationItem: FeedItem = FeedItem();
            recommendationItem.actionHandler = "no_action"
            recommendationItem.actionLabel = "Connect"
            recommendationItem.headerIconUri = "icon_twitter";
            recommendationItem.imageUri = "back_twitter";
            recommendationItem.headerTitle = "Get a Twitter Account ASAP"
            recommendationItem.message = "Increase your digital footprint & important for SEO"
            recommendationItem.type = "recommendation"
            
            let recommendationItem2: FeedItem = FeedItem();
            recommendationItem2.actionHandler = "no_action"
            recommendationItem2.actionLabel = "Connect"
            recommendationItem2.headerIconUri = "icon_citation_error";
            recommendationItem2.imageUri = "social_media";
            recommendationItem2.headerTitle = "Social Media Automation"
            recommendationItem2.message = "Why do it... and a description goes in here to compel the user to click on the card, Im sure if it needs a secondary CTA or whether the card is sufficient."
            recommendationItem2.type = "recommendation"
            
            tmpSectionRecommendation.items.append(recommendationItem)
            tmpSectionRecommendation.items.append(recommendationItem2)
            
            
            self.sections.append(tmpSectionRecommendation)
            
            let tmpSectionApproval:FeedSection = FeedSection()
            tmpSectionApproval.name = "Approval"
            tmpSectionApproval.index = 2;
            
            let approvalItem2: FeedItem = FeedItem();
            approvalItem2.actionHandler = "no_action"
            approvalItem2.headerIconUri = "icon_citationerror_splash";
            approvalItem2.imageUri = "icon_citationerror_splash";
            approvalItem2.headerTitle = "Article Title Goes Here"
            approvalItem2.message = ""
            approvalItem2.type = "approval"
            
            tmpSectionApproval.items.append(approvalItem2)
            
            let approvalItem: FeedItem = FeedItem();
            approvalItem.actionHandler = "no_action"
            approvalItem.headerIconUri = "icon_citationerror_splash";
            approvalItem.imageUri = "icon_citationerror_splash";
            approvalItem.headerTitle = "Article Title Goes Here"
            approvalItem.message = "What is the citation error relating to? Where is it that this person needs to do?"
            approvalItem.type = "approval"
            
            tmpSectionApproval.items.append(approvalItem)
            
            self.sections.append(tmpSectionApproval)
            
            
            let tmpSectionInsight:FeedSection = FeedSection()
            tmpSectionInsight.name = "Daily Insight"
            tmpSectionInsight.index = 1;
            
            
            let insightItem: FeedItem = FeedItem();
            insightItem.actionHandler = "no_action"
            insightItem.headerIconUri = "icon_citationerror_splash";
            insightItem.imageUri = "icon_citationerror_splash";
            insightItem.headerTitle = "Article Title Goes Here"
            insightItem.message = "What is the citation error relating to? Where is it that this person needs to do?"
            insightItem.type = "daily_insight"
            
            tmpSectionInsight.items.append(insightItem)
            
            self.sections.append(tmpSectionInsight)
            
            
            let lastSection: FeedSection = FeedSection()
            lastSection.name = ""
            lastSection.index = 1;
            let lastItem: FeedItem = FeedItem();
            lastItem.type = "info"
            lastSection.items.append(lastItem)
            
            self.sections.append(lastSection)

            
            ///---- End add temporary sections
            
            
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
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Home Feed", style: .plain, target: self, action: nil)
        text.tintColor = UIColor(red: 67/255, green: 78/255, blue: 84/255, alpha: 1.0)
        let titleFont = UIFont(name: FontBook.regular, size: 18)
        text.setTitleTextAttributes([NSFontAttributeName: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "Icon_Menu"), style: .plain, target: self, action: #selector(handlerClickMenu))
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    func handlerClickMenu() {
        
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
    
    /*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }
    */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        let section = sections[sectionIdx]
        let item = section.items[rowIdx]
        
        isInfoCellType = false
        switch(item.type) {
            case "required_action":
                shouldDisplayCell = true
                let cell = tableView.dequeueReusableCell(withIdentifier: "RequiredActionCard", for: indexPath) as! RequiredActionViewCell
                cell.selectionStyle = .none
                cell.delegate = self
                cell.configure(item, handler:self.requiredActionHandler)
                cell.indexPath = indexPath
                
                cell.connectionView.isHidden = ((sections[sectionIdx].items.count-1) == indexPath.row) ? true : false;
                return cell

            case "recommendation":
                shouldDisplayCell = true
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationCard", for: indexPath) as! RecommendationCardCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                cell.indexPath = indexPath
                if((sections[sectionIdx].items.count-1) == indexPath.row) {
                    cell.connectionView.isHidden = true;
                }
                return cell
            
            case "approval":
                shouldDisplayCell = true
                
                //Fixme: find a way to add card info for approval
                if(rowIdx == 0) {
                    isInfoCellType = true
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalCardInfo", for: indexPath) as! ApprovalCardInfoCell
                    return cell;
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "ApprovalCard", for: indexPath) as! ApprovalCardCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                if((sections[sectionIdx].items.count-1) == indexPath.row) {
                    cell.connectionView.isHidden = true;
                }
                return cell
            case "daily_insight":
                shouldDisplayCell = true
                let cell = tableView.dequeueReusableCell(withIdentifier: "DailyInsightsCard", for: indexPath) as! DailyInsightsCardCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                if((sections[sectionIdx].items.count-1) == indexPath.row) {
                    cell.connectionView.isHidden = true;
                }
                return cell
            case "info":
                shouldDisplayCell = true
                isInfoCellType = true
                let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
                cell.selectionStyle = .none
                
                return cell
            /*
            case "action_history":
                shouldDisplayCell = false
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActionHistoryCard", for: indexPath) as! ActionHistoryViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell
            
            case "article_of_interest":
                shouldDisplayCell = false
                let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleOfInterestCard", for: indexPath) as! ArticleOfInterestViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell
            
            case "stats_summary":
                shouldDisplayCell = false
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatsSummaryCard", for: indexPath) as! StatsSummaryViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell
            
            case "best_course":
                shouldDisplayCell = false
                let cell = tableView.dequeueReusableCell(withIdentifier: "BestCourseCard", for: indexPath) as! BestCourseViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell

            case "insight":
                shouldDisplayCell = false
                let cell = tableView.dequeueReusableCell(withIdentifier: "InsightCard", for: indexPath) as! InsightViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
            return cell
            
            case "action":
                shouldDisplayCell = false
                let cell = tableView.dequeueReusableCell(withIdentifier: "ActionCard", for: indexPath) as! ActionViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
            return cell
 */
            default:
                shouldDisplayCell = false
                //shouldDisplayHeaderCell = false
                let cell = tableView.dequeueReusableCell(withIdentifier: "RequiredActionCard", for: indexPath) as! RequiredActionViewCell
                cell.selectionStyle = .none
                cell.configure(item, handler:self.requiredActionHandler)
                return cell

        }
        
    }
    
    var shouldDisplayHeaderCell = false
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            shouldDisplayHeaderCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(section: 0)
            
            return cell
        case 1:
            shouldDisplayHeaderCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(section: 1)
            cell.sectionTitleLabel.text = "Recommendation For You";
            return cell
        case 2:
            shouldDisplayHeaderCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(section: 2)
            //cell.isHidden = true;
            return cell
        case 3:
            shouldDisplayHeaderCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(section: 3)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(section: 4)
            cell.sectionTitleLabel.text = "Tasks For Approval";
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(section: 5)
            cell.sectionTitleLabel.text = "Daily Insights";
            return cell
        default:
            shouldDisplayHeaderCell = false
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.backgroundColor = UIColor.red
            return cell
        }
    }

    
    /*
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight()
    }
     */
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print(shouldDisplayHeaderCell)
        var height: CGFloat = 0;
        if (section == 0 || section == 1 || section == 4 || section == 5) {
            height = 50;
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return shouldDisplayCell ? getCellHeight() : 0
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
        var heightCell: CGFloat = 464
        if(isInfoCellType) {
            heightCell = 172
        }
        return heightCell
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

// MARK: UIViewControllerTransitioningDelegate

extension HomeHubViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = PopmetricsColor.yellowBGColor
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = PopmetricsColor.yellowBGColor
        return transition
    }
    
}

extension HomeHubViewController: InfoButtonDelegate {
    func sendInfo(_ sender: UIButton) {
        let infoCardVC = AppStoryboard.Boarding.instance.instantiateViewController(withIdentifier: "InfoCardViewID") as! InfoCardViewController;
        
        infoCardVC.transitioningDelegate = self
        infoCardVC.modalPresentationStyle = .custom
        
        transitionButton = sender
        infoCardVC.modalPresentationStyle = .overCurrentContext
        
        self.present(infoCardVC, animated: true, completion: nil)
    }
}
