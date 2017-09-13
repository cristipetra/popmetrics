//
//  FeedSection.swift
//  
//
//  Created by Rares Pop on 17/05/2017.
//
//

import Foundation
import RealmSwift
import ObjectMapper


class StatsSummaryItem: Object, Mappable {
    
    dynamic var feedCard: FeedCard? = nil
    
    dynamic var value: Float = 0
    dynamic var label: String = ""
    dynamic var delta: Float = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        value <- map["value"]
        label <- map["label"]
        delta <- map["delta"]
    }
    
}

class FeedCard: Object, Mappable {

    dynamic var cardId: String? = nil
    
    dynamic var createDate: Date = Date()
    dynamic var updateDate: Date = Date()

    dynamic var index = 0
    
    dynamic var type = ""
    dynamic var section = ""
    
    dynamic var headerTitle: String? = nil
    dynamic var headerSubtitle: String? = nil
    dynamic var headerIconUri:String? = nil
    dynamic var message:String? = nil
    
    dynamic var actionLabel = ""
    dynamic var actionHandler = ""
    dynamic var imageUri:String? = nil
    
    dynamic var tooltipTitle: String? = nil
    dynamic var tooltipContent: String? = nil
    
    override static func primaryKey() -> String? {
        return "cardId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        cardId          <- map["id"]
        index           <- map["index"]
        type            <- map["type"]
        section         <- map["section"]
        headerTitle     <- map["header_title"]
        headerSubtitle  <- map["header_subtitle"]
        headerIconUri   <- map["header_icon"]
        message         <- map["message"]
        //actionLabel     <- map["action_label"]
        actionHandler   <- map["handler"]
        tooltipTitle    <- map["tooltip_title"]
        tooltipContent  <- map["tooltip_conent"]
        
        createDate      <- (map["create_dt"], DateTransform())
        updateDate      <- (map["update_dt"], DateTransform())
        
    }
    
}
