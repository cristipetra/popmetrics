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
    
    public func getStatisticsCards() -> Results<StatisticCard> {
        return realm.objects(StatisticCard.self).sorted(byKeyPath: "index")
    }
    
    public func getStatisticsCardWithId(_ cardId: String) -> StatisticCard? {
        return realm.object(ofType: StatisticCard.self, forPrimaryKey: cardId)
    }
    
    
    public func getStatisticMetricsForCard(_ statisticCard: StatisticCard) -> Results<StatisticMetric> {
        let predicate = NSPredicate(format: "statisticCard = %@", statisticCard)
        return realm.objects(StatisticMetric.self).filter(predicate)
    }
    
    public func countSections() -> Int {
        let distinctTypes = Array(Set(self.getStatisticsCards().value(forKey: "section") as! [String]))
        return distinctTypes.count
    }
    
    public func updateStatistics(_ statisticsResponse: StatisticsResponse) {
        
        let realm = try! Realm()
        let cards = realm.objects(StatisticCard.self).sorted(byKeyPath: "index")
        
        var cardsToDelete: [StatisticCard] = []
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
           
            for newMetric in statisticsResponse.metrics! {
                
                newMetric.statisticCard = getStatisticsCardWithId(newMetric.statisticsCardId)
                realm.add(newMetric, update:true)
            }
        }//try
        
        
    }
    
}
