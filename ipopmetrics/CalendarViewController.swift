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

class CalendarViewController: BaseViewController, ContainerToMaster {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var divider: UIView!

    @IBOutlet weak var topAnchorTableView: NSLayoutConstraint!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    
    var calendarNoteView: NoteView!
    @IBOutlet weak var calendarViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var calendarView: UIView!
    
    let transitionView = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let store = CalendarFeedStore.getInstance()
    
    internal var calendarViewController: MJCalendarViewController?
    internal var scrollToRow: IndexPath = IndexPath(row: 0, section: 0)
    internal var reachedFooter = false
    internal var shouldMaximizeCell = false
    internal var isLastCell = false
    internal let noItemsLoadeInitial = 3
    internal var datesSelected = 0
    internal var noItemsLoaded: [Int] = [3,3,3,3,3]
    internal var masterToContainer:MasterToContainer?
    internal var topHeaderView: HeaderView!
    internal var isAnimatingHeader: Bool = false
    var stopAnimatingAfterScroll = false
    
    var currentBrandId = UsersStore.currentBrandId
    
    var shouldReloadData: Bool = false
    fileprivate var didAnimateCardFirstTime = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        

        registerCellsForTable()
        
        tableView.separatorStyle = .none
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
        
        //createItemsLocally()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calendarViewControllerSegue" {
            calendarViewController = segue.destination as? MJCalendarViewController
            calendarViewController!.containerToMaster = self
        }
    }
    
    func setDatesSelected(datesSelected: Int) {
        self.datesSelected = datesSelected
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
        
        let sectionHeaderNib = UINib(nibName: "CalendarHeader", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "CardHeaderView")
        
        let sectionHeaderCardNib = UINib(nibName: "HeaderCardCell", bundle: nil)
        tableView.register(sectionHeaderCardNib, forCellReuseIdentifier: "headerCardCell")
        
        
        tableView.register(TableFooterView.self, forHeaderFooterViewReuseIdentifier: "footerId")
        
        let extendedCardNib = UINib(nibName: "CalendarCardMaximized", bundle: nil)
        tableView.register(extendedCardNib, forCellReuseIdentifier: "extendedCell")
        
        let emptyCard = UINib(nibName: "EmptyCard", bundle: nil)
        tableView.register(emptyCard, forCellReuseIdentifier: "EmptyCard")
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")
    }
    
    @objc func didPostActionHandler() {
        self.shouldReloadData = true
    }
    
    func createItemsLocally() {
        try! store.realm.write {
            
            let calendarItem = CalendarCard()
            calendarItem.cardId = "fdsafsda8fsd9afsd98"
            //calendarItem.message = "Calendar card for animation testing"
            calendarItem.section = "Scheduled"
            calendarItem.status = "Scheduled"
            store.realm.add(calendarItem, update: true)
            
            
            let calendarPost = CalendarSocialPost()
            calendarPost.section = "Scheduled"
            calendarPost.calendarCard = calendarItem
            calendarPost.calendarCardId = "adsfasf42551dsag"
            calendarPost.postId = "fdsafdsa254sdagasg"
            calendarPost.status = "Scheduled"
            calendarPost.scheduledDate = Date()
            store.realm.add(calendarPost, update: true)
            
            let calendarPost1 = CalendarSocialPost()
            calendarPost1.section = "Scheduled"
            calendarPost1.calendarCard = calendarItem
            calendarPost1.calendarCardId = "asdfsadf942423afa"
            calendarPost1.postId = "sagsag2sagsag"
            calendarPost1.status = "Scheduled"
            calendarPost1.scheduledDate = Date()
            store.realm.add(calendarPost1, update: true)
            
            let calendarPost2 = CalendarSocialPost()
            calendarPost2.section = "Scheduled"
            calendarPost2.calendarCard = calendarItem
            
            calendarPost2.postId = "asdfasdfsaf"
            calendarPost2.status = "Scheduled"
            calendarPost2.scheduledDate = Date()
            store.realm.add(calendarPost2, update: true)
            
            let calendarComplete = CalendarCard()
            calendarComplete.section = StatusArticle.completed.rawValue
            calendarComplete.cardId = "dsfasdfasf2252525r"
            calendarComplete.status = "completed"
            
            store.realm.add(calendarComplete, update: true)
    
        }
        
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

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        isLastCell = false
        if isLastSection(section: sectionIdx) {
            isLastCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! EmptyStateCardCell
            cell.changeTitleWithSpacing(title: "Thats it for now");
            cell.changeMessageWithSpacing(message: "Check back to see if there is anything more in the Home Feed")
            cell.goToButton.changeTitle("View Home Feed")
            cell.goToButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        let sectionCards = store.getCalendarSocialPostsForCard(store.getCalendarCards()[sectionIdx], datesSelected: datesSelected)
        let card = store.getCalendarCards()[sectionIdx]
        if sectionCards.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCard", for: indexPath) as! EmptyCardView
            cell.setupView(type: .calendar, calendarStatus: StatusArticle(rawValue: (card.section))!)
            cell.backgroundColor = UIColor.feedBackgroundColor()
            cell.selectionStyle = .none
            return cell
        }
        
        let item = sectionCards[rowIdx]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCardSimple", for: indexPath) as! CalendarCardSimpleViewCell
        cell.configure(item)
        cell.indexPath = indexPath
        cell.cancelCardDelegate = self
        cell.actionSociaDelegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewController = UIStoryboard(name: "TodoPostDetails", bundle: nil).instantiateViewController(withIdentifier: "postDetailsId") as! SocialPostDetailsViewController
        detailsViewController.hidesBottomBarWhenPushed = true
        
        let socialPost = store.getCalendarSocialPostsForCard(store.getCalendarCards()[indexPath.section], datesSelected: 0)[indexPath.row]
        
        detailsViewController.socialDelegate = self
        detailsViewController.configureCalendar(calendarItem: socialPost, indexPath: indexPath)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    
    func getCalendarPosts() {
        
    }
    
    @objc private func goToNextTab() {
        self.tabBarController?.selectedIndex = 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tableViewCellTransition = TableViewCellTransition()
        
        if(store.getCalendarCards().count < 3) {
            //return
        }
        
        if !UsersStore.didShowedTransitionFromTodo {
           tableViewCellTransition.animateDisplayLoadindFirstTimeCell(indexPath, cell: cell)
            return
        }
 
        if UsersStore.didShowedTransitionFromTodo {
            if !stopAnimatingAfterScroll {
                tableViewCellTransition.animateDisplayLoadindCell(indexPath, cell: cell, completion: {
                    self.stopAnimatingAfterScroll = true
                })
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //last section don't have an header view
        if( isLastSection(section: section)) {
            return UIView()
        }
        
        let sectionCard = store.getCalendarCards()[section]
        
        if store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected).count == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCardCell") as! HeaderCardCell
            headerCell.changeColor(color: sectionCard.getSectionColor)
            headerCell.changeTitle(title: sectionCard.socialTextString)
            return headerCell.containerView
        }
        else {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "CardHeaderView") as! CalendarHeaderViewCell
            headerCell.changeColor(color: sectionCard.getSectionColor)
            headerCell.changeTitleToolbar(title: "")
            headerCell.changeTitleSection(title: sectionCard.getCardSectionTitle)
            return headerCell.containerView
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getCountSection()
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
        if (isLastSection(section: section)) {
            return 1
        } else if store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected).isEmpty {
            return 1
        }
        return itemsToLoad(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ( isLastSection(section: indexPath.section) ) {
            return 261
        }
        if store.getCalendarSocialPostsForCard(store.getCalendarCards()[indexPath.section], datesSelected: datesSelected).isEmpty {
            return 216
        }

        return 148
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isLastSection(section: section) || store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected).isEmpty {
            return UIView()
        }
        let todoFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerId") as! TableFooterView
        todoFooter.changeFeedType(feedType: FeedType.calendar)
        todoFooter.buttonActionHandler = self
        todoFooter.xButton.isHidden = true
        updateStateLoadMore(todoFooter, section: section)
        
        return todoFooter
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //last card
        if isLastSection(section: section){
            return 40
        }
        // when there it's no social posts
        let posts = store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected)
        if(posts.count == 0) {
            return 80
        }
        return 109
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        //last card
        if isLastSection(section: section) {
            return 0
        }
        if store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected).isEmpty {
            return 0
        }
        return 80
    }
    
    func getCountSection() -> Int {
        //check if we receive card that has empty social post
        
        if( store.getCalendarCards().count == 1) {
            if( store.getCalendarSocialPostsForCard(store.getCalendarCards()[0], datesSelected: datesSelected).count == 0) {
                return 1
            }
        }
        
        return store.getCalendarCards().count + 1 // adding the last card
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
    
    func isLastSection(section: Int) -> Bool {
        if section == store.getCalendarCards().count {
            return true
        }
        return false
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

extension CalendarViewController: FooterActionHandlerProtocol {
    func handlerAction(section: Int) {
        loadMore(section: section)
    }
}

// MARK: Notification Handlers
extension CalendarViewController {
    func catchUiRefreshRequiredNotification(notification:Notification) -> Void {
        self.tableView.reloadData()
    }
}

//MARK: Calendar Card Action handler
extension CalendarViewController:  CalendarCardActionHandler {
    func handleCardAction(_ action: String, calendarCard: CalendarCard, params: [String : Any]) {
        print(calendarCard)
    }
}

extension CalendarViewController: ActionSocialPostProtocol {
    func cancelPostFromSocial(post: CalendarSocialPost, indexPath: IndexPath) {
        removeCell(indexPath: indexPath)
    }
}
