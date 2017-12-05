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

class MetricBreakdown: Mappable {
    
    var label: String?
    var currentValue: Float?
    var deltaValue: Float?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        label           <- map["label"]
        currentValue    <- map["current_value"]
        deltaValue      <- map["delta_value"]
    }
    
}


class MetricGroupBreakdown: Mappable {
    
    var group: String?
    var breakdowns: [MetricBreakdown]?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        group               <- map["group"]
        breakdowns          <- map["breakdowns"]
    }
    
}


class StatisticMetric: Object, Mappable {
    
    @objc dynamic var statisticCard: StatisticsCard? = nil
    
    @objc dynamic var statisticsCardId: String = ""
    
    @objc dynamic var value: Float = 0
    @objc dynamic var label: String = ""
    @objc dynamic var delta: Float = 0
    
    @objc dynamic var pageName: String = "Card"
    @objc dynamic var pageIndex: Int = 0
    @objc dynamic var indexInPage: Int = 0
    
    @objc dynamic var currentPeriodLabel: String = ""
    @objc dynamic var currentPeriodValues: String = ""
    @objc dynamic var currentPeriodStartDate: Date = Date()
    @objc dynamic var currentPeriodEndDate: Date = Date()
    
    @objc dynamic var prevPeriodLabel: String = ""
    @objc dynamic var prevPeriodValues: String = ""
    @objc dynamic var prevPeriodStartDate: Date = Date()
    @objc dynamic var prevPeriodEndDate: Date = Date()
    
    var breakdowns: [MetricGroupBreakdown]?
    @objc dynamic var breakDownsJson: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        statisticsCardId <- map["card_id"]
        
        value <- map["value"]
        label <- map["label"]
        delta <- map["delta"]
        
        pageName <- map["page_name"]
        pageIndex <- map["page_index"]
        
        currentPeriodLabel <- map["current_period_label"]
        currentPeriodValues <- map["current_period_values"]
        currentPeriodStartDate <- (map["current_period_start_date"], DateTransform())
        currentPeriodEndDate <- (map["current_period_end_date"], DateTransform())
        
        prevPeriodLabel <- map["prev_period_label"]
        prevPeriodValues <- map["prev_period_values"]
        
        prevPeriodStartDate <- (map["prev_period_start_date"], DateTransform())
        prevPeriodEndDate <- (map["prev_period_end_date"], DateTransform())
        
        breakdowns <- map["breakdowns"]
        
        self.setBreakDownGroups()
        
    }
    
    func getCurrentPeriodArray() -> [Double] {
        let sarr = self.currentPeriodValues.components(separatedBy: " ")
        return sarr.map{ Double($0)! }
    }
    
    func getPrevPeriodArray() -> [Double] {
        let sarr = self.prevPeriodValues.components(separatedBy: " ")
        return sarr.map{ Double($0)! }
    }
    
    func setBreakDownGroups() -> Void {
        self.breakDownsJson = (self.breakdowns?.toJSONString())!
    }
    
    
    func getBreakDownGroups() -> [MetricGroupBreakdown] {
        let list: Array<MetricGroupBreakdown> = Mapper<MetricGroupBreakdown>().mapArray(JSONString: self.breakDownsJson)!
        return list
    }
    
}



class StatisticsCard: Object, Mappable {
    
    @objc dynamic var cardId: String? = nil
    
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var updateDate: Date = Date()
    
    
    @objc dynamic var index = 0
    
    @objc dynamic var type = ""
    @objc dynamic var section = ""
    
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

