//
//  StatisticsStore.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 29/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift

class StatisticsStore {
    
    public let realm = try! Realm()
    
    static func getInstance() -> StatisticsStore {
        return StatisticsStore()
    }
    
    public func getStatisticsCards() -> Results<StatisticsCard> {
        return realm.objects(StatisticsCard.self).sorted(byKeyPath: "index")
    }
    
    public func getStatisticsCardWithId(_ cardId: String) -> StatisticsCard? {
        return realm.object(ofType: StatisticsCard.self, forPrimaryKey: cardId)
    }
    
    
    public func getStatisticMetricsForCard(_ statisticCard: StatisticsCard) -> Results<StatisticMetric> {
        let predicate = NSPredicate(format: "statisticCard = %@", statisticCard)
        return realm.objects(StatisticMetric.self).filter(predicate)
    }
    
    /*
     * Return statistic metrics for card that has an page index
     */
    public func getStatisticMetricsForCardAtPageIndex(_ statisticCard: StatisticsCard, _ pageIndex: Int = 0) -> Results<StatisticMetric> {
        let predicate = NSPredicate(format: "statisticCard = %@ && pageIndex = %@", statisticCard, (pageIndex) as NSNumber)
        return realm.objects(StatisticMetric.self).filter(predicate)
    }
    
    /*
     * Return number of pages for a statistic card
     */
    public func getNumberOfPages(_ statisticCard: StatisticsCard) -> Int {
        let predicate = NSPredicate(format: "statisticCard = %@", statisticCard)
        let metricsForCard = realm.objects(StatisticMetric.self).filter(predicate).sorted(byKeyPath: "pageIndex")
        let lastMetric: StatisticMetric = metricsForCard[metricsForCard.count - 1]
        return lastMetric.pageIndex
    }
    
    public func countSections() -> Int {
        let distinctTypes = Array(Set(self.getStatisticsCards().value(forKey: "section") as! [String]))
        return distinctTypes.count
    }
    
    public func updateStatistics(_ statisticsResponse: StatisticsResponse) {
        
        let realm = try! Realm()
        let cards = realm.objects(StatisticsCard.self).sorted(byKeyPath: "index")
        
        var cardsToDelete: [StatisticsCard] = []
        try! realm.write {
            
            for existingCard in cards {
                let (exists, newCard) = statisticsResponse.matchCard(existingCard.cardId!)
                if !exists {
                    cardsToDelete.append(existingCard)
                }
                else {
                    newCard?.cardId = existingCard.cardId!
                    realm.add(newCard!, update:true)
                }
            }
            
            for card in cardsToDelete {

                let statsMetrics = self.getStatisticMetricsForCard(card)
                for metric in statsMetrics {
                    realm.delete(metric)
                }
                
                realm.delete(card)
            }
            
            for newCard in statisticsResponse.cards! {
                if let exCard = self.getStatisticsCardWithId(newCard.cardId!) {
                    if exCard.updateDate == newCard.updateDate {
                        continue
                    }
                }
                
                realm.add(newCard, update:true)
            }
        }//try
        
        
        // now update the metrics
        let metrics = realm.objects(StatisticMetric.self)
        var metricsToDelete: [StatisticMetric] = []
        // update social postings
        try! realm.write {
            for existingMetric in metrics {
                realm.delete(existingMetric)
            }
           
            for newMetric in statisticsResponse.metrics ?? [] {
                
                newMetric.statisticCard = getStatisticsCardWithId(newMetric.statisticsCardId)
                realm.add(newMetric, update:true)
            }
        }//try
        
        
    }
    
}
