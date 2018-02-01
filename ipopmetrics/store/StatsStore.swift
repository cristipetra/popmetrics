//
//  StatisticsStore.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 29/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift

class StatsStore {
    
    public let realm = try! Realm()
    
    static func getInstance() -> StatsStore {
        return StatsStore()
    }
    
    public func getStatsCards() -> Results<StatsCard> {
        let predicate = NSPredicate(format: "status != 'archived'")
        return realm.objects(StatsCard.self).filter(predicate).sorted(byKeyPath: "index", ascending: false)
    }
    
    public func getStatsCardWithId(_ cardId: String) -> StatsCard? {
        return realm.object(ofType: StatsCard.self, forPrimaryKey: cardId)
    }
    
    
    public func getStatsMetricsForCard(_ statsCard: StatsCard) -> Results<StatsMetric> {
        let predicate = NSPredicate(format: "statsCard = %@ && status !='archived'", statsCard)
        return realm.objects(StatsMetric.self).filter(predicate)
    }
    
    public func getStatsCardsWithSection(_ section: String) -> Results<StatsCard> {
        let predicate = NSPredicate(format: "section = %@ && status != 'archived'", section)
        return realm.objects(StatsCard.self).filter(predicate)
    }
    
    public func getNonEmptyStatsCardsWithSection(_ section: String) -> Results<StatsCard> {
        let predicate = NSPredicate(format: "section = %@ && type != %@ && status!= 'archived'", section, "empty_state")
        return realm.objects(StatsCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:false)
    }
    
    public func getEmptyStatsCardsWithSection(_ section: String) -> Results<StatsCard> {
        let predicate = NSPredicate(format: "section = %@ && type == %@ && status != 'archived'", section, "empty_state")
        return realm.objects(StatsCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:false)
    }
    
    public func getSections() -> [String] {
        let distinctTypes = Array(Set(self.getStatsCards().value(forKey: "section") as! [String]))
        return distinctTypes
    }
    
    
    /*
     * Return statistic metrics for card that has an page index
     */
    public func getStatsMetricsForCardAtPageIndex(_ statsCard: StatsCard, _ pageIndex: Int = 0) -> Results<StatsMetric> {
        let predicate = NSPredicate(format: "statsCard = %@ && pageIndex = %@ && status !='archived'", statsCard, (pageIndex) as NSNumber)
        return realm.objects(StatsMetric.self).filter(predicate)
    }
    
    /*
     * Return number of pages for a statistic card
     * sorted by page Index
     */
    public func getNumberOfPagesByPageIndex(_ statsCard: StatsCard) -> Int {
        let predicate = NSPredicate(format: "statsCard = %@ && status !='archived'", statsCard)
        let metricsForCard = realm.objects(StatsMetric.self).filter(predicate).sorted(byKeyPath: "pageIndex")
        let lastMetric: StatsMetric = metricsForCard[metricsForCard.count - 1]
        return lastMetric.pageIndex
    }
    
    public func countSections() -> Int {
        let distinctTypes = Array(Set(self.getStatsCards().value(forKey: "section") as! [String]))
        return distinctTypes.count
    }
    
    public func getLastCardUpdateDate() -> Date {
        let result = realm.objects(StatsCard.self).sorted(byKeyPath: "updateDate", ascending:false)
        if result.count > 0 {
            return result[0].updateDate
        }
        else {
            return Date(timeIntervalSince1970: 0)
        }
    }
    
    public func getLastMetricUpdateDate() -> Date {
        let result = realm.objects(StatsMetric.self).sorted(byKeyPath: "updateDate", ascending:false)
        if result.count > 0 {
            return result[0].updateDate
        }
        else {
            return Date(timeIntervalSince1970: 0)
        }
    }
    public func wipe() {
        let realm = try! Realm()
        let allCards = realm.objects(StatsCard.self)
        let allMetrics = realm.objects(StatsMetric.self)
        
        try! realm.write {
            realm.delete(allCards)
            realm.delete(allMetrics)
        }
    }
    
    public func updateStatistics(_ statisticsResponse: StatisticsResponse) {
        
        let realm = try! Realm()
        try! realm.write {
            for newCard in statisticsResponse.cards! {
                realm.add(newCard, update:true)
            }
            
            for newMetric in statisticsResponse.metrics ?? [] {
                newMetric.statsCard = getStatsCardWithId(newMetric.statsCardId)
                realm.add(newMetric, update:true)
            }
        }//try
    }
    
}

