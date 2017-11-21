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
import EZAlertController
import RealmSwift


enum HomeSection: String {
    
    case RequiredActions = "Required Actions"
    case Insights = "Insights"
    case RecommendedForYou = "Recommended For You"
    case RecommendedActions =  "Recommended Actions"
    case Summaries = "Summaries"
    case MoreOnTheWay = "More On The Way"
    
    static let sectionTitles = [
        RequiredActions: "Required Actions",
        Insights: "Insights",
        RecommendedForYou: "Recommended For You",
        RecommendedActions: "Recommended Action",
        Summaries: "Summaries",
        MoreOnTheWay: "More On The Way"
    ]
    
    // position in table
    static let sectionPosition = [
        RequiredActions: 0,
        Insights: 1,
        RecommendedForYou: 2,
        RecommendedActions: 3,
        Summaries: 4,
        MoreOnTheWay: 5
    ]
    
    func sectionTitle() -> String {
        if let sectionTitle = HomeSection.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }
    
    func getSectionHeaderHeight() -> CGFloat {
        return CGFloat(80)
    }
    
    func getSectionPosition() -> Int {
        return HomeSection.sectionPosition[self]!
    }
}

enum HomeSectionType: String {
    case requiredActions = "Required Actions"
    case insights = "Insights"
    case recommendedForYou = "Recommended For You"
    case recommendedActions = "Recommended Actions"
    case summaries = "Summaries"
    case moreOnTheWay = "More On The Way"
}

enum HomeCardType: String {
    case requiredAction = "required_action"
    case insight = "insight"
    case recommendedAction = "recommended_action"
    case emptyState = "empty_state"
    
    static let cardHeight = [
        requiredAction: 505,
        insight: 479,
        recommendedAction: 479,
        emptyState: 150,
    ]
    
    func getCardHeight() -> CGFloat {
        if let cardHeight = HomeCardType.cardHeight[self] {
            return CGFloat(cardHeight)
        } else {
            return 0
        }
    }
}

class HomeHubViewController: BaseTableViewController, GIDSignInUIDelegate {
    
    fileprivate var sharingInProgress = false
    
    let indexToSection = [0: HomeSectionType.requiredActions.rawValue,
                          1: HomeSectionType.insights.rawValue,
                          2: HomeSectionType.recommendedForYou.rawValue,
                          3: HomeSectionType.recommendedActions.rawValue,
                          4: HomeSectionType.summaries.rawValue,
                          5: HomeSectionType.moreOnTheWay.rawValue]
    
    var requiredActionHandler = RequiredActionHandler()
    
    var recommendActionHandler = RecommendActionHandler()
    let store = FeedStore.getInstance()
    
    var toDoCellHeight = 50 as CGFloat

    var isMoreInfoType = false
    var shouldDisplayCell = true
    private var isLoadedAllRequiredCards = true
    
    let transition = BubbleTransition();
    var transitionButton:UIButton = UIButton();

    let transitionView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    
    var isAnimatingHeader = false
    
    var currentBrandId = UsersStore.currentBrandId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
      
        // Style elements
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        setUpNavigationBar()
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tabBarController?.delegate = self
        
        // NotificationCenter observers
        let nc = NotificationCenter.default
        nc.addObserver(forName:NSNotification.Name(rawValue: "CardActionNotification"), object:nil, queue:nil, using:catchCardActionNotification)
        nc.addObserver(forName:Notification.Popmetrics.UiRefreshRequired, object:nil, queue:nil, using:catchUiRefreshRequiredNotification)
      
        let requiredActionNib = UINib(nibName: "RequiredAction", bundle: nil)
        tableView.register(requiredActionNib, forCellReuseIdentifier: "requiredActionId")
        
        let sectionHeaderNib = UINib(nibName: "HeaderCardCell", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "headerCell")
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")
        
        let toDoCardNib = UINib(nibName: "ToDoCell", bundle: nil)
        tableView.register(toDoCardNib, forCellReuseIdentifier: "ToDoCell")
        
        let recommendedNib = UINib(nibName: "RecommendedCell", bundle: nil)
        tableView.register(recommendedNib, forCellReuseIdentifier: "recommendedId")
        
        let recommendedActionNib = UINib(nibName: "IceCardView", bundle: nil)
        tableView.register(recommendedActionNib, forCellReuseIdentifier: "recommendedActionId")
        
        let trafficNib = UINib(nibName: "TrafficCard", bundle: nil)
        tableView.register(trafficNib, forCellReuseIdentifier: "TrafficCard")
        
        let moreInfoNib = UINib(nibName: "MoreInfoViewCell", bundle: nil)
        tableView.register(moreInfoNib, forCellReuseIdentifier: "moreInfoId")
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        
        loadingView.tintColor = PopmetricsColor.darkGrey
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // old code: self?.fetchItems(silent:false)
            SyncService.getInstance().syncHomeItems(silent: false)
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PopmetricsColor.yellowBGColor)
        tableView.dg_setPullToRefreshBackgroundColor(PopmetricsColor.darkGrey)
        
        setupTopHeaderView()
        
        addImageOnLastCard()
        
        //createItemsLocally()
    }
    
    
    internal func createItemsLocally() {
        try! store.realm.write {
            store.realm.delete(store.getFeedCards())
            
            let todoCard = FeedCard()
            todoCard.section = "Required Actions"
            todoCard.type = "required_action"
            todoCard.cardId = "12523dadfsgfa5"
            store.realm.add(todoCard, update: true)
            
            let todoCard1 = FeedCard()
            todoCard1.section = "Required Actions"
            todoCard1.type = "required_action"
            todoCard1.cardId = "12523dafsdasfddfsgfa5"
            todoCard1.actionHandler = RequiredActionHandler.RequiredActionType.email.rawValue
            todoCard1.headerTitle = "Double check your email!"
            todoCard1.message = "We'll use your email to send your updates and reports on your business performance."
            store.realm.add(todoCard1, update: true)
            
            let todoCard2 = FeedCard()
            todoCard2.section = "Required Actions"
            todoCard2.type = "required_action"
            todoCard2.cardId = "12523dafsdfsdafasfddfsgfa5"
            store.realm.add(todoCard2, update: true)
 
            let tmpCard = FeedCard()
            tmpCard.section = HomeSectionType.recommendedActions.rawValue
            tmpCard.type = "recommended_action"
            tmpCard.cardId = "adsfaasfq24521"
            tmpCard.iceImpactPercentage = 70
            tmpCard.iceCostLabel = "30"
            tmpCard.iceCostPercentage = 60
            tmpCard.iceEffortLabel = "10 mins"
            tmpCard.iceEffortPercentage = 40
            
            store.realm.add(tmpCard, update: true)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.alpha = 1
        let tabInfo = MainTabInfo.getInstance()
        let xValue = tabInfo.currentItemIndex >= tabInfo.lastItemIndex ? CGFloat(20) : CGFloat(-20)
        UIView.transition(with: tableView,
                          duration: 0.22,
                          animations: {
                            self.tableView.alpha = 1
        })
    }
    
    func addImageOnLastCard() {
        let image = UIImage(named: "end_of_feed")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.frame = CGRect(x: 0, y: self.view.frame.height - 350, width: self.view.frame.width, height: 300)
    }
    
    func setupTopHeaderView() {
        if topHeaderView == nil {
            topHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
            self.view.addSubview(topHeaderView)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Home Feed", style: .plain, target: self, action: nil)
        text.tintColor = UIColor(red: 67/255, green: 78/255, blue: 84/255, alpha: 1.0)
        let titleFont = UIFont(name: FontBook.regular, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "Icon_Menu"), style: .plain, target: self, action: #selector(handlerClickMenu))
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    
    @objc func handlerClickMenu() {
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MENU_VC") as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return store.countSections()
        return store.countSections() + 1  // adding +1 for the last card
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLastSection(section: section) {
            return 1
        }
        
        return getSectionCards(section).count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        isMoreInfoType = false
        shouldDisplayCell = true
        
        if (isLastSection(section: sectionIdx)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
            cell.changeTitleWithSpacing(title: "More on it's way!")
            cell.changeMessageWithSpacing(message: "Find more actions to improve your business tomorrow!")
            cell.selectionStyle = .none
            cell.goToButton.changeTitle("View To Do List")
            cell.goToButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
            return cell
        }
        
        let sectionCards = getSectionCards(sectionIdx)

        let item = sectionCards[rowIdx]
        
        switch(item.type) {    
            case HomeCardType.requiredAction.rawValue:
                if isLoadedAllRequiredCards {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "requiredActionId", for: indexPath) as! RequiredAction
                    cell.configure(item, handler: self.requiredActionHandler)
                    cell.infoDelegate = self
                    if(sectionCards.count-1 == indexPath.row) {
                        cell.connectionLineView.isHidden = true
                    } else {
                        cell.connectionLineView.isHidden = false
                    }
                    return cell
                }
                
                if(indexPath.row == 1) {
                    isMoreInfoType = true
                    let moreInfoCell = tableView.dequeueReusableCell(withIdentifier: "moreInfoId", for: indexPath) as! MoreInfoViewCell
                    moreInfoCell.setActionCardCount(numberOfActionCards: sectionCards.count - 1)
                    moreInfoCell.footerView.actionButton.addTarget(self, action: #selector(loadAllActionCards), for: .touchUpInside)
                    return moreInfoCell
                } else if (indexPath.row > 1) {
                    shouldDisplayCell = false
                    return UITableViewCell()
                }
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "requiredActionId", for: indexPath) as! RequiredAction
                cell.configure(item, handler: self.requiredActionHandler)
                cell.infoDelegate = self
                if(sectionCards.count-1 == indexPath.row) {
                    cell.connectionLineView.isHidden = true;
                }
                return cell
            
            case HomeCardType.insight.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedId", for: indexPath) as! RecommendedCell
                cell.setUpCell(type: "Popmetrics Insight")
                cell.configure(item)
                if(sectionCards.count-1 == indexPath.row) {
                    cell.connectionLine.isHidden = true;
                }
                cell.delegate = self
                //cell.footerVIew.actionButton.addTarget(self, action: #selector(handlerInsightButton),
                cell.footerVIew.informationBtn.addTarget(self, action: #selector(showTooltip(_:)), for: .touchUpInside)
                return cell

            case HomeCardType.recommendedAction.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedActionId", for: indexPath) as! IceCardViewCell
                cell.delegate = self
                cell.configure(item)
                return cell
            case HomeCardType.emptyState.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
                cell.changeTitleWithSpacing(title: "More on it's way!")
                cell.changeMessageWithSpacing(message: "Find more actions to improve your business tomorrow!")
                cell.selectionStyle = .none
                cell.goToButton.changeTitle("View To Do List")
                cell.goToButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
                return cell
            default:
                let cell = UITableViewCell()
                return cell
            }
        
    }
    
    @objc func loadAllActionCards() {
        
        self.isLoadedAllRequiredCards = true
        //self.showActionAnimation = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: false)
        }, completion: { (_) in
            
            self.tableView.reloadData()
        })
        
    }
    
    func isLastSection(section: Int) -> Bool {
        return false
        if section == store.countSections() {
            return true
        }
        return false
    }
    
    @objc func openGoogleActionView(_ feedCard: FeedCard) {
        let googleActionVc: GoogleActionViewController = UIStoryboard(name: "GoogleAction", bundle: nil).instantiateViewController(withIdentifier: "googleId") as! GoogleActionViewController
        googleActionVc.hidesBottomBarWhenPushed = true
        googleActionVc.configure(feedCard, handler: recommendActionHandler)
        
        self.navigationController?.pushViewController(googleActionVc, animated: true)
    }
    
    @objc func handlerInsightButton() {
        goToNextTab()
    }
    
    @objc private func goToNextTab() {
        self.tabBarController?.selectedIndex += 1
    }
    
    /*
     * Return cards for a specific section
     */
    func getSectionCards(_ sectionIdx: Int) -> Results<FeedCard> {
        return store.getFeedCardsWithSection(getOrderedSections()[sectionIdx])
    }

    /*
     * Order sections by section index and
     */
    func getOrderedSections() -> [String] {
        let sections: [String] = store.getSections()
        var orderedSections = Array(repeating: "", count: store.countSections())
        for section in sections {
            guard let homeSection = HomeSection(rawValue: section) else { return [] }
            var position = homeSection.getSectionPosition()
            if(sections.count <= homeSection.getSectionPosition()) {
               position = sections.count - homeSection.getSectionPosition()
            }
            orderedSections[position] = section
        }
        return orderedSections
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (isLastSection(section: section)) {
            return nil
        }
        
        let sectionCards = getSectionCards(section)
        
        var itemSection = "unknown"
        if sectionCards.count > 0 {
            //itemType = sectionCards[0].type
            itemSection = sectionCards[0].section
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
        
        switch itemSection {
        case "required_action" :
            cell.changeColor(cardType: .required)
            cell.sectionTitleLabel.text = "Required Actions";
            return cell
        case "recommended_action":
            cell.changeColor(cardType: .recommended)
            cell.sectionTitleLabel.text = "Recommended For You";
            return cell
        case "Insights":
            cell.changeColor(cardType: .insight)
            cell.sectionTitleLabel.text = "Insights";
            return cell
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionString = indexToSection[section]
        
        guard let _  = sectionString else { return 0 }
        guard let homeSection = HomeSection(rawValue: sectionString!) else { return 0 }
        
        return homeSection.getSectionHeaderHeight()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLastSection(section: indexPath.section) {
            return 261
        }

        if isMoreInfoType {
            return 226
        }
        
        if !shouldDisplayCell {
            return 0
        }
        
        
        let cards = getSectionCards(indexPath.section)
        let card: FeedCard  = cards[indexPath.row]
        
        guard let cardType = HomeCardType(rawValue: card.type) else { return 0}
        return cardType.getCardHeight()
        

        let sectionString = indexToSection[indexPath.section]
        guard let _ = sectionString else { return 0 }
        guard let homeSection = HomeSection(rawValue: sectionString!) else { return 0 }
        
        //return homeSection.getSectionHeight()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var fixedHeaderFrame = self.topHeaderView.frame
        fixedHeaderFrame.origin.y = 0 + scrollView.contentOffset.y
        topHeaderView.frame = fixedHeaderFrame
        
        if let indexes = tableView.indexPathsForVisibleRows {
            for index in indexes {
                let indexPath = IndexPath(row: 0, section: index.section)
                guard let lastRowInSection = indexes.last , indexes.first?.section == index.section else {
                    return
                }
                let headerFrame = tableView.rectForHeader(inSection: index.section)
                
                let frameOfLastCell = tableView.rectForRow(at: lastRowInSection)
                let cellFrame = tableView.rectForRow(at: indexPath)
                if headerFrame.origin.y + 50 < tableView.contentOffset.y {
                    topHeaderView.changeTitle(title: indexToSection[index.section]!)
                    animateHeader(colapse: false)
                } else if frameOfLastCell.origin.y < tableView.contentOffset.y  {
                    animateHeader(colapse: false)
                } else {
                    animateHeader(colapse: true)
                }
            }
            if tableView.contentOffset.y == 0 {   //top of the tableView
                animateHeader(colapse: true)
            }
        }
        
    }
    
    func animateHeader(colapse: Bool) {
        if (self.isAnimatingHeader) {
            return
        }
        self.isAnimatingHeader = true
        UIView.animate(withDuration: 0.3, animations: {
            if colapse {
                self.topHeaderView.frame.size.height = 0
                self.topHeaderView.circleView.isHidden = true
                self.topHeaderView.statusLbl.isHidden = true
            } else {
                self.topHeaderView.frame.size.height = 30
                self.topHeaderView.circleView.isHidden = false
                self.topHeaderView.statusLbl.isHidden = false
            }
            self.topHeaderView.layoutIfNeeded()
        }, completion: { (completed) in
            self.isAnimatingHeader = false
        })
    }
    
    ///
    
    @objc func handleRequiredAction(_ sender : UIButton){
        print("handling required action")
    }
    
}

extension HomeHubViewController: RecommendedActionViewCellDelegate {
    func recommendedActionViewCellDidTapAction(_ feedCard: FeedCard) {
        openGoogleActionView(feedCard)
    }
}

extension HomeHubViewController: RecommendeCellDelegate {
    func recommendedCellDidTapAction(_ feedCard: FeedCard) {
        openGoogleActionView(feedCard)
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
    
    //
    func sendInfo(_ sender: UIButton) {
        self.requiredActionHandler.showBanner(bannerType: .success)
        //showTooltip(sender)
    }
    
    @objc func showTooltip(_ sender: UIButton) {
        let infoCardVC = AppStoryboard.Boarding.instance.instantiateViewController(withIdentifier: "InfoCardViewID") as! InfoCardViewController;
        infoCardVC.changeCardType(type: "insight")
        infoCardVC.transitioningDelegate = self
        infoCardVC.modalPresentationStyle = .custom
        
        transitionButton = sender
        infoCardVC.modalPresentationStyle = .overCurrentContext
        
        self.present(infoCardVC, animated: true, completion: nil)
    }
}


// MARK: UITabBarControllerDelegate
extension HomeHubViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.selectedIndex
    }
}

enum CardType: String {
    case required = "required"
    case recommended = "recommended"
    case todo = "todo"
    case traffic = "traffic"
    case insight = "insight"
    case scheduled = "scheduled"
}


// MARK: Notification Handlers 
extension HomeHubViewController {
    
    func catchUiRefreshRequiredNotification(notification:Notification) -> Void {
        print(store.getFeedCards())
        self.tableView.reloadData()
        
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

}
