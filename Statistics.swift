//
//  Statistics.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 29/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

/*
class StatisticsItem: Object {
    dynamic var index = 0
    
    dynamic var type = ""
    dynamic var status: String? = nil
    dynamic var statusDate: Date? = nil
    dynamic var articleCategory:String? = nil
    dynamic var articleTitle:String? = nil
    
    dynamic var articleText = ""
    dynamic var articleUrl = ""
    var articleHastags: [Any?] = []
    dynamic var articleImage:String? = nil
}

class StatisticsSection: NSObject{
    dynamic var name = ""
    dynamic var status: String = "";
    dynamic var index = 0
    
    var items = [StatisticsItem]()
}
 */

class StatisticSummaryItem: Object, Mappable {
    
    dynamic var statisticCard: StatisticCard? = nil
    
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

class StatisticCard: Object, Mappable {
    dynamic var id = 0
    
    dynamic var cardId: String? = nil
    
    dynamic var index = 0
    
    dynamic var type = ""
    dynamic var section = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cardId          <- map["id"]
        index           <- map["index"]
        type            <- map["type"]
        section         <- map["section"]
    }
}
