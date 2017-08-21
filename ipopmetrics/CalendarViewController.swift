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

class CalendarViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: MJCalendarView!
    
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var currentDateBtn: UIView!
    @IBOutlet weak var topPickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rightArrow: UIButton!
    @IBOutlet weak var topPickerStackView: UIStackView!
    @IBOutlet weak var todayLabelView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topPickerStackViewHeight: NSLayoutConstraint!
    
    fileprivate var sections: [CalendarSection] = []
    var reachedFooter = false
    var shouldMaximizeCell = false
    
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
        
        let sectionFooterNib = UINib(nibName: "CalendarFooter", bundle: nil)
        tableView.register(sectionFooterNib, forCellReuseIdentifier: "footerCell")
        
        let extendedCardNib = UINib(nibName: "CalendarCardMaximized", bundle: nil)
        tableView.register(extendedCardNib, forCellReuseIdentifier: "extendedCell")
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")

        
        tableView.separatorStyle = .none
        setupTopHeaderView()
        self.setUpCalendarConfiguration()
        
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
        
        fetchItemsLocally(silent: false)
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
        maximizeCell()
    }
    
    func fetchItemsLocally(silent: Bool) {
        let path = Bundle.main.path(forResource: "sampleFeedCalendar", ofType: "json")
        let jsonData: NSData = NSData(contentsOfFile: path!)!
        let json = JSON(data: jsonData as Data)
        let calendarFeedStore = CalendarFeedStore.getInstance()
        for item in json["items"] {
            let calendarItem = CalendarItem()
            calendarItem.status = item.1["status"].description
            calendarItem.articleTitle = item.1["article_title"].description
            calendarItem.statusDate = Date(timeIntervalSince1970: Double(item.1["status_date"].description)!)
            calendarItem.articleImage = item.1["article_image"].description
            calendarItem.articleText = item.1["article_text"].description
            calendarItem.type = item.1["type"].description
            calendarItem.articleUrl = item.1["article_url"].description
            calendarItem.articleCategory = item.1["article_category"].description
            if( item.1["article_hastags"].array != nil) {
                calendarItem.articleHastags = ((item.1["article_hastags"].array)!)
            }
            
            //calendarItem.articleCategory
            print(item.1["status"].description)
            //calendarFeedStore.app
            calendarFeedStore.storeItem(item: calendarItem)
        }
        
        calendarFeedStore.getFeed()
        
         self.sections = calendarFeedStore.getFeed()
    }
    
    func fetchItems(silent:Bool) {
        //        let path = Bundle.main.path(forResource: "sampleFeed", ofType: "json")
        //        let jsonData : NSData = NSData(contentsOfFile: path!)!
        FeedApi().getItems("58fe437ac7631a139803757e") { responseDict, error in
            
            if error != nil {
                let message = "An error has occurred. Please try again later."
                EZAlertController.alert("Error", message: message)
                return
            }
            if let code = responseDict?["code"] as? String {
                if "success" != code {
                    let message = responseDict?["message"] as! String
                    EZAlertController.alert("Error", message: message)
                    return
                }
            }
            else {
                EZAlertController.alert("Error", message: "An unexpected error has occured. Please try again later")
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
            
            
            //self.sections = feedStore.getFeed()
            
            if !silent { self.tableView.reloadData() }
        }
        
    }

}

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate, ChangeCellProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        let section = sections[sectionIdx]
        let item = section.items[rowIdx]
        
        if item.type == "last_cell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
            cell.titleLabel.text = "Thats it for now!"
            cell.messageLbl.text = "Check back to see if there is anything more in the Home Feed"
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
            maxCell.configure(item)
            if indexPath.row == (sections[indexPath.section].items.count - 1) {
                maxCell.connectionStackView.isHidden = true
                maxCell.isLastCell = true
            } else {
                maxCell.connectionStackView.isHidden = false
            }

            return maxCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //last section don't have an header view
        if section == sections.endIndex - 1 {
            return UIView()
        }
        
        if shouldMaximizeCell == false {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CalendarHeaderViewCell
            headerCell.changeColor(color: sections[section].items[0].getSectionColor)
            headerCell.changeTitle(title: sections[section].items[0].socialTextString)
            return headerCell
        } else {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCardCell") as! HeaderCardCell
            return headerCell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //height for last card
        if ( indexPath.section == (sections.count - 1) ) {
            return 261
        }
        if shouldMaximizeCell == false {
            return 93
        }
        return 459
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        reachedFooter = true
        if section == sections.last?.index {
            let footerCell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! CalendarFooterViewCell
            return footerCell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == sections.count - 1 {
            return 0
        }
        if shouldMaximizeCell == false {
            return 109
        } else {
            return 80
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == sections.last?.index{
            return 80
        }
        return 0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)
        if translation.y > 0 {
            animateTopPart(shouldCollapse: false, offset: scrollView.contentOffset.y)
        } else {
            animateTopPart(shouldCollapse: true, offset: scrollView.contentOffset.y)
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
                    topHeaderView.changeTitle(title: sections[index.section].items[0].socialTextString)
                    topHeaderView.changeColorCircle(color: sections[index.section].items[0].getSectionColor)
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
        self.calendarView.configuration.rowHeight = 25
        
        // Set height of week's days names view
        self.calendarView.configuration.weekLabelHeight = 45
        
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
                    if offset >= 2 {
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
        self.calendarView.selectNewPeriod(calendarView.date)
    }

    
}
