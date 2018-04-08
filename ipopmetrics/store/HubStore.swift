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

protocol HubStoreProtocol {
    
    func getNonEmptyHubCardsWithSection(hubs: [String], section: String) -> [HubCardProtocol]
    func getEmptyHubCardsWithSection(hubs: [String], section: String) -> [HubCardProtocol]
    func getHubCardWithName(_ name:String) -> HubCardProtocol?
}

class HubStore<T:HubCard>: HubStoreProtocol{
    
    
    // protocol conforming methods
    func getNonEmptyHubCardsWithSection(hubs: [String], section: String) -> [HubCardProtocol] {
        return Array(self.getNonEmptyHubCardsWithSectionResults(hubs: hubs, section: section))
    }
    
    func getEmptyHubCardsWithSection(hubs: [String], section: String) -> [HubCardProtocol] {
        return Array(self.getEmptyHubCardsWithSectionResults(hubs: hubs, section: section))
    }
    
    
    private let realm = try! Realm()
    
    public func getHubCards(hubs:[String]) -> Results<T> {
        let predicate = NSPredicate(format: "hub IN %@ && status != 'archived'", hubs)
        return realm.objects(T.self).filter(predicate).sorted(byKeyPath: "priority", ascending: false)
    }
    
    public func getArchivedCards(hubs:[String]) -> Results<T> {
        let predicate = NSPredicate(format: "hub IN %@ && status == 'archived'", hubs)
        return realm.objects(T.self).filter(predicate).sorted(byKeyPath: "priority", ascending: false)
    }
    
    public func getHubCardWithId(_ cardId: String) -> HubCard? {
        return realm.object(ofType: T.self, forPrimaryKey: cardId)
    }
    
    public func getHubCardsWithSection(hubs:[String],  section: String) -> Results<T> {
        let predicate = NSPredicate(format: "hub IN %@ && section = %@ && status != 'archived'", hubs, section)
        return realm.objects(T.self).filter(predicate)
    }
    
    public func getHubCardWithName(_ name: String) -> HubCardProtocol? {
        let predicate = NSPredicate(format: "name= %@ && status != 'archived'", name)
        let results =  realm.objects(T.self).filter(predicate)
        if results.count > 0 {
            return results[0] as HubCardProtocol
        } else { return nil }
    }
    
    public func getNonEmptyHubCardsWithSectionResults(hubs:[String],  section: String) -> Results<T> {
        let predicate = NSPredicate(format: "hub IN %@ && section = %@ && ctype != %@ && status!= 'archived'", hubs, section, "empty_state")
        return realm.objects(T.self).filter(predicate).sorted(byKeyPath: "priority", ascending:false)
    }
    
    public func getEmptyHubCardsWithSectionResults(hubs:[String],  section: String) -> Results<T> {
        let predicate = NSPredicate(format: "hub IN %@ && section = %@ && ctype == %@ && status != 'archived'", hubs, section, "empty_state")
        return realm.objects(T.self).filter(predicate).sorted(byKeyPath: "priority", ascending:false)
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
        let result = realm.objects(T.self).sorted(byKeyPath: "updateDate", ascending:false)
        if result.count > 0 {
            return result[0].updateDate
        }
        else {
            return Date(timeIntervalSince1970: 0)
        }
    }
    

    public func archiveCard(_ card: T) {
        
        try! realm.write {
            card.status = "archived"
            realm.add(card, update:true)
        }
    }
    
    public func wipe() {
        let realm = try! Realm()
        let allCards = realm.objects(T.self)
        
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

