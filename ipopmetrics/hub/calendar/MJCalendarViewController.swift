//
//  MJCalendarViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import MJCalendar

protocol ContainerToMaster {
    func reloadData()
    func setCalendarViewHeightConstraint(height: CGFloat)
}

class MJCalendarViewController: UIViewController, MJCalendarViewDelegate, MasterToContainer {
    
    @IBOutlet weak var calendarView: MJCalendarView!
    @IBOutlet weak var dateRangeLabel: UILabel!
    @IBOutlet weak var topPickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topPickerStackView: UIStackView!
    @IBOutlet weak var todayBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var topPickerStackViewHeight: NSLayoutConstraint!
    
    var selectedFromDate = Date()
    var selectedToDate = Date()
    
    internal var dayColors = Dictionary<Date, UIColor>()
    internal let store = CalendarStore.getInstance()
    internal var containerToMaster:ContainerToMaster?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.setUpCalendarConfiguration()
        addDivider()
        let tap = UITapGestureRecognizer(target: self, action: #selector(MJCalendarViewController.tapFunction))
        todayBtn.addTarget(self, action: #selector(tapFunction(sender:)), for: .touchUpInside)
        DispatchQueue.main.async {
            self.animateToPeriod(.oneWeek)
            self.previousButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
        initialSelectedDays()
    }
    
    func initialSelectedDays() {
        selectedFromDate = NSDate().atStartOfWeek()
        selectedToDate = NSDate().atStartOfNextWeek()
        
        setupDates(NSDate().atStartOfNextWeek())
    }
    
    func animateToPeriod(_ period: MJConfiguration.PeriodType) {
        self.calendarView.animateToPeriodType(period, duration: 0.1, animations: { (calendarHeight) -> Void in
            self.calendarView.heightAnchor.constraint(equalToConstant: calendarHeight)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func nextPeriodBtnPressed(_ sender: UIButton) {
        self.calendarView.moveToNextPeriod()
        let date = self.calendarView.visiblePeriodDate as NSDate
        self.selectedFromDate = date.atStartOfWeek()
        self.selectedToDate = date.atStartOfNextWeek()
        DispatchQueue.main.async {
            self.containerToMaster?.reloadData()
        }
    }

    @IBAction func previousPeriodBtnPressed(_ sender: UIButton) {
        self.calendarView.moveToPreviousPeriod()
        let date = self.calendarView.visiblePeriodDate as NSDate
        self.selectedToDate = date.atStartOfNextWeek()
        self.selectedFromDate = date.atStartOfWeek()
        DispatchQueue.main.async {
            self.containerToMaster?.reloadData()
        }
    }

    
    @objc func tapFunction(sender: UIButton) {
        self.calendarView.configuration.selectedDayTextColor = PopmetricsColor.greenSelectedDate
        self.calendarView.reloadDayViews()
        self.calendarView.goToCurrentDay()
        let currentDate = NSDate().atStartOfDay()
        resetColors()
        
        self.selectedFromDate = currentDate
        self.selectedToDate = currentDate.endOfDay
        
        setupDates(currentDate)
        self.containerToMaster?.reloadData()
    }
    
    func setUpCalendarConfiguration() {
        self.calendarView.calendarDelegate = self
        // Set displayed period type. Available types: Month, ThreeWeeks, TwoWeeks, OneWeek
        self.calendarView.configuration.periodType = .month
        
        // Set shape of day view. Available types: Circle, Square
        self.calendarView.configuration.dayViewType = .square
        
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
        self.calendarView.configuration.selectedDayBackgroundColor = PopmetricsColor.yellowBGColor
        
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
        self.calendarView.configuration.dayViewSize = CGSize(width: 60, height: 24)
        
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
        
        selectedFromDate = date.atStartOfWeek()
        selectedToDate = date.atStartOfNextWeek()
        
        DispatchQueue.main.async {
            self.containerToMaster?.reloadData()
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
        
        self.selectedFromDate = date.startOfDay
        self.selectedToDate = date.endOfDay
        resetColors()
        
        self.calendarView.configuration.selectedDayTextColor = PopmetricsColor.greenSelectedDate
            
//        if date == store.selectedDate {
//                self.calendarView.configuration.selectedDayTextColor = PopmetricsColor.textGrey
//            }
        
        self.calendarView.reloadView()
        DispatchQueue.main.async {
            self.containerToMaster?.reloadData()
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
                self.dayColors[day] = PopmetricsColor.textGrey
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
    
    func addDivider() {
        let divider = UIView(frame: CGRect(x: -17, y: self.view.frame.height - 0.5, width: self.view.frame.width, height: 0.5))
        divider.backgroundColor = PopmetricsColor.dividerBorder
        self.view.addSubview(divider)
    }
    
    func animateTopPart(shouldCollapse: Bool, offset: CGFloat) {
        UIView.animate(withDuration: 0.4, animations: {
            let initialHeight = 56.0 as CGFloat
            let selfInitialHeight = 150 as CGFloat
            if shouldCollapse {
                if offset <= initialHeight && offset >= 0{
                    self.topPickerViewHeight.constant = initialHeight - offset
                    self.containerToMaster?.setCalendarViewHeightConstraint(height: selfInitialHeight - offset)
                } else {
                    self.topPickerStackView.alpha = 0.0
                    self.topPickerStackView.isHidden = true
                }
            } else {
                if offset <= initialHeight {
                    self.topPickerStackView.alpha = 1.0
                    self.topPickerStackView.isHidden = false
                    if offset >= 10 {
                        self.topPickerViewHeight.constant = initialHeight - offset
                        self.containerToMaster?.setCalendarViewHeightConstraint(height: selfInitialHeight - offset)
                    } else {
                        self.topPickerViewHeight.constant = initialHeight
                        self.containerToMaster?.setCalendarViewHeightConstraint(height: selfInitialHeight)
                    }
                }
            }
        }, completion: nil)
    }
}



