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
 

class StatisticSummaryItem: Object, Mappable {
    
    dynamic var statisticCard: StatisticsCard? = nil
    
    
    dynamic var value: Float = 0
    dynamic var label: String = ""
    dynamic var delta: Float = 0
    
    
    override static func primaryKey() -> String? {
        return "label"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        value <- map["value"]
        label <- map["label"]
        delta <- map["delta"]
        
    }
    
}
*/

class StatisticMetric: Object, Mappable {
    
    dynamic var statisticCard: StatisticsCard? = nil
    
    dynamic var statisticsCardId: String = ""
    
    dynamic var value: Float = 0
    dynamic var label: String = ""
    dynamic var delta: Float = 0
    
    dynamic var pageName: String = "Card"
    dynamic var pageIndex: Int = 0
    dynamic var indexInPage: Int = 0
    
    dynamic var currentPeriodLabel: String = ""
    dynamic var currentPeriodValues: String = ""
    dynamic var currentPeriodStartDate: Date = Date()
    dynamic var currentPeriodEndDate: Date = Date()
    
    dynamic var prevPeriodLabel: String = ""
    dynamic var prevPeriodValues: String = ""
    dynamic var prevPeriodStartDate: Date = Date()
    dynamic var prevPeriodEndDate: Date = Date()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "statisticsCardId"
    }
    
    func mapping(map: Map) {
        statisticsCardId <- map["statistics_card_id"]
        
        value <- map["value"]
        label <- map["label"]
        delta <- map["delta"]
        
        pageName <- map["page_name"]
        pageIndex <- map["page_index"]
        indexInPage <- map["index_in_page"]
        
        currentPeriodLabel <- map["current_period_label"]
        currentPeriodValues <- map["current_period_values"]
        currentPeriodStartDate <- (map["current_period_start_date"], DateTransform())
        currentPeriodEndDate <- (map["current_period_end_date"], DateTransform())
        
        prevPeriodLabel <- map["prev_period_label"]
        prevPeriodValues <- map["prev_period_values"]
        
        prevPeriodStartDate <- (map["prev_period_start_date"], DateTransform())
        prevPeriodEndDate <- (map["prev_period_end_date"], DateTransform())
        
    }
    
    func getCurrentPeriodArray() -> [Double] {
        let sarr = self.currentPeriodValues.components(separatedBy: " ")
        return sarr.map{ Double($0)! }
    }
    
    func getPrevPeriodArray() -> [Double] {
        let sarr = self.prevPeriodValues.components(separatedBy: " ")
        return sarr.map{ Double($0)! }
    }
}



class StatisticsCard: Object, Mappable {
    
    dynamic var cardId: String? = nil
    
    dynamic var createDate: Date = Date()
    dynamic var updateDate: Date = Date()
    
    
    dynamic var index = 0
    
    dynamic var type = ""
    dynamic var section = ""
    
    override static func primaryKey() -> String? {
        return "cardId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cardId          <- map["id"]
        
        createDate      <- (map["create_dt"], DateTransform())
        updateDate      <- (map["update_dt"], DateTransform())
        
        index           <- map["index"]
        type            <- map["type"]
        section         <- map["section"]
    }
}

