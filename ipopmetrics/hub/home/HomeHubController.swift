//
//  TodoHubController.swift
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
    
    var shouldDisplayCell = true
    private var isShowAllRequiredCards = true
    
    let transition = BubbleTransition();
    var transitionButton:UIButton = UIButton();
    
    let transitionView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    
    var isAnimatingHeader = false
    
    var currentBrandId = UserStore.currentBrandId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Style elements
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        setUpNavigationBar()
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tabBarController?.delegate = self
        
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = 80
        
        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionFooterHeight = 60
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 460
        
        // NotificationCenter observers
        let nc = NotificationCenter.default
        nc.addObserver(forName:NSNotification.Name(rawValue: "CardActionNotification"), object:nil, queue:nil, using:catchCardActionNotification)
        nc.addObserver(forName:Notification.Popmetrics.UiRefreshRequired, object:nil, queue:nil, using:catchUiRefreshRequiredNotification)
        
        let requiredActionNib = UINib(nibName: "RequiredActionCard", bundle: nil)
        tableView.register(requiredActionNib, forCellReuseIdentifier: "RequriedActionCard")
        
        let sectionHeaderNib = UINib(nibName: "CardHeaderView", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "CardHeaderView")
        
        let cardHeaderCellNib = UINib(nibName: "CardHeaderCell", bundle: nil)
        tableView.register(cardHeaderCellNib, forCellReuseIdentifier: "CardHeaderCell")
        
        let emptyCard = UINib(nibName: "EmptyStateCard", bundle: nil)
        tableView.register(emptyCard, forCellReuseIdentifier: "EmptyStateCard")
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")
        
        let recommendedNib = UINib(nibName: "InsightCard", bundle: nil)
        tableView.register(recommendedNib, forCellReuseIdentifier: "InsightCard")
        
        let recommendedActionNib = UINib(nibName: "IceCardView", bundle: nil)
        tableView.register(recommendedActionNib, forCellReuseIdentifier: "recommendedActionId")
        
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
        return self.indexToSection.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let homeSection = HomeSection.init(rawValue: self.indexToSection[section]!)
            else { return 0 }
        
        return countCardsInSection(homeSection.rawValue)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        shouldDisplayCell = true
        
        guard let homeSection = HomeSection.init(rawValue: self.indexToSection[sectionIdx]!)
            else {
                return UITableViewCell()
        }
        
        let card = getCardInSection(homeSection.rawValue, atIndex: rowIdx)
        let cardsCount = countCardsInSection(homeSection.rawValue)
        
        let item = card
        
        switch(item.type) {
        case HomeCardType.requiredAction.rawValue:
            
            if isShowAllRequiredCards {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RequriedActionCard", for: indexPath) as! RequiredActionCard
                cell.configure(item, handler: self.requiredActionHandler)
                cell.infoDelegate = self
                if(cardsCount - 1 == indexPath.row) {
                    cell.connectionLineView.isHidden = true
                } else {
                    cell.connectionLineView.isHidden = false
                }
                return cell
            }
            
            if(indexPath.row == 1) {
                let moreInfoCell = tableView.dequeueReusableCell(withIdentifier: "moreInfoId", for: indexPath) as! MoreInfoViewCell
                moreInfoCell.setActionCardCount(numberOfActionCards: cardsCount - 1)
                moreInfoCell.footerView.actionButton.addTarget(self, action: #selector(loadAllActionCards), for: .touchUpInside)
                return moreInfoCell
            } else if (indexPath.row > 1) {
                shouldDisplayCell = false
                return UITableViewCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequriedActionCard", for: indexPath) as! RequiredActionCard
            cell.configure(item, handler: self.requiredActionHandler)
            cell.infoDelegate = self
            if(cardsCount - 1 == indexPath.row) {
                cell.connectionLineView.isHidden = true;
            }
            return cell
            
        case HomeCardType.insight.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InsightCard", for: indexPath) as! InsightCard
            cell.configure(item, handler: recommendActionHandler)
            if(cardsCount - 1 == indexPath.row) {
                cell.connectionLine.isHidden = true;
            }
            cell.delegate = self
            
            
            return cell
            
//        case HomeCardType.recommendedAction.rawValue:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedActionId", for: indexPath) as! IceCardViewCell
//            cell.delegate = self
//            cell.configure(item)
//            return cell
        case HomeCardType.emptyState.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateCard", for: indexPath) as! EmptyStateCard
            cell.selectionStyle = .none
            cell.configure(item)
            return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    @objc func loadAllActionCards() {
        
        self.isShowAllRequiredCards = true
        //self.showActionAnimation = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: false)
        }, completion: { (_) in
            
            self.tableView.reloadData()
        })
        
    }
    
    @objc func openActionPage(_ feedCard: FeedCard) {
        
        if feedCard.recommendedAction == "" {
            self.presentAlertWithTitle("Error", message: "This insight has no recommended action!", useWhisper: true);
            return
        }
        guard let actionCard = self.store.getFeedCardWithName(feedCard.recommendedAction)
            else {
                self.presentAlertWithTitle("Error", message: "No card to show with name: "+feedCard.recommendedAction, useWhisper: true);
                return
        }
        
        
        
        let actionPageVc: ActionPageDetailsViewController = ActionPageDetailsViewController(nibName: "ActionPage", bundle: nil)
        //actionPageVc.hidesBottomBarWhenPushed = true
        actionPageVc.hidesBottomBarWhenPushed = true
        actionPageVc.configure(actionCard, handler: recommendActionHandler)
        
        self.navigationController?.pushViewController(actionPageVc, animated: true)
    }
    
    @objc private func goToNextTab() {
        self.tabBarController?.selectedIndex += 1
    }
    
    func getCardInSection( _ section: String, atIndex:Int) -> FeedCard {
        let nonEmptyCards = store.getNonEmptyFeedCardsWithSection(section)
        if nonEmptyCards.count == 0 {
            let emptyCards = store.getEmptyFeedCardsWithSection(section)
            return emptyCards[atIndex]
        }
        else {
            return nonEmptyCards[atIndex]
        }
    }
    
    func countCardsInSection( _ section: String) -> Int {
        let nonEmptyCards = store.getNonEmptyFeedCardsWithSection(section)
        if nonEmptyCards.count == 0 {
            let emptyCards = store.getEmptyFeedCardsWithSection(section)
            return emptyCards.count
        }
        else {
            return nonEmptyCards.count
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let homeSection = HomeSection.init(rawValue: self.indexToSection[section]!)
        let count = countCardsInSection((homeSection?.rawValue)!)
        if count < 1 {
            let emptyView = UIView()
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            emptyView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            return emptyView
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardHeaderCell") as! CardHeaderCell
        cell.sectionTitleLabel.text = homeSection?.sectionTitle()
        
        return cell
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
    
    func callRequiredAction(_ requiredActionCard: FeedCard) {
        self.requiredActionHandler.homeHubViewController = self
        self.requiredActionHandler.handleRequiredAction(requiredActionCard)
        
    }
    
    
    func openInsightDetails(_ feedCard: FeedCard) {
        let insightDetails = InsightPageDetailsViewController(nibName: "InsightPage", bundle: nil)
        insightDetails.configure(feedCard)
        insightDetails.hidesBottomBarWhenPushed = true 
        self.navigationController?.pushViewController(insightDetails, animated: true)
    }
}

extension HomeHubViewController: RecommendedActionViewCellDelegate {
    func recommendedActionViewCellDidTapAction(_ feedCard: FeedCard) {
        openActionPage(feedCard)
    }
}

extension HomeHubViewController: RecommendeCellDelegate {
    func cellDidTapMoreInfo(_ feedCard: FeedCard) {
        openInsightDetails(feedCard)
    }
    
    func recommendedCellDidTapAction(_ feedCard: FeedCard) {
        openActionPage(feedCard)
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
        // self.showBanner(bannerType: .success)
        // showTooltip(sender)
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
        //print(store.getFeedCards())
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




