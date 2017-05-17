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
    
    static func getInstance() -> FeedStore {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.feedStore
    }
    
    
public func getFeed() -> [FeedSection] {
        let realm = try! Realm()
        let sections = realm.objects(FeedSection.self).sorted(byKeyPath: "index")
        
        var results = [FeedSection]()
        for section in sections {
            results.append(section)
        }
        
        return results

    }
    
    public func storeFeed(_ dict: [String:Any] ) {
        
        let realm = try! Realm()
        
        // delete existing
        try! realm.write {
            realm.delete(realm.objects(FeedItem))
            realm.delete(realm.objects(FeedSection))
        }
        
        try! realm.write {
            
        
            var scount = 0
            if let sections = dict["sections"] as? [[String:Any]] {
                for jsection in sections {
                    let feedSection = FeedSection()
                    feedSection.name = (jsection["name"] as? String)!
                    feedSection.index = scount
                    
                    realm.add(feedSection)
                    
                    var icount = 0
                    if let items = jsection["items"] as? [[String:Any]] {
                        for jitem in items {
                            let feedItem = FeedItem()
                            feedItem.index = icount
                            feedItem.type = (jitem["type"] as? String)!
                            feedItem.headerTitle = jitem["header_title"] as? String
                            feedItem.headerSubtitle = jitem["header_subtitle"] as? String
                            feedItem.headerIconUri = jitem["header_icon"] as? String
                            feedItem.message = jitem["message"] as? String
                            feedItem.actionHandler = (jitem["action_handler"] as? String)!
                            feedItem.actionLabel = (jitem["action_label"] as? String)!
                            feedItem.imageUri = jitem["image"] as? String
                            
                            realm.add(feedItem)
                            feedSection.items.append(feedItem)
                            
                            icount+=1
                        }
                    }
                    
                    scount+=1
                    
                }
            }
        }// try realm.write
        
    }
    

}
