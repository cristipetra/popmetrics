//
//  FeedItemsStore.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import CoreData

class FeedItemsStore: Store {
    
    static func getInstance() -> FeedItemsStore {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.feedItemsStore
    }
    
    func getFeedItems(_ deleted: Bool = false) -> [FeedItem] {
        if let fetchRequest: NSFetchRequest<FeedItem> = createFetchRequest() {
//            if !deleted {
//                fetchRequest.predicate = NSPredicate(format: "deletedAt == nil")
//            }
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            if let results = executeFetchRequest(fetchRequest: fetchRequest) {
                return results
            }
        }
        return [FeedItem]()
    }
    
    func findItemWithSrvId(_ srvId: String) -> FeedItem? {
        if let fetchRequest: NSFetchRequest<FeedItem> = createFetchRequest() {
            fetchRequest.predicate = NSPredicate(format: "srvId == %@", srvId)
            if let results = executeFetchRequest(fetchRequest: fetchRequest) {
                return results.first
            }
        }
        return nil
    }
    
    
    func createFeedItem(dict: [String:Any]) -> FeedItem {
        
        var item: FeedItem
        item = createEntityWithName("FeedItem") as! FeedItem
        
        if let srvId = dict["id"] as? String {
            item.srvId = srvId
        }
        return updateFeedItem(item: item, dict: dict)
    }
    
    func updateFeedItem(item: FeedItem, dict:[String: Any]) -> FeedItem {
        if let srvId = dict["id"] as? String {
            item.srvId = srvId
        }
        if let title = dict["title"] as? String {
            item.title = title
        }
        if let desc = dict["desc"] as? String {
            item.desc = desc
        }
        if let type = dict["type"] as? String {
            item.type = type
        }
        
        return item
    }

}
