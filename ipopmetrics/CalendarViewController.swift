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

class CalendarViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: MJCalendarView!
    
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var currentDateBtn: UIView!
    @IBOutlet weak var topPickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topPickerStackView: UIStackView!
    @IBOutlet weak var todayLabelView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var topPickerStackViewWrapper: UIView!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topPickerStackViewHeight: NSLayoutConstraint!
    var calendarNoteView: NoteView!
    
    @IBOutlet weak var topAnchorTableView: NSLayoutConstraint!
    let transitionView = UIView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    let store = CalendarFeedStore.getInstance()
    
    var scrollToRow: IndexPath = IndexPath(row: 0, section: 0)
    var reachedFooter = false
    var shouldMaximizeCell = false
    var isLastCell = false
    let noItemsLoadeInitial = 3
    var datesSelected = 0
    var noItemsLoaded: [Int] = [3,3,3,3,3]
    var dayColors = Dictionary<Date, UIColor>()
    
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    internal var topHeaderView: HeaderView!
    internal var isAnimatingHeader: Bool = false
    
    
    var currentBrandId = UsersStore.currentBrandId
    
    var shouldReloadData: Bool = false
    fileprivate var animateCard = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        

        registerCellsForTable()
        
        tableView.separatorStyle = .none
        setupTopHeaderView()
        self.setUpCalendarConfiguration()
        addDivider()
        
        topHeaderView.displayElements(isHidden: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(CalendarViewController.tapFunction))
        currentDateBtn.isUserInteractionEnabled = true
        currentDateBtn.addGestureRecognizer(tap)
        
        DispatchQueue.main.async {
            self.animateToPeriod(.oneWeek)
            self.nextButton.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.todayLabelView.layer.borderColor = PopmetricsColor.textGrey.cgColor
            self.todayLabelView.layer.borderWidth = 2.0
            self.todayLabelView.layer.cornerRadius = self.todayLabelView.bounds.width / 2
            self.todayLabelView.layer.masksToBounds = true
        }
        
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
    
    func addNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(didPostActionHandler), name: NSNotification.Name("didPostAction"), object: nil)
        
        nc.addObserver(forName:Notification.Popmetrics.UiRefreshRequired, object:nil, queue:nil, using:catchUiRefreshRequiredNotification)
        
        nc.addObserver(self, selector: #selector(handlerAnimateCardAppearance), name: Notification.Name("animateRow"), object: nil)
        
    }
    
    internal func handlerAnimateCardAppearance() {
        animateCard = true
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
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "headerCell")
        
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
            calendarItem.cardId = "calendarID"
            calendarItem.message = "Calendar card for animation testing"
            calendarItem.section = "Scheduled"
            calendarItem.status = "Scheduled"
            
            let calendarPost = CalendarSocialPost()
            calendarPost.section = "Scheduled"
            calendarPost.calendarCard = calendarItem
            calendarPost.calendarCardId = "calendarID"
            calendarPost.postId = "post_one"
            calendarPost.status = "Scheduled"
            calendarPost.scheduledDate = Date()
            
            store.realm.add(calendarItem, update: true)
            
            store.realm.add(calendarPost, update: true)
            //store.realm.delete(calendarPost)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /*
        transitionView.alpha = 0.7
        let tabInfo = MainTabInfo.getInstance()
        let xValue = tabInfo.currentItemIndex >= tabInfo.lastItemIndex ? CGFloat(20) : CGFloat(-20)
        transitionView.frame.origin.x = xValue
        
        UIView.transition(with: tableView,
                          duration: 0.22,
                          animations: {
                            self.transitionView.frame.origin.x = 0
                            self.transitionView.alpha = 1
        })
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        calendarView.reloadView()
        createItemsLocally()
        
        tableView.isHidden = false
    }
    
    func handlerDidChangeTwitterConnected(_ sender: AnyObject) {
    }
    
    func setupTopHeaderView() {
        if topHeaderView == nil {
            topHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
            tableView.addSubview(topHeaderView)
            topHeaderView.displayIcon(display: true)
            topHeaderView.btn.addTarget(self, action: #selector(handlerExpand), for: .touchUpInside)
            
            let labelTap = UITapGestureRecognizer(target: self, action: #selector(handlerExpand))
            topHeaderView.iconLbl.isUserInteractionEnabled = true
            topHeaderView.iconLbl.addGestureRecognizer(labelTap)
        }
    }
    
    func handlerExpand() {
        maximizeCell()
    }
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Calendar", style: .plain, target: self, action: nil)
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
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MENU_VC") as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
    }
    
}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate, ChangeCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        isLastCell = false
        if isLastSection(section: sectionIdx) {
            isLastCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
            cell.changeTitleWithSpacing(title: "Thats it for now");
            cell.changeMessageWithSpacing(message: "Check back to see if there is anything more in the Home Feed")
            cell.titleActionButton.text = "View Home Feed"
            cell.goToButton.imageButtonType = .lastCardCalendar
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
        
        if shouldMaximizeCell == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCardSimple", for: indexPath) as! CalendarCardSimpleViewCell
            cell.configure(item)
            cell.cancelCardDelegate = self
            cell.maximizeDelegate = self
            
            cell.layer.transform = CATransform3DMakeScale(1, 0.0, 1)
            
            
            if animateCard {
                cell.layer.transform = CATransform3DMakeScale(1,0.0,1)
                //animateCellAppearance(cell: cell)
            }
            return cell
        } else {
            let maxCell = tableView.dequeueReusableCell(withIdentifier: "extendedCell", for: indexPath) as! CalendarCardMaximizedViewCell
            tableView.allowsSelection = false
            maxCell.topImageButton.isHidden = true
            maxCell.setUpApprovedConnectionView()
            let itemsCount = store.getCalendarSocialPostsForCard(store.getCalendarCards()[indexPath.section], datesSelected: datesSelected).count
            maxCell.configure(item)
            
            if indexPath.row == (itemsCount - 1) {
                maxCell.connectionStackView.isHidden = true
                maxCell.isLastCell = true
            } else {
                maxCell.connectionStackView.isHidden = false
            }
            
            return maxCell
        }
    }
    
    func animateCellAppearance(cell: CalendarCardSimpleViewCell) {
        Timer.init(timeInterval: 2, repeats: false) { (timer) in
            UIView.animate(withDuration: 2) {
                cell.layer.transform = CATransform3DMakeScale(1,1,1)
            }
            
            self.animateCard = false
        }
        
    }
    
    func getCalendarPosts() {
        
    }
    
    @objc private func goToNextTab() {
        self.tabBarController?.selectedIndex = 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //last section don't have an header view
        if( isLastSection(section: section)) {
            return UIView()
        }
        
        let sectionCard = store.getCalendarCards()[section]
        
        
        if shouldMaximizeCell || store.getCalendarSocialPostsForCard(store.getCalendarCards()[section], datesSelected: datesSelected).count == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCardCell") as! HeaderCardCell
            headerCell.changeColor(color: sectionCard.getSectionColor)
            headerCell.changeTitle(title: sectionCard.socialTextString)
            return headerCell
        }
        else {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CalendarHeaderViewCell
            headerCell.changeColor(color: sectionCard.getSectionColor)
            headerCell.changeTitleToolbar(title: "")
            headerCell.changeTitleSection(title: sectionCard.getCardSectionTitle)
            return headerCell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getCountSection()
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
        if shouldMaximizeCell == false {
            return 93
        }
        return 459
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
        if shouldMaximizeCell == false {
            return 109
        } else {
            return 80
        }
        
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
            animateTopPart(shouldCollapse: true, offset: scrollView.contentOffset.y)
        } else if yVelocity > 0 {
            animateTopPart(shouldCollapse: false, offset: scrollView.contentOffset.y)
        } else {
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)
            if translation.y > 0 {
                animateTopPart(shouldCollapse: false, offset: scrollView.contentOffset.y)
            } else {
                animateTopPart(shouldCollapse: true, offset: scrollView.contentOffset.y)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let initialHeight = 56 as CGFloat
        if scrollView.contentOffset.y <= initialHeight {
            animateTopPart(shouldCollapse: false, offset: scrollView.contentOffset.y)
        } else {
            animateTopPart(shouldCollapse: true, offset: scrollView.contentOffset.y)
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
    
    func maximizeCell() {
        shouldMaximizeCell = !shouldMaximizeCell
        
        tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: self.scrollToRow, at: .none, animated: false)
        }
        
        let type = shouldMaximizeCell ? HeaderViewType.expand : HeaderViewType.minimize
        topHeaderView.changeStatus(type: type)
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

extension CalendarViewController: MJCalendarViewDelegate {
    func setUpCalendarConfiguration() {
        self.calendarView.calendarDelegate = self
        // Set displayed period type. Available types: Month, ThreeWeeks, TwoWeeks, OneWeek
        self.calendarView.configuration.periodType = .month
        
        // Set shape of day view. Available types: Circle, Square
        self.calendarView.configuration.dayViewType = .circle
        
        // Set selected day display type. Available types:
        // Border - Only border is colored with selected day color
        // Filled - Entire day view is filled with selected day color
        self.calendarView.configuration.selectedDayType = .filled
        
        // Set day text color
        self.calendarView.configuration.dayTextColor = PopmetricsColor.textGrey
        
        // Set day background color
        self.calendarView.configuration.dayBackgroundColor = UIColor.white
        
        // Set selected day text color
        self.calendarView.configuration.selectedDayTextColor = PopmetricsColor.textGrey
        //self.calendarView.configuration.selectedBorderWidth = 0
        // Set selected day background color
        //self.calendarView.configuration.selectedDayBackgroundColor = UIColor(hexString: "2FBD8F")
        
        // Set other month day text color. Relevant only if periodType = .Month
        //self.calendarView.configuration.otherMonthTextColor = UIColor(hexString: "6f787c")
        
        // Set other month background color. Relevant only if periodType = .Month
        //self.calendarView.configuration.otherMonthBackgroundColor = UIColor(hexString: "E7E7E7")
        
        // Set week text color
        self.calendarView.configuration.weekLabelTextColor = PopmetricsColor.weekDaysGrey
        
        // Set start day. Available type: .Monday, Sunday
        self.calendarView.configuration.startDayType = .sunday
        
        // Set day text font
        self.calendarView.configuration.dayTextFont = UIFont(name: "OpenSans", size: 18.0)!
        
        //Set week's day name font
        self.calendarView.configuration.weekLabelFont = UIFont(name: "OpenSans-Semibold", size: 12.0)!
        
        //Set day view size. It includes border width if selectedDayType = .Border
        self.calendarView.configuration.dayViewSize = CGSize(width: 24, height: 24)
        
        //Set height of row with week's days
        self.calendarView.configuration.rowHeight = 45
        
        // Set height of week's days names view
        self.calendarView.configuration.weekLabelHeight = 17
        
        //Set the day names to one letter
        self.calendarView.configuration.lettersInWeekDayLabel = .one
        
        //Set min date
        self.calendarView.configuration.minDate = (Date() as NSDate).subtractingDays(60)
        
        //Set max date
        self.calendarView.configuration.maxDate = (Date() as NSDate).addingDays(60)
        
        self.calendarView.configuration.selectDayOnPeriodChange = false
        
        // To commit all configuration changes execute reloadView method
        self.calendarView.reloadView()
    }
    
    func setTitleWithDate(_ date: NSDate) {
        if calendarView.shouldChangePeriodsRange() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            let startDate = dateFormatter.string(from: date.atStartOfWeek())
            let endDate = dateFormatter.string(from: date.atEndOfWeek())
            self.dateRangeLabel.text = "\(startDate) - \(endDate)"
        }
    }
    
    func calendar(_ calendarView: MJCalendarView, didChangePeriod periodDate: Date, bySwipe: Bool) {
        self.setTitleWithDate(periodDate as NSDate)
        let date = self.calendarView.visiblePeriodDate as NSDate
        self.store.selectedWeek = DateInterval(start: date.atStartOfWeek(), end: date.atEndOfWeek())
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func calendar(_ calendarView: MJCalendarView, backgroundForDate date: Date) -> UIColor? {
        return nil
    }
    
    func calendar(_ calendarView: MJCalendarView, textColorForDate date: Date) -> UIColor? {
        return dayColors[date]
    }
    
    func calendar(_ calendarView: MJCalendarView, didSelectDate date: Date) {
        setupDates(date)
    }
    
    func setupDates(_ date: Date) {
        print(datesSelected)
        switch datesSelected {
        case 0:
            resetColors()
            store.selectedDate = date
            self.calendarView.configuration.selectedDayTextColor = PopmetricsColor.greenSelectedDate
            datesSelected = 1
        case 1:
            if date == store.selectedDate {
                self.calendarView.configuration.selectedDayTextColor = PopmetricsColor.textGrey
                datesSelected = 0
            } else {
                if date < store.selectedDate {
                    let startDate = date
                    let endDate = store.selectedDate
                    setUpDays(120, startDate, endDate)
                    store.selectedRange = DateInterval(start: startDate.startOfDay, end: endDate.endOfDay)
                } else if date > store.selectedDate{
                    let startDate = store.selectedDate
                    let endDate = date
                    setUpDays(120, startDate, endDate)
                    store.selectedRange = DateInterval(start: startDate.startOfDay, end: endDate.endOfDay)
                }
                store.selectedDate = date
                datesSelected = 2
            }
        case 2:
            resetColors()
            store.selectedDate = date
            datesSelected = 1
        default:
            break
        }
        print(datesSelected)
        self.calendarView.reloadView()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func dateByIndex(_ index: Int, daysRange: Int) -> Date {
        let startDay = ((Date() as NSDate).atStartOfDay() as NSDate).subtractingDays(daysRange / 2)
        let day = (startDay as NSDate).addingDays(index)
        return day
    }
    
    func setUpDays(_ daysRange: Int, _ startDate: Date, _ endDate: Date) {
        for i in 0...daysRange {
            let day = self.dateByIndex(i, daysRange: daysRange)
            if day >= startDate && day <= endDate {
                self.dayColors[day] = PopmetricsColor.greenSelectedDate
            } else {
                self.dayColors[day] = nil
            }
        }
    }
    
    func resetColors() {
        for i in 0...120 {
            let day = self.dateByIndex(i, daysRange: 120)
            self.dayColors[day] = nil
        }
    }
    
    func animateTopPart(shouldCollapse: Bool, offset: CGFloat) {
        UIView.animate(withDuration: 0.4, animations: {
            let initialHeight = 56.0 as CGFloat
            //let initialStackHeight = 27.0 as CGFloat
            if shouldCollapse {
                if offset <= initialHeight && offset >= 0{
                    self.topPickerViewHeight.constant = initialHeight - offset
                } else {
                    self.topPickerStackView.alpha = 0.0
                    self.topPickerStackView.isHidden = true
                    //self.topPickerViewHeight.constant = 0
                }
            } else {
                if offset <= initialHeight {
                    self.topPickerStackView.alpha = 1.0
                    self.topPickerStackView.isHidden = false
                    if offset >= 10 {
                        self.topPickerViewHeight.constant = initialHeight - offset
                    } else {
                        self.topPickerViewHeight.constant = initialHeight
                    }
                }
            }
        }, completion: nil)
    }
    
    func animateToPeriod(_ period: MJConfiguration.PeriodType) {
        self.calendarView.animateToPeriodType(period, duration: 0.1, animations: { (calendarHeight) -> Void in
            // In animation block you can add your own animation. To adapat UI to new calendar height you can use calendarHeight param
            self.calendarHeight.constant = calendarHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    @IBAction func nextPeriodBtnPressed(_ sender: Any) {
        self.calendarView.moveToNextPeriod()
        let date = self.calendarView.visiblePeriodDate as NSDate
        self.store.selectedWeek = DateInterval(start: date.atStartOfWeek(), end: date.atEndOfWeek())
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func previousPeriodBtnPressed(_ sender: Any) {
        self.calendarView.moveToPreviousPeriod()
        let date = self.calendarView.visiblePeriodDate as NSDate
        self.store.selectedWeek = DateInterval(start: date.atStartOfWeek(), end: date.atEndOfWeek())
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        self.calendarView.configuration.selectedDayTextColor = PopmetricsColor.greenSelectedDate
        self.calendarView.reloadDayViews()
        self.calendarView.goToCurrentDay()
        let currentDate = NSDate().atStartOfDay()
        resetColors()
        self.store.selectedDate = currentDate
        self.datesSelected = 0
        setupDates(currentDate)
        self.tableView.reloadData()
        
    }
    
    func addDivider() {
        let divider = UIView(frame: CGRect(x: -17, y: self.topPickerStackViewWrapper.frame.height - 0.5, width: self.topPickerStackViewWrapper.frame.width, height: 0.5))
        divider.backgroundColor = PopmetricsColor.dividerBorder
        self.topPickerStackViewWrapper.addSubview(divider)
    }
}


extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
}
