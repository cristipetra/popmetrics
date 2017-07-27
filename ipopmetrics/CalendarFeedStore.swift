//
//  CalendarFeedStore.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 27/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation

class CalendarFeedStore {
    static func getInstance() -> CalendarFeedStore {
        let instance = CalendarFeedStore()
        return instance
    }
    
    
    public func getFeed() -> [CalendarSection] {
        var calendarSectionSchedule:CalendarSection = CalendarSection()
        calendarSectionSchedule.status = "scheduled"
        
        let calendarItem1: CalendarItem = CalendarItem();
        let calendarItem2: CalendarItem = CalendarItem();
        let calendarItem3: CalendarItem = CalendarItem();
        calendarSectionSchedule.items.append(calendarItem1)
        calendarSectionSchedule.items.append(calendarItem2)
        calendarSectionSchedule.items.append(calendarItem3)
        
        var calendarSectionFailed = CalendarSection()
        calendarSectionFailed.status = "failed"
        let calendarSectionFailedItem1 = CalendarItem();
        calendarSectionFailed.items.append(calendarSectionFailedItem1)
        
        
        var calendarSectionExecuted = CalendarSection();
        calendarSectionExecuted.status = "executed"
        let calendarSectionExecutedItem1 = CalendarItem()
        let calendarSectionExecutedItem2 = CalendarItem()
        calendarSectionExecuted.items.append(calendarSectionExecutedItem1)
        calendarSectionExecuted.items.append(calendarSectionExecutedItem2)
        
        var results = [CalendarSection]();
        results.append(calendarSectionSchedule)
        results.append(calendarSectionFailed)
        results.append(calendarSectionExecuted)
        print("count")
        print(results.count)
        return results;
    }
    
    public func storeFeed(_ dict: [String:Any] ) {
    
    }
    
    
    public func storeItem(item: CalendarItem) {
        
    }

}
