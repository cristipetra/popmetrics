//
//  CalendarFeedStore.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 27/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift

class CalendarFeedStore {
    static func getInstance() -> CalendarFeedStore {
        let instance = CalendarFeedStore()
        return instance
    }
    
    public let realm = try! Realm()
    
    
    public func getCalendarCards() -> Results<CalendarCard> {
        return realm.objects(CalendarCard.self).sorted(byKeyPath: "index")
    }
    
    public func getCalendarCardsWithSection(_ section: String) -> Results<CalendarCard> {
        let predicate = NSPredicate(format: "section = %@", section)
        return realm.objects(CalendarCard.self).filter(predicate)
    }
    
    public func getCalendarSocialPostsForCard(_ todoCard: CalendarCard) -> Results<CalendarSocialPost> {
        let predicate = NSPredicate(format: "todoCard = %@", todoCard)
        return realm.objects(CalendarSocialPost.self).filter(predicate)
    }
    
    
    
    public func countSections() -> Int {
        let distinctTypes = Array(Set(self.getCalendarCards().value(forKey: "section") as! [String]))
        return distinctTypes.count
    }
    
    public func updateCalendars(_ feedResponse: FeedResponse) {
        
        let realm = try! Realm()
        let cards = realm.objects(CalendarCard.self).sorted(byKeyPath: "index")
        
        var cardsToDelete: [CalendarCard] = []
        try! realm.write {
            for existingCard in cards {
                let (exists, newCard) = feedResponse.matchCard(existingCard.cardId!)
                if !exists {
                    cardsToDelete.append(existingCard)
                }
                else {
                    newCard?.cardId = existingCard.cardId!
                    realm.add(newCard!, update:true)
                }
                
            }
            
            for card in cardsToDelete {
                
                //TODO delete all related items first
                realm.delete(card)
            }
        }//try
        
    }
    
    
    
    
    
    
    
    
    
    
    // TO BE DELETED
    
    
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
