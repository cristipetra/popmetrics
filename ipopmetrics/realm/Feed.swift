//
//  FeedSection.swift
//  
//
//  Created by Rares Pop on 17/05/2017.
//
//

import Foundation
import RealmSwift

class FeedItem: Object {
    
    dynamic var index = 0
    
    dynamic var type = ""
    dynamic var headerTitle: String? = nil
    dynamic var headerSubtitle: String? = nil
    dynamic var headerIconUri:String? = nil
    dynamic var message:String? = nil
    dynamic var actionHandler = ""
    dynamic var actionLabel = ""
    dynamic var imageUri:String? = nil
}

class FeedSection: Object {

    dynamic var name = ""
    dynamic var index = 0
    
    let items = List<FeedItem>()
    
}


