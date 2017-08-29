//
//  StatisticsStore.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 29/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation

class StatisticsStore {
    
    static func getInstance() -> StatisticsStore {
        return StatisticsStore()
    }
    
    var sections:[StatisticsSection] = []
    
    public func getFeed() -> [StatisticsSection] {
        return sections
    }
    
    public func storeItem(item: StatisticsItem) {
        if !existSection(item) {
            var section: StatisticsSection = StatisticsSection()
            section.status = item.status!
            section.items.append(item)
            sections.append(section)
        }
        
    }
    
    internal func existSection(_ item: StatisticsItem) -> Bool {
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
