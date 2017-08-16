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
    
    var sections:[CalendarSection] = []
    
    public func getFeed() -> [CalendarSection] {
        return sections
    }
    
    public func storeFeed(_ dict: [String:Any] ) {
    
    }
    
    public func storeItem(item: CalendarItem) {
        if !existSection(item) {
            var section: CalendarSection = CalendarSection()
            section.status = item.status!
            section.items.append(item)
            sections.append(section)
        }
    
    }
    
    internal func existSection(_ item: CalendarItem) -> Bool {
        for section in sections{
            if(section.status ==  item.status) {
                print("fouund")
                section.items.append(item)
                return true
            }
        }
        return false
    }

}
