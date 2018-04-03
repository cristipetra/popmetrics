//
//  HubStore.swift
//  ipopmetrics
//
//  Created by Rares Pop on 03/04/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//
//

import Foundation
import RealmSwift

class HubStore{
    
    public let realm = try! Realm()
    
    static func getInstance() -> StatsStore {
        return StatsStore()
    }
    
    public func getHubCards(hubs:[String]) -> Results<HubCard> {
        let predicate = NSPredicate(format: "name IN %@ && status != 'archived'", hubs)
        return realm.objects(HubCard.self).filter(predicate).sorted(byKeyPath: "priority", ascending: false)
    }
    
    public func getArchivedCards(hubs:[String]) -> Results<HubCard> {
        let predicate = NSPredicate(format: "name IN %@ && status == 'archived'", hubs)
        return realm.objects(HubCard.self).filter(predicate).sorted(byKeyPath: "priority", ascending: false)
    }
    
    public func getHubCardWithId(_ cardId: String) -> HubCard? {
        return realm.object(ofType: HubCard.self, forPrimaryKey: cardId)
    }
    
    public func getHubCardsWithSection(hubs:[String],  section: String) -> Results<HubCard> {
        let predicate = NSPredicate(format: "name IN %@ && section = %@ && status != 'archived'", hubs, section)
        return realm.objects(HubCard.self).filter(predicate)
    }
    
    public func getHubCardWithName(_ name: String) -> HubCard? {
        let predicate = NSPredicate(format: "name= %@ && status != 'archived'", name)
        let results =  realm.objects(HubCard.self).filter(predicate)
        if results.count > 0 {
            return results[0]
        } else { return nil }
    }
    
    public func getNonEmptyHubCardsWithSection(hubs:[String],  section: String) -> Results<HubCard> {
        let predicate = NSPredicate(format: "name IN %@ && section = %@ && type != %@ && status!= 'archived'", hubs, section, "empty_state")
        return realm.objects(HubCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:false)
    }
    
    public func getEmptyHubCardsWithSection(hubs:[String],  section: String) -> Results<HubCard> {
        let predicate = NSPredicate(format: "name IN %@ && section = %@ && type == %@ && status != 'archived'", hubs, section, "empty_state")
        return realm.objects(HubCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:false)
    }
    
    public func getSections(hubs:[String]) -> [String] {
        let distinctTypes = Array(Set(self.getHubCards(hubs:hubs).value(forKey: "section") as! [String]))
        return distinctTypes
    }
    
    public func countSections(hubs:[String]) -> Int {
        let distinctTypes = Array(Set(self.getHubCards(hubs:hubs).value(forKey: "section") as! [String]))
        return distinctTypes.count
    }
    
    public func getLastCardUpdateDate() -> Date {
        let result = realm.objects(HubCard.self).sorted(byKeyPath: "updateDate", ascending:false)
        if result.count > 0 {
            return result[0].updateDate
        }
        else {
            return Date(timeIntervalSince1970: 0)
        }
    }
    
    public func wipe() {
        let realm = try! Realm()
        let allCards = realm.objects(HubCard.self)
        
        try! realm.write {
            realm.delete(allCards)
        }
    }
    
    public func updateWithArray(_ cards: [HubCard]?) {
        
        if cards == nil { return }
        
        let realm = try! Realm()
        try! realm.write {
            for newCard in cards! {
                realm.add(newCard, update:true)
            }
        }//try
    }
    
}

