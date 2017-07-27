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
        var calendarSectionSchedule = [CalendarSection]()
        var calendarSetionFailed = [CalendarSection]()
        
        var results = [CalendarSection]()
        
        return results;
    }
    
    public func storeFeed(_ dict: [String:Any] ) {
        
    }
    
    
    public func storeItem(item: CalendarItem) {
        
    }

}
