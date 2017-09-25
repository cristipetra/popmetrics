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
    
    public func getStatisticsCard() -> Results<StatisticCard> {
        return realm.objects(StatisticCard.self).sorted(byKeyPath: "index")
    }
    
    public func countSections() -> Int {
        let distinctTypes = Array(Set(self.getStatisticsCard().value(forKey: "section") as! [String]))
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
            }
            
            for card in cardsToDelete {
                
                //TODO delete all related items first
                realm.delete(card)
            }
            
            for newCard in statisticsResponse.cards! {
                realm.add(newCard, update:true)
            }
        }//try
        
    }
    
}
