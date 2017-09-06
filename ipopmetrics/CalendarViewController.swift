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

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: MJCalendarView!
    
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var currentDateBtn: UIView!
    @IBOutlet weak var topPickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rightArrow: UIButton!
    @IBOutlet weak var topPickerStackView: UIStackView!
    @IBOutlet weak var todayLabelView: UIView!
    
    
    @IBOutlet weak var topPickerStackViewWrapper: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topPickerStackViewHeight: NSLayoutConstraint!
    
    let store = CalendarFeedStore.getInstance()
    
    var reachedFooter = false
    var shouldMaximizeCell = false
    
    let noItemsLoadeInitial = 3
    
    var noItemsLoaded: [Int] = [3,3,3,3,3]
    
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    internal var topHeaderView: HeaderView!
    internal var isAnimatingHeader: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
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
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")
        
        
        tableView.separatorStyle = .none
        setupTopHeaderView()
        self.setUpCalendarConfiguration()
        addDivider()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CalendarViewController.tapFunction))
        currentDateBtn.isUserInteractionEnabled = true
        currentDateBtn.addGestureRecognizer(tap)
        DispatchQueue.main.async {
            self.animateToPeriod(.oneWeek)
            self.rightArrow.transform = CGAffineTransform(scaleX: -1, y: 1)
            self.todayLabelView.layer.borderColor = PopmetricsColor.textGrey.cgColor
            self.todayLabelView.layer.borderWidth = 2.0
            self.todayLabelView.layer.cornerRadius = self.todayLabelView.bounds.width / 2
            self.todayLabelView.layer.masksToBounds = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlerDidChangeTwitterConnected(_:)), name: Notification.Name("didChangeTwitterConnected"), object: nil);
        

        createItemsLocally()

    }
    
    internal func createItemsLocally() {
        
        try! store.realm.write {
            let calendarCard = CalendarCard()
            calendarCard.cardId = "41345"
            calendarCard.section = "scheduled"
            store.realm.add(calendarCard, update: true)
            
            let post1: CalendarSocialPost = CalendarSocialPost()
            post1.calendarCard = calendarCard
            post1.postId = "asdfasdfsa"
            post1.status = "scheduled"
            post1.statusDate = Date()
            post1.articleTitle = "Toronto Real Estate Skyrecketing"
            post1.articleCategory = "Local News"
            post1.articleText = "The wildfires continue to affect the Northern Provinces Alch.my/AGGA #wildfire";
            post1.articleHashtags = "wildfire"
            post1.articleImage = "image_toronto"
            store.realm.add(post1, update:true)
            
            let post2: CalendarSocialPost = CalendarSocialPost()
            post2.calendarCard = calendarCard
            post2.postId = "twtwq"
            post2.status = "scheduled"
            post2.statusDate = Date()
            post2.articleTitle = "Optimizing Your Website"
            post2.articleCategory = "Local News"
            post2.articleText = "TWhy is SEO such a challenging yet integral part of a building a successful website? Alch.my/AGGA #wildfire";
            post2.articleHashtags = "wildfire"
            post2.articleImage = "image_optimize"
            store.realm.add(post2, update:true)
            
            let post3: CalendarSocialPost = CalendarSocialPost()
            post3.calendarCard = calendarCard
            post3.postId = "tw34twq"
            post3.status = "scheduled"
            post3.statusDate = Date()
            post3.articleTitle = "Scheduling Social Media"
            post3.articleCategory = "Local News"
            post3.articleText = "Where do you want to start with social media schedulling? Find out here! Alch.my/AGGA #socialmedia #scheduling?";
            post3.articleHashtags = "wildfire"
            post3.articleImage = "imageScheduleSocial"
            store.realm.add(post3, update:true)
            
            let post4: CalendarSocialPost = CalendarSocialPost()
            post4.calendarCard = calendarCard
            post4.postId = "twadtwq"
            post4.status = "scheduled"
            post4.statusDate = Date()
            post4.articleTitle = "Scheduling Social Media"
            post4.articleCategory = "Local News"
            post4.articleText = "Where do you want to start with social media schedulling? Find out here! Alch.my/AGGA #socialmedia #scheduling?";
            post4.articleHashtags = "wildfire"
            post4.articleImage = "imageScheduleSocial"
            store.realm.add(post4, update:true)
            
            let post5: CalendarSocialPost = CalendarSocialPost()
            post5.calendarCard = calendarCard
            post5.postId = "twtddwq"
            post5.status = "scheduled"
            post5.statusDate = Date()
            post5.articleTitle = "Scheduling Social Media"
            post5.articleCategory = "Local News"
            post5.articleText = "Where do you want to start with social media schedulling? Find out here! Alch.my/AGGA #socialmedia #scheduling?";
            post5.articleHashtags = "wildfire"
            post5.articleImage = "imageScheduleSocial"
            store.realm.add(post5, update:true)
            
            let post6: CalendarSocialPost = CalendarSocialPost()
            post6.calendarCard = calendarCard
            post6.postId = "tsadwtddwq"
            post6.status = "scheduled"
            post6.statusDate = Date()
            post6.articleTitle = "Scheduling Social Media"
            post6.articleCategory = "Local News"
            post6.articleText = "Where do you want to start with social media schedulling? Find out here! Alch.my/AGGA #socialmedia #scheduling?";
            post6.articleHashtags = "wildfire"
            post5.articleImage = "imageScheduleSocial"
            store.realm.add(post6, update:true)
            

            
            
            let calendarCompleteddCard = CalendarCard()
            calendarCompleteddCard.cardId = "413452"
            calendarCompleteddCard.section = "completed"
            
            store.realm.add(calendarCompleteddCard, update: true)
            
            let postCompleted1: CalendarSocialPost = CalendarSocialPost()
            postCompleted1.calendarCard = calendarCompleteddCard
            postCompleted1.postId = "iuueek"
            postCompleted1.status = "executed"
            postCompleted1.statusDate = Date()
            postCompleted1.articleTitle = "Toronto Real Estate Skyrecketing"
            postCompleted1.articleCategory = "Local News"
            postCompleted1.articleText = "The wildfires continue to affect the Northern Provinces Alch.my/AGGA #wildfire";
            postCompleted1.articleHashtags = "wildfire"
            postCompleted1.articleImage = "image_toronto"
            store.realm.add(postCompleted1, update:true)
            
            let postCompleted2: CalendarSocialPost = CalendarSocialPost()
            postCompleted2.calendarCard = calendarCompleteddCard
            postCompleted2.postId = "dsafsadf"
            postCompleted2.status = "executed"
            postCompleted2.statusDate = Date()
            postCompleted2.articleTitle = "Optimizing Your website with SEO"
            postCompleted2.articleCategory = "Local News"
            postCompleted2.articleText = "Thy is SEO such a challenging yet intergral part fo building a successful website? Alch.my/AGGA #SEO";
            postCompleted2.articleHashtags = "wildfire"
            postCompleted2.articleImage = "image_card_google"
            store.realm.add(postCompleted2, update:true)
            
        }
        
        print(store.getCalendarCards())
        print(store.getCalendarSocialPostsForCard(store.getCalendarCards()[0]))
        
    }
    
    
    func handlerDidChangeTwitterConnected(_ sender: AnyObject) {
    }
    
    func setupTopHeaderView() {
        if topHeaderView == nil {
            topHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
            tableView.addSubview(topHeaderView)
            topHeaderView.displayIcon(display: true)
            topHeaderView.btnIcon.addTarget(self, action: #selector(handlerExpand), for: .touchUpInside)
            
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

    
    func fetchItems(silent:Bool) {
//        //        let path = Bundle.main.path(forResource: "sampleFeed", ofType: "json")
//        //        let jsonData : NSData = NSData(contentsOfFile: path!)!
//        FeedApi().getItems("58fe437ac7631a139803757e") { responseDict, error in
//            
//            if error != nil {
//                let message = "An error has occurred. Please try again later."
//                EZAlertController.alert("Error", message: message)
//                return
//            }
//            if let code = responseDict?["code"] as? String {
//                if "success" != code {
//                    let message = responseDict?["message"] as! String
//                    EZAlertController.alert("Error", message: message)
//                    return
//                }
//            }
//            else {
//                EZAlertController.alert("Error", message: "An unexpected error has occured. Please try again later")
//                return
//            }
//            let dict = responseDict?["data"]
//            let code = responseDict?["code"] as! String
//            let feedStore = FeedStore.getInstance()
//            if "success" == code {
//                if dict != nil {
//                    feedStore.storeFeed(dict as! [String : Any])
//                }
//            }
//            
//            
//            //self.sections = feedStore.getFeed()
//            
//            if !silent { self.tableView.reloadData() }
//        }
        
    }
}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate, ChangeCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        let sectionCards = store.getCalendarSocialPostsForCard(store.getCalendarCards()[sectionIdx])
        let item = sectionCards[rowIdx]
    
    
        if item.type == "last_cell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
            cell.changeTitleWithSpacing(title: "Thats it for now");
            cell.changeMessageWithSpacing(message: "Check back to see if there is anything more in the Home Feed")
            cell.titleActionButton.text = "View Home Feed"
            cell.goToButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        
        if shouldMaximizeCell == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCardSimple", for: indexPath) as! CalendarCardSimpleViewCell
            cell.configure(item)
            cell.maximizeDelegate = self
            return cell
        } else {
            let maxCell = tableView.dequeueReusableCell(withIdentifier: "extendedCell", for: indexPath) as! CalendarCardMaximizedViewCell
            tableView.allowsSelection = false
            maxCell.topImageButton.isHidden = true
            maxCell.setUpApprovedConnectionView()

            let itemsCount = store.getCalendarSocialPostsForCard(store.getCalendarCards()[indexPath.section]).count
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
    
    @objc private func goToNextTab() {
        self.tabBarController?.selectedIndex = 0
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //get first item from every section
        let item: CalendarSocialPost = store.getCalendarSocialPostsForCard(store.getCalendarCards()[section])[0]
        //last section don't have an header view
        /*
        if section == store.getCalendarCards().count - 1 {
            return UIView()
        }
        */
        
        if shouldMaximizeCell == false {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CalendarHeaderViewCell
            headerCell.changeColor(color: item.getSectionColor)
            headerCell.changeTitle(title: item.socialTextString)
            return headerCell
        } else {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCardCell") as! HeaderCardCell
            headerCell.changeColor(section: section)
            headerCell.changeTitle(title: item.socialTextString)
            return headerCell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return store.countSections()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToLoad(section: section)
        return store.getCalendarSocialPostsForCard(store.getCalendarCards()[section]).count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //height for last card
        /*
        //if (indexPath.section == store.getCalendarCards().count - 1 ){
        if ( indexPath.section == (sections.count - 1) ) {
            return 261
        }
         */
        if shouldMaximizeCell == false {
            return 93
        }
        return 459
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        /*
        if section == store.getCalendarCards().endIndex - 1 {
            //if (section == sections.endIndex - 1) {
            return UIView()
        }
         */
        let todoFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerId") as! TableFooterView
        todoFooter.changeFeedType(feedType: FeedType.calendar)
        todoFooter.buttonActionHandler = self
        updateStateLoadMore(todoFooter, section: section)
        
        return todoFooter
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /*
        if section == store.getCalendarCards().count - 1 {
            //if section == sections.count - 1 {
            return 60
        }
         */
        if shouldMaximizeCell == false {
            return 109
        } else {
            return 80
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        /*
        if section == store.getCalendarCards().endIndex - 1 {
            //if section == sections.endIndex - 1 {
            return 0
        }
 */
        return 80
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
                let indexPath = IndexPath(row: 0, section: index.section)
                guard let lastRowInSection = indexes.last , indexes.first?.section == index.section else {
                    return
                }
                let headerFrame = tableView.rectForHeader(inSection: index.section)
                
                let frameOfLastCell = tableView.rectForRow(at: lastRowInSection)
                let cellFrame = tableView.rectForRow(at: indexPath)
                if headerFrame.origin.y + 50 < tableView.contentOffset.y {
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
        let item = store.getCalendarSocialPostsForCard(store.getCalendarCards()[section])[0]
        topHeaderView.changeTitle(title: item.socialTextString)
        topHeaderView.changeColorCircle(color: item.getSectionColor)
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
            } else {
                self.topHeaderView.frame.size.height = 30
            }
            self.topHeaderView.layoutIfNeeded()
        }, completion: { (completed) in
            self.isAnimatingHeader = false
        })
    }
    
    func maximizeCell() {
        shouldMaximizeCell = !shouldMaximizeCell
        
        
        tableView.reloadData()
        
        let type = shouldMaximizeCell ? HeaderViewType.expand : HeaderViewType.minimize
        topHeaderView.changeStatus(type: type)
    }
    
    func updateStateLoadMore(_ footerView: TableFooterView, section: Int) {
        let posts = store.getCalendarSocialPostsForCard(store.getCalendarCards()[section])
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
        let posts = store.getCalendarSocialPostsForCard(store.getCalendarCards()[section])
        if (posts.count > noItemsLoaded(section)) {
            return noItemsLoaded(section)
        } else {
            return posts.count
        }
        return noItemsLoadeInitial
    }
    
    func loadMore(section: Int) {
        var addItem = noItemsLoadeInitial
        let posts = store.getCalendarSocialPostsForCard(store.getCalendarCards()[section])
        if (posts.count > noItemsLoaded(section) + noItemsLoadeInitial) {
            addItem = noItemsLoadeInitial
        } else {
            addItem = posts.count - noItemsLoaded(section)
        }
        changeNoItemsLoaded(section, value: addItem)
        tableView.reloadData()
    }
    
}

extension CalendarViewController: FooterActionHandlerProtocol {
    func handlerAction(section: Int) {
        loadMore(section: section)
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
        self.calendarView.configuration.selectedDayTextColor = PopmetricsColor.greenSelectedDate
        
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let startDate = dateFormatter.string(from: date.atStartOfWeek())
        let endDate = dateFormatter.string(from: date.atEndOfWeek())
        self.dateRangeLabel.text = "\(startDate) - \(endDate)"
    }
    
    func calendar(_ calendarView: MJCalendarView, didChangePeriod periodDate: Date, bySwipe: Bool) {
        self.setTitleWithDate(periodDate as NSDate)
    }
    
    func calendar(_ calendarView: MJCalendarView, backgroundForDate date: Date) -> UIColor? {
        return nil
    }
    
    func calendar(_ calendarView: MJCalendarView, textColorForDate date: Date) -> UIColor? {
        return nil
    }
    
    func calendar(_ calendarView: MJCalendarView, didSelectDate date: Date) {
        print(date)
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
    }
    @IBAction func previousPeriodBtnPressed(_ sender: Any) {
        self.calendarView.moveToPreviousPeriod()
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        self.calendarView.goToCurrentDay()
    }
    
    func addDivider() {
        let divider = UIView(frame: CGRect(x: -17, y: self.topPickerStackViewWrapper.frame.height - 0.5, width: self.topPickerStackViewWrapper.frame.width, height: 0.5))
        divider.backgroundColor = PopmetricsColor.dividerBorder
        self.topPickerStackViewWrapper.addSubview(divider)
    }
}
