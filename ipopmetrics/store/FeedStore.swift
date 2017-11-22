//
//  FeedItemsStore.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import RealmSwift

class FeedStore {
    
    public let realm = try! Realm()
    
    static func getInstance() -> FeedStore {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.feedStore
    }
    
    public func getFeedCards() -> Results<FeedCard> {
        return realm.objects(FeedCard.self).sorted(byKeyPath: "index")
    }
    
    public func getFeedCardWithId(_ cardId: String) -> FeedCard? {
        return realm.object(ofType: FeedCard.self, forPrimaryKey: cardId)
    }
    
    public func getFeedCardsWithSection(_ section: String) -> Results<FeedCard> {
        let predicate = NSPredicate(format: "section = %@", section)
        return realm.objects(FeedCard.self).filter(predicate)
    }
    
    public func getNonEmptyFeedCardsWithSection(_ section: String) -> Results<FeedCard> {
        let predicate = NSPredicate(format: "section = %@ && type != %@", section, "empty_state")
        return realm.objects(FeedCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:true)
    }
    
    public func getEmptyFeedCardsWithSection(_ section: String) -> Results<FeedCard> {
        let predicate = NSPredicate(format: "section = %@ && type == %@", section, "empty_state")
        return realm.objects(FeedCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:true)
    }
    
    
    public func getSections() -> [String] {
        let distinctTypes = Array(Set(self.getFeedCards().value(forKey: "section") as! [String]))
        return distinctTypes
    }
    
    public func countSections() -> Int {
        let distinctTypes = Array(Set(self.getFeedCards().value(forKey: "section") as! [String]))
        return distinctTypes.count
    }
    
    public func updateFeed(_ feedResponse: FeedResponse) {
    
        let realm = try! Realm()
        let cards = realm.objects(FeedCard.self).sorted(byKeyPath: "index")
    
        var cardsToDelete: [FeedCard] = []
        try! realm.write {
            
            for existingCard in cards {
                let (exists, newCard) = feedResponse.matchCard(existingCard.cardId!)
                if !exists {
                    cardsToDelete.append(existingCard)
                }
            }
            
            for card in cardsToDelete {
                
                realm.delete(card)
            }
            
            for newCard in feedResponse.cards! {
                if let exCard = self.getFeedCardWithId(newCard.cardId!) {
                    if exCard.updateDate == newCard.updateDate {
                        continue
                    }
                }
                realm.add(newCard, update:true)
            }
        }//try
    
    }

}
