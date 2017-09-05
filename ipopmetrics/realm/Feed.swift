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
    
    dynamic var values: [Float] = []
    dynamic var labels: [String] = []
    dynamic var deltas: [Float] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        values <- map["values"]
        labels <- map["labels"]
        deltas <- map["deltas"]
    }
    
}

class FeedCard: Object, Mappable {
    
    dynamic var id = 0
    
    dynamic var cardId: String? = nil
    
    dynamic var index = 0
    
    dynamic var type = ""
    dynamic var section = ""
    
    dynamic var headerTitle: String? = nil
    dynamic var headerSubtitle: String? = nil
    dynamic var headerIconUri:String? = nil
    dynamic var message:String? = nil
    
    dynamic var actionHandler = ""
    dynamic var actionLabel = ""
    dynamic var imageUri:String? = nil
    
    dynamic var tooltipTitle: String? = nil
    dynamic var tooltipContent: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cardId <- map["cardId"]
    }
    
    
}
