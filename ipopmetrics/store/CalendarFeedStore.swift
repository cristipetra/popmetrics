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
    
    public var selectedWeek = DateInterval(start: NSDate().atStartOfWeek(), end: NSDate().atEndOfWeek())
    
    public var selectedRange = DateInterval(start: NSDate().atStartOfWeek(), end: NSDate().atEndOfWeek())
    
    public func getCalendarCards() -> Results<CalendarCard> {
        return realm.objects(CalendarCard.self).sorted(byKeyPath: "index")
    }
    
    public func getCalendarCardWithId(_ cardId: String) -> CalendarCard? {
        return realm.object(ofType: CalendarCard.self, forPrimaryKey: cardId)
    }
    
    public func getCalendarSocialPostWithId(_ postId: String) -> CalendarSocialPost? {
        return realm.object(ofType: CalendarSocialPost.self, forPrimaryKey: postId)
    }
    
    
    public func getCalendarCardsWithSection(_ section: String) -> Results<CalendarCard> {
        let predicate = NSPredicate(format: "section = %@", section)
        return realm.objects(CalendarCard.self).filter(predicate)
    }
    
    public func getCalendarSocialPostsForCard(_ calendarCard: CalendarCard, datesSelected: Int) -> Results<CalendarSocialPost> {
        switch datesSelected {
        case 0:
            let predicate = NSPredicate(format: "calendarCard = %@ &&  scheduledDate > %@ && scheduledDate < %@", calendarCard, selectedWeek.start as CVarArg, selectedWeek.end as CVarArg)
            return realm.objects(CalendarSocialPost.self).filter(predicate)
        case 1:
            let predicate = NSPredicate(format: "calendarCard = %@ &&  scheduledDate > %@ && scheduledDate < %@", calendarCard, selectedDate.startOfDay as CVarArg, selectedDate.endOfDay as CVarArg)
            return realm.objects(CalendarSocialPost.self).filter(predicate)
        case 2:
            let predicate = NSPredicate(format: "calendarCard = %@ &&  scheduledDate > %@ && scheduledDate < %@", calendarCard, selectedRange.start as CVarArg, selectedRange.end as CVarArg)
            return realm.objects(CalendarSocialPost.self).filter(predicate)
        default:
            break
        }
        return realm.objects(CalendarSocialPost.self)
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
                /*
                let socialPosts = self.getCalendarSocialPostsForCard(card)
                for post in socialPosts {
                    realm.delete(post)
                }
                */

                realm.delete(card)
            }
            
            for newCard in calendarResponse.cards! {
                
                if let exCard = self.getCalendarCardWithId(newCard.cardId!) {
                    if exCard.updateDate == newCard.updateDate {
                        continue
                    }
                }
                
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
                realm.delete(post)
            }
            
            for newPost in calendarResponse.socialPosts! {
                if let exPost = self.getCalendarSocialPostWithId(newPost.postId!) {
                    if exPost.updateDate == newPost.updateDate {
                        continue
                    }
                }
                
                
                newPost.calendarCard = getCalendarCardWithId(newPost.calendarCardId)
                realm.add(newPost, update:true)
            }
        }//try
        
        
    }

}