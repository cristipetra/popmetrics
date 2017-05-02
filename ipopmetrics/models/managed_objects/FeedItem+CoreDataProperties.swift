//
//  FeedItem+CoreDataProperties.swift
//  
//
//  Created by Rares Pop on 07/04/2017.
//
//

import Foundation
import CoreData


extension FeedItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedItem> {
        return NSFetchRequest<FeedItem>(entityName: "FeedItem")
    }

    @NSManaged public var srvId: String?
    @NSManaged public var type: String?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var timestamp: NSDate?

}
