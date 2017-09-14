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
    
    public var selectedDate = Date()
    
    public func getCalendarCards() -> Results<CalendarCard> {
        return realm.objects(CalendarCard.self).sorted(byKeyPath: "index")
    }
    
    public func getCalendarCardWithId(_ cardId: String) -> CalendarCard {
        return realm.object(ofType: CalendarCard.self, forPrimaryKey: cardId)!
    }
    
    
    public func getCalendarCardsWithSection(_ section: String) -> Results<CalendarCard> {
        let predicate = NSPredicate(format: "section = %@", section)
        return realm.objects(CalendarCard.self).filter(predicate)
    }
    
    public func getCalendarSocialPostsForCard(_ calendarCard: CalendarCard) -> Results<CalendarSocialPost> {
        let predicate = NSPredicate(format: "calendarCard = %@ &&  scheduledDate > %@ && scheduledDate < %@", calendarCard, selectedDate.startOfDay as CVarArg, selectedDate.endOfDay as CVarArg)
        return realm.objects(CalendarSocialPost.self).filter(predicate)
    }
    
    public func countSections() -> Int {
        let distinctTypes = Array(Set(self.getCalendarCards().value(forKey: "section") as! [String]))
        return distinctTypes.count
    }
    
    public func updateCalendars(_ calendarResponse: CalendarResponse) {
        
        let realm = try! Realm()
        let cards = realm.objects(CalendarCard.self).sorted(byKeyPath: "index")
        
        var cardsToDelete: [CalendarCard] = []
        try! realm.write {
            for existingCard in cards {
                let (exists, newCard) = calendarResponse.matchCard(existingCard.cardId!)
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
            
            for newCard in calendarResponse.cards! {
                realm.add(newCard, update:true)
            }
        }//try
        
        let posts = realm.objects(CalendarSocialPost.self)
        var postsToDelete: [CalendarSocialPost] = []
        // update social postings
        try! realm.write {
            for existingPost in posts {
                let (exists, newPost) = calendarResponse.matchSocialPost(existingPost.postId!)
                if !exists {
                    postsToDelete.append(existingPost)
                }
            }
            
            for post in postsToDelete {
                //TODO delete all related items first
                realm.delete(post)
            }
            
            for newPost in calendarResponse.socialPosts! {
                newPost.calendarCard = getCalendarCardWithId(newPost.calendarCardId)
                realm.add(newPost, update:true)
            }
        }//try
        
        
    }

}
