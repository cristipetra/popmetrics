//
//  CalendarFeedStore.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 27/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift

class CalendarStore {
    
    private static var instance: CalendarStore = {
        return CalendarStore()
    }()
    
    static func getInstance() -> CalendarStore {
        return instance
    }
    
    public let realm = try! Realm()
    
    public func getCalendarCards() -> Results<CalendarCard> {
        let predicate = NSPredicate(format: "status != 'archived'")
        return realm.objects(CalendarCard.self).filter(predicate).sorted(byKeyPath: "index")
    }
    
    public func getCalendarCardWithId(_ cardId: String) -> CalendarCard? {
        return realm.object(ofType: CalendarCard.self, forPrimaryKey: cardId)
    }
    
    public func getCalendarSocialPostWithId(_ postId: String) -> CalendarSocialPost? {
        return realm.object(ofType: CalendarSocialPost.self, forPrimaryKey: postId)
    }
    
    public func getCalendarCardsWithSection(_ section: String) -> Results<CalendarCard> {
        let predicate = NSPredicate(format: "section = %@ && status !='archived'", section)
        return realm.objects(CalendarCard.self).filter(predicate)
    }
    
    public func getNonEmptyCalendarCardsWithSection(_ section: String) -> Results<CalendarCard> {
        let predicate = NSPredicate(format: "section = %@ && type != %@ && status !='archived'", section, "empty_state")
        return realm.objects(CalendarCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:true)
    }
    
    public func getEmptyCalendarCardsWithSection(_ section: String) -> Results<CalendarCard> {
        let predicate = NSPredicate(format: "section = %@ && type == %@ && status != 'archived'", section, "empty_state")
        return realm.objects(CalendarCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:true)
    }

    public func getCalendarSocialPosts() -> Results<CalendarSocialPost> {
        
        let predicate = NSPredicate(format: "status !='archived'")
        return realm.objects(CalendarSocialPost.self).filter(predicate).sorted(byKeyPath: "scheduledDate", ascending: true)
    }
    
    
    public func getCalendarSocialPostsInRange(fromDate: Date, toDate:Date) -> Results<CalendarSocialPost> {
        
        let predicate = NSPredicate(format: "scheduledDate > %@ && scheduledDate < %@ && status !='archived'",
                                    fromDate as CVarArg, toDate as CVarArg)
        return realm.objects(CalendarSocialPost.self).filter(predicate).sorted(byKeyPath: "scheduledDate", ascending: true)
    }
    
    public func countSections() -> Int {
        let distinctTypes = Array(Set(self.getCalendarCards().value(forKey: "section") as! [String]))
        return distinctTypes.count
    }
    
    public func getLastCardUpdateDate() -> Date {
        let result = realm.objects(CalendarCard.self).sorted(byKeyPath: "updateDate", ascending:false)
        if result.count > 0 {
            return result[0].updateDate
        }
        else {
            return Date(timeIntervalSince1970: 0)
        }
    }
    
    public func getLastSocialPostUpdateDate() -> Date {
        let result = realm.objects(CalendarSocialPost.self).sorted(byKeyPath: "updateDate", ascending:false)
        if result.count > 0 {
            return result[0].updateDate
        }
        else {
            return Date(timeIntervalSince1970: 0)
        }
    }
    
    public func wipe() {
        let realm = try! Realm()
        let allCards = realm.objects(CalendarCard.self)
        let allPosts = realm.objects(CalendarSocialPost.self)
        
        try! realm.write {
            realm.delete(allCards)
            realm.delete(allPosts)
        }
    }
    
    public func updateCalendars(_ calendarResponse: CalendarResponse) {
        
        let realm = try! Realm()
        try! realm.write {
            for newCard in calendarResponse.cards! {
                realm.add(newCard, update:true)
            }
            
            for newPost in calendarResponse.socialPosts! {
                newPost.calendarCard = getCalendarCardWithId(newPost.calendarCardId)
                realm.add(newPost, update:true)
            }
        }//try
        
        
    }

}
