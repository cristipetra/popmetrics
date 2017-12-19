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
import MJCalendar
import RealmSwift
import MGSwipeTableCell
import DGElasticPullToRefresh

protocol MasterToContainer {
    func animateTopPart(shouldCollapse: Bool, offset: CGFloat)
}

enum CalendarSection: String {
    case Scheduled = "Scheduled"
    case Completed = "Completed"
}

enum CalendarSectionType: String {
    case scheduled = "Scheduled"
    case completed = "Completed"
}

class CalendarHubController: BaseViewController, ContainerToMaster {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var divider: UIView!

    @IBOutlet weak var topAnchorTableView: NSLayoutConstraint!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    
    var calendarNoteView: NoteView!
    @IBOutlet weak var calendarViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var calendarView: UIView!
    
    let transitionView = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let store = CalendarStore.getInstance()
    
    internal var calendarViewController: MJCalendarViewController?
    internal var scrollToRow: IndexPath = IndexPath(row: 0, section: 0)
    internal var reachedFooter = false
    internal var shouldMaximizeCell = false
    internal let noItemsLoadeInitial = 3
    internal var datesSelected = 0
    internal var noItemsLoaded: [Int] = [3,3,3,3,3]
    internal var masterToContainer:MasterToContainer?
    internal var topHeaderView: HeaderView!
    internal var isAnimatingHeader: Bool = false
    var stopAnimatingAfterScroll = false
    
    var currentBrandId = UserStore.currentBrandId
    
    var shouldReloadData: Bool = false
    fileprivate var didAnimateCardFirstTime = false
    
    let indexToSection = [0: CalendarSectionType.scheduled.rawValue,
                          1: CalendarSectionType.completed.rawValue]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()

        registerCellsForTable()
        
        tableView.separatorStyle = .none
        
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = 109
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        
        setupTopHeaderView()
        
        topHeaderView.displayElements(isHidden: true)
        addNotifications()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = PopmetricsColor.darkGrey
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            SyncService.getInstance().syncCalendarItems(silent: false)
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PopmetricsColor.yellowBGColor)
        tableView.dg_setPullToRefreshBackgroundColor(PopmetricsColor.darkGrey)
        
        tableView.isHidden = true
        
        self.view.addSubview(transitionView)
        transitionView.addSubview(tableView)
        transitionView.addSubview(calendarView)
        if shouldReloadData {
            SyncService.getInstance().syncCalendarItems(silent: false)
        }

    }
    
    func createItemsLocally() {
        //store.realm.deleteAll()
        try! store.realm.write {
            store.realm.deleteAll()
            
            let calendarScheduledId = "atwqt43wtgatsga"
            let calendarCompletedId = "adsffsa23raddsfaf"
            
            let calendarScheduled = CalendarCard()
            calendarScheduled.cardId = calendarScheduledId
            calendarScheduled.createDate = Date()
            calendarScheduled.section = CalendarSectionType.scheduled.rawValue
            calendarScheduled.type = "typeScheduled"
            store.realm.add(calendarScheduled, update: true)
            
            let calendarCompleted = CalendarCard()
            calendarCompleted.cardId = calendarCompletedId
            calendarCompleted.createDate = Date()
            calendarCompleted.section = CalendarSectionType.completed.rawValue
            calendarCompleted.type = "empty_state"
            
            store.realm.add(calendarCompleted, update: true)
            
            
            let scheduledPost = CalendarSocialPost()
            scheduledPost.calendarCard = calendarScheduled
            scheduledPost.calendarCardId = calendarScheduled.cardId!
            scheduledPost.text = "dfasfsafas"
            scheduledPost.createDate = Date()
            scheduledPost.scheduledDate = Date()
            scheduledPost.postId = "11fsadfsdfsadfa"
            scheduledPost.type = "calendar.scheduled_action"
            scheduledPost.index = 3
            scheduledPost.section = CalendarSectionType.scheduled.rawValue
            store.realm.add(scheduledPost, update: true)
            
            
            let scheduledPost1 = CalendarSocialPost()
            scheduledPost1.calendarCard = calendarScheduled
            scheduledPost1.calendarCardId = calendarScheduled.cardId!
            scheduledPost1.text = "dfsdagsaaswfsafas"
            scheduledPost1.createDate = Date()
            scheduledPost1.scheduledDate = Date()
            scheduledPost1.postId = "11weqfsadfsdfesadfa"
            scheduledPost1.type = "social.scheduled_posts"
            scheduledPost1.index = 0
            scheduledPost1.section = CalendarSectionType.scheduled.rawValue
            store.realm.add(scheduledPost1, update: true)
            
            
            let scheduledPost2 = CalendarSocialPost()
            scheduledPost2.calendarCard = calendarScheduled
            scheduledPost2.calendarCardId = calendarScheduled.cardId!
            scheduledPost2.text = "dfsdagsaaswfsafas"
            scheduledPost2.createDate = Date()
            scheduledPost2.scheduledDate = Date()
            scheduledPost2.postId = "11w2eqfsadfsdfesadfa"
            scheduledPost2.type = "social.scheduled_posts"
            scheduledPost2.index = 0
            scheduledPost2.section = CalendarSectionType.scheduled.rawValue
            store.realm.add(scheduledPost2, update: true)
            
            
            let scheduledActionPost = CalendarSocialPost()
            scheduledActionPost.calendarCard = calendarScheduled
            //scheduledActionPost.calendarCardId = calendarScheduled.cardId!
            scheduledActionPost.createDate = Date()
            scheduledActionPost.scheduledDate = Date()
            scheduledActionPost.text = "action1 post14"
            scheduledActionPost.postId = "dsfa461sagsdfsadfa"
            scheduledActionPost.type = "calendar.scheduled_action"
            scheduledActionPost.index = 2
            scheduledActionPost.section = CalendarSectionType.scheduled.rawValue
            store.realm.add(scheduledActionPost, update: true)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calendarViewControllerSegue" {
            calendarViewController = segue.destination as? MJCalendarViewController
            calendarViewController!.containerToMaster = self
        }
    }
    
    func setDatesSelected(datesSelected: Int) {
        print("set dates selected")
        self.datesSelected = datesSelected
        store.datesSelected = datesSelected
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func setCalendarViewHeightConstraint(height: CGFloat) {
        self.calendarViewHeightAnchor.constant = height
    }
    
    func addNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(didPostActionHandler), name: NSNotification.Name("didPostAction"), object: nil)
        
        nc.addObserver(forName:Notification.Popmetrics.UiRefreshRequired, object:nil, queue:nil, using:catchUiRefreshRequiredNotification)
        
        nc.addObserver(self, selector: #selector(handlerAnimateCardAppearance), name: Notification.Name("animateRow"), object: nil)
    }
    
    @objc internal func handlerAnimateCardAppearance() {
        didAnimateCardFirstTime = true
    }
    
    func setNoteView() {
        if calendarNoteView == nil {
            calendarNoteView = NoteView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 93))
            self.view.addSubview(calendarNoteView)
            NSLayoutConstraint.activate([
                calendarNoteView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 0),
                calendarNoteView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
                calendarNoteView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
                calendarNoteView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0)
                ])
            calendarNoteView.translatesAutoresizingMaskIntoConstraints = false
            topAnchorTableView.constant = calendarNoteView.height()
            calendarNoteView.setDescriptionText(type: .calendar)
            //calendarNoteView.performActionButton.addTarget(self, action: #selector(goToHomeTab), for: .touchUpInside)
        }
    }
    
    internal func registerCellsForTable() {
        let calendarCardNib = UINib(nibName: "CalendarCard", bundle: nil)
        tableView.register(calendarCardNib, forCellReuseIdentifier: "CalendarCard")
        
        let calendarCardSimpleNib = UINib(nibName: "CalendarCardSimple", bundle: nil)
        tableView.register(calendarCardSimpleNib, forCellReuseIdentifier: "CalendarCardSimple")
        
        let calendarCardCompletedActionNib = UINib(nibName: "CalendarCompletedAction", bundle: nil)
        tableView.register(calendarCardCompletedActionNib, forCellReuseIdentifier: "CalendarCompletedAction")
        
        let sectionHeaderNib = UINib(nibName: "CalendarHeaderViewCell", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "CalendarHeaderViewCell")
        
        let sectionHeaderCardNib = UINib(nibName: "CardHeaderCell", bundle: nil)
        tableView.register(sectionHeaderCardNib, forCellReuseIdentifier: "CardHeaderCell")
        
        let emptyCard = UINib(nibName: "EmptyStateCard", bundle: nil)
        tableView.register(emptyCard, forCellReuseIdentifier: "EmptyStateCard")
        
    }
    
    @objc func didPostActionHandler() {
        self.shouldReloadData = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateTransitionView()
    }
    
    private func animateTransitionView() {
        transitionView.alpha = 0.7
        let tabInfo = MainTabInfo.getInstance()
        let xValue = tabInfo.currentItemIndex >= tabInfo.lastItemIndex ? CGFloat(20) : CGFloat(-20)
        transitionView.frame.origin.x = xValue
        
        UIView.transition(with: tableView,
                          duration: 0.22,
                          animations: {
                            self.transitionView.frame.origin.x = 0
                            self.transitionView.alpha = 1
                          }
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.isHidden = false
    }
    
    func setupTopHeaderView() {
        if topHeaderView == nil {
            topHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
            tableView.addSubview(topHeaderView)
            topHeaderView.displayIcon(display: true)
            topHeaderView.layer.zPosition = 1
            topHeaderView.iconLbl.isUserInteractionEnabled = true
        }
    }
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Calendar", style: .plain, target: self, action: nil)
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
    
}

extension CalendarHubController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        let socialPosts = store.getCalendarSocialPostsForCard(store.getCalendarCards()[sectionIdx], datesSelected: datesSelected)
        
        if socialPosts.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateCard", for: indexPath) as! EmptyStateCard
            return cell
        }
        
        let item = socialPosts[rowIdx]
        
        if item.type == "calendar.scheduled_action" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCompletedAction", for: indexPath) as! CalendarCompletedViewCell
            cell.configure(socialPost: item)
            cell.setPositions(indexPath: indexPath, countPosts: socialPosts.count)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCard", for: indexPath) as! CalendarCardViewCell
        cell.configure(item)

        let postsByType = store.getCalendarSocialPostsForCardByType(store.getCalendarCards()[sectionIdx], type: item.type)
        
        cell.setPositions(indexPath, itemsToLoad: noItemsLoadeInitial, countPosts: postsByType.count)
        
        cell.cancelCardDelegate = self
        cell.actionSociaDelegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewController = UIStoryboard(name: "TodoPostDetails", bundle: nil).instantiateViewController(withIdentifier: "postDetailsId") as! SocialPostDetailsViewController
        detailsViewController.hidesBottomBarWhenPushed = true
        
        let socialPost = store.getCalendarSocialPostsForCard(store.getCalendarCards()[indexPath.section], datesSelected: 0)[indexPath.row]
        
        detailsViewController.socialDelegate = self
        detailsViewController.configureCalendar(calendarItem: socialPost, indexPath: indexPath)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    */
    
    @objc private func goToNextTab() {
        self.tabBarController?.selectedIndex = 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tableViewCellTransition = TableViewCellTransition()
        
        if !UserStore.didShowedTransitionFromTodo {
           tableViewCellTransition.animateDisplayLoadindFirstTimeCell(indexPath, cell: cell)
            return
        }
 
        if UserStore.didShowedTransitionFromTodo {
            if !stopAnimatingAfterScroll {
                tableViewCellTransition.animateDisplayLoadindCell(indexPath, cell: cell, completion: {
                    self.stopAnimatingAfterScroll = true
                })
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let calendarSection = CalendarSection(rawValue: indexToSection[section]!)?.rawValue else {
            return UIView()
        }
        
        if store.getCalendarCards().count == 0 {
            return UIView()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardHeaderCell") as! CardHeaderCell
        cell.sectionTitleLabel.text = calendarSection.uppercased()
        return cell
        
        
        let socialPosts = store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected)

        if socialPosts.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardHeaderCell") as! CardHeaderCell
            cell.sectionTitleLabel.text = calendarSection.uppercased()
            return cell
        } else {
            let sectionCard = store.getCalendarCards()[section]
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "CalendarHeaderViewCell") as! CalendarHeaderViewCell
            headerCell.changeColor(color: sectionCard.getSectionColor)
            headerCell.changeTitleSection(title: sectionCard.getCardSectionTitle)
            return headerCell.containerView
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.indexToSection.count
    }
    
    func changeTopHeaderTitle(section: Int) {
        if section < store.countSections() {
            if store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected).count != 0 {
                let item = store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected)[0]
                topHeaderView.changeTitle(title: item.socialTextString)
                topHeaderView.changeColorCircle(color: item.getSectionColor)
                if (item.status == "unapproved") {
                    topHeaderView.changeColorCircle(color: PopmetricsColor.blueURLColor);
                }
            } else {
                let card = store.getCalendarCards()[section]
                topHeaderView.changeTitle(title: card.section)
                topHeaderView.changeColorCircle(color: card.getSectionColor)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let calendarSection = CalendarSection.init(rawValue: self.indexToSection[section]!)
            else { return 0 }
        return countPostsInSection(calendarSection.rawValue)
    }
    
    func getCardInSection( _ section: String, atIndex:Int) -> CalendarCard {
        let nonEmptyCards = store.getNonEmptyCalendarCardsWithSection(section)
        if nonEmptyCards.count == 0 {
            let emptyCards = store.getEmptyCalendarCardsWithSection(section)
            return emptyCards[atIndex]
        }
        else {
            return nonEmptyCards[atIndex]
        }
    }
    
    func countPostsInSection( _ section: String) -> Int {
        
        var nonEmptyCards = store.getNonEmptyCalendarCardsWithSection(section)
        if nonEmptyCards.count == 0 {
            let emptyCards = store.getEmptyCalendarCardsWithSection(section)
            return emptyCards.count
        }
        else {
            let socialPosts = store.getCalendarSocialPostsForCard(nonEmptyCards[0], datesSelected: datesSelected)
            //to display empty card
            if socialPosts.count == 0 {
                return 1
            }
            return socialPosts.count
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        return
        let yVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        if yVelocity < 0 {
            calendarViewController?.animateTopPart(shouldCollapse: true, offset: scrollView.contentOffset.y)
        } else if yVelocity > 0 {
            calendarViewController?.animateTopPart(shouldCollapse: false, offset: scrollView.contentOffset.y)
        } else {
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)
            if translation.y > 0 {
                calendarViewController?.animateTopPart(shouldCollapse: false, offset: scrollView.contentOffset.y)
            } else {
                calendarViewController?.animateTopPart(shouldCollapse: true, offset: scrollView.contentOffset.y)
            }
            
        }
        
        var fixedHeaderFrame = self.topHeaderView.frame
        fixedHeaderFrame.origin.y = 0 + scrollView.contentOffset.y
        topHeaderView.frame = fixedHeaderFrame
        
        if let indexes = tableView.indexPathsForVisibleRows {
            for index in indexes {
                if(store.countSections() == 0) {
                    return
                }
                let indexPath = IndexPath(row: 0, section: index.section)
                guard let lastRowInSection = indexes.last , indexes.first?.section == index.section else {
                    return
                }
                let headerFrame = tableView.rectForHeader(inSection: index.section)
                
                let frameOfLastCell = tableView.rectForRow(at: lastRowInSection)
                let cellFrame = tableView.rectForRow(at: indexPath)
                if headerFrame.origin.y + 50 < tableView.contentOffset.y {
                    scrollToRow = indexPath
                    self.changeTopHeaderTitle(section: index.section)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        return
        let initialHeight = 56 as CGFloat
        if scrollView.contentOffset.y <= initialHeight {
            calendarViewController?.animateTopPart(shouldCollapse: false, offset: scrollView.contentOffset.y)
        } else {
            calendarViewController?.animateTopPart(shouldCollapse: true, offset: scrollView.contentOffset.y)
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
                self.topHeaderView.displayElements(isHidden: true)
            } else {
                self.topHeaderView.frame.size.height = 30
                self.topHeaderView.displayElements(isHidden: false)
            }
            self.topHeaderView.layoutIfNeeded()
        }, completion: { (completed) in
            self.isAnimatingHeader = false
        })
    }
    
    func updateStateLoadMore(_ footerView: TableFooterView, section: Int) {
        let posts = store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected)
        if( posts.count <= noItemsLoaded[section]) {
            footerView.setUpLoadMoreDisabled()
        }
    }
    
    func noItemsLoaded(_ section: Int) -> Int {
        if( noItemsLoaded.isEmpty ) {
            noItemsLoaded.append(noItemsLoadeInitial)
        }
        return noItemsLoaded[section]
    }
    
    func changeNoItemsLoaded(_ section: Int, value: Int) {
        if( noItemsLoaded.isEmpty ) {
            noItemsLoaded[section] = noItemsLoadeInitial
        }
        noItemsLoaded[section] += value
    }
    
    func itemsToLoad(section: Int) -> Int {
        if (store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected).count > noItemsLoaded(section)) {
            return noItemsLoaded(section)
        } else {
            return store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected).count
        }
        return noItemsLoadeInitial
    }
    
    func loadMore(section: Int) {
        var addItem = noItemsLoadeInitial
        let posts = store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected)
        if (posts.count > noItemsLoaded(section) + noItemsLoadeInitial) {
            addItem = noItemsLoadeInitial
        } else {
            addItem = posts.count - noItemsLoaded(section)
        }
        changeNoItemsLoaded(section, value: addItem)
        tableView.reloadData()
    }
    
    func reloadTableByDate(date: Date) {
        
    }
    
    func removeCellFromTable(indexPath: IndexPath) {
        try! store.realm.write {
              store.realm.delete(store.getCalendarSocialPostsForCard(store.getCalendarCards()[indexPath.section], datesSelected: datesSelected)[indexPath.row])
            }
            
            if !store.getCalendarSocialPostsForCard(store.getCalendarCards()[indexPath.section], datesSelected: datesSelected).isEmpty {
                self.tableView.deleteRows(at: [indexPath], with: .middle)
            } else {
                self.tableView.reloadData()
        }
    }
    
    func removeCell(indexPath: IndexPath) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            DispatchQueue.main.async {
                self.removeCellFromTable(indexPath: indexPath)
            }
        }
    }
    
}

extension CalendarHubController: FooterActionHandlerProtocol {
    func handlerAction(section: Int) {
        loadMore(section: section)
    }
}

// MARK: Notification Handlers
extension CalendarHubController {
    func catchUiRefreshRequiredNotification(notification:Notification) -> Void {
        self.tableView.reloadData()
    }
}

//MARK: Calendar Card Action handler
extension CalendarHubController:  CalendarCardActionHandler {
    func handleCardAction(_ action: String, calendarCard: CalendarCard, params: [String : Any]) {
        print(calendarCard)
    }
}

extension CalendarHubController: ActionSocialPostProtocol {
    func cancelPostFromSocial(post: CalendarSocialPost, indexPath: IndexPath) {
        CalendarApi().cancelPost(post.postId!, callback: {
            () -> Void in
            self.removeCell(indexPath: indexPath)
        })
        
        
        
    }
}
