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
        let predicate = NSPredicate(format: "status != 'archived'")
        return realm.objects(FeedCard.self).filter(predicate).sorted(byKeyPath: "index")
    }
    
    public func getFeedCardWithId(_ cardId: String) -> FeedCard? {
        return realm.object(ofType: FeedCard.self, forPrimaryKey: cardId)
    }
    
    public func getFeedCardWithName(_ name: String) -> FeedCard? {
        let predicate = NSPredicate(format: "name = %@", name)
        let rset = realm.objects(FeedCard.self).filter(predicate)
        if rset.count > 0 {
            return rset[0]
        }
        else {
            return nil
        }
    }
    
    public func getFeedCardWithRecommendedAction(_ name: String) -> FeedCard? {
        let predicate = NSPredicate(format: "recommendedAction = %@", name)
        let rset = realm.objects(FeedCard.self).filter(predicate)
        if rset.count > 0 {
            return rset[0]
        }
        else {
            return nil
        }
    }
    
    
    public func getFeedCardsWithSection(_ section: String) -> Results<FeedCard> {
        let predicate = NSPredicate(format: "section = %@ && status != 'archived'", section)
        return realm.objects(FeedCard.self).filter(predicate)
    }
    
    public func getNonEmptyFeedCardsWithSection(_ section: String) -> Results<FeedCard> {
        let predicate = NSPredicate(format: "section = %@ && type != %@ && status!= 'archived'", section, "empty_state")
        return realm.objects(FeedCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:true)
    }
    
    public func getEmptyFeedCardsWithSection(_ section: String) -> Results<FeedCard> {
        let predicate = NSPredicate(format: "section = %@ && type == %@ && status != 'archived'", section, "empty_state")
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
    
    public func updateCardSection(_ feedCard: FeedCard, section:String) {
        try! realm.write {
            feedCard.section = section
            feedCard.updateDate = Date(timeIntervalSinceNow: 0)
            realm.add(feedCard, update: true)
        }
    }
    
    
    public func archiveCard(_ feedCard: FeedCard) {
        try! realm.write {
            realm.delete(feedCard)
        }
    }
    
    public func getLastUpdateDate() -> Date {
        let result = realm.objects(FeedCard.self).sorted(byKeyPath: "updateDate", ascending:false)
        if result.count > 0 {
            return result[0].updateDate
        }
        else {
            return Date(timeIntervalSince1970: 0)
        }
    }
    
    public func wipe() {
        let realm = try! Realm()
        let allCards = realm.objects(FeedCard.self)
        
        try! realm.write {
            realm.delete(allCards)
        }
    }
    
    public func updateFeed(_ feedResponse: FeedResponse) {
    
        let realm = try! Realm()
        try! realm.write {
            for newCard in feedResponse.cards! {
                realm.add(newCard, update:true)
            }
        }//try
    
    }

}
