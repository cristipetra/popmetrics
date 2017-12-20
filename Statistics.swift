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
    var prevValue: Float?
    var deltaValue: Float?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        label           <- map["label"]
        currentValue    <- map["current_value"]
        prevValue       <- map["prev_value"]
        
        let cV = currentValue ?? 0
        let pV = prevValue ?? 0
        deltaValue = cV - pV
    }
    
}


class MetricGroupBreakdown: Mappable {
    
    var group: String?
    var breakdowns: [MetricBreakdown]?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        group               <- map["label"]
        breakdowns          <- map["breakdowns"]
    }
    
}


class StatsMetric: Object, Mappable {
    
    @objc dynamic var statsCard: StatsCard? = nil
    @objc dynamic var statsMetricId: String = ""
    
    @objc dynamic var statsCardId: String = ""
    
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var updateDate: Date = Date()
    
    @objc dynamic var status = ""
    
    @objc dynamic var value: Float = 0
    @objc dynamic var label: String = ""
    @objc dynamic var delta: Float = 0
    
    @objc dynamic var pageName: String = "Card"
    @objc dynamic var pageIndex: Int = 0
    
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
    
    override static func primaryKey() -> String? {
        return "statsMetricId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        statsCardId <- map["card_id"]
        statsMetricId <- map["metric_id"]
        
        value <- map["value"]
        label <- map["label"]
        delta <- map["delta"]
        
        createDate      <- (map["create_dt"], DateTransform())
        updateDate      <- (map["update_dt"], DateTransform())
        status          <- map["status"]
        
        pageName <- map["label"]
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



class StatsCard: Object, Mappable {
    
    @objc dynamic var cardId: String? = nil
    
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var updateDate: Date = Date()
    
    
    @objc dynamic var index = 0
    
    @objc dynamic var type = ""
    @objc dynamic var section = ""
    @objc dynamic var status = ""
    
    @objc dynamic var headerTitle: String? = nil
    @objc dynamic var headerSubtitle: String? = nil
    @objc dynamic var headerIconUri:String? = nil
    @objc dynamic var message:String? = nil
    
    @objc dynamic var actionLabel = ""
    @objc dynamic var actionHandler = ""
    @objc dynamic var recommendedAction = ""
    
    @objc dynamic var imageUri:String? = nil
    @objc dynamic var blogUrl:String? = nil
    @objc dynamic var blogTitle:String? = nil
    @objc dynamic var blogImageUrl:String? = nil
    @objc dynamic var blogSummary:String? = nil
    
    @objc dynamic var detailsMarkdown:String? = ""
    @objc dynamic var closingMarkdown:String? = ""
    
    
    @objc dynamic var tooltipEnabled = 0
    @objc dynamic var tooltipTitle: String? = nil
    @objc dynamic var tooltipContent: String? = nil
    
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
        status          <- map["status"]
        
        headerTitle     <- map["header_title"]
        headerSubtitle  <- map["header_subtitle"]
        headerIconUri   <- map["header_icon"]
        imageUri        <- map["image_url"]
        
        blogUrl         <- map["blog_url"]
        blogTitle       <- map["blog_title"]
        blogImageUrl    <- map["blog_image_url"]
        blogSummary     <- map["blog_summary"]
        
        message         <- map["message"]
        actionLabel     <- map["action_label"]
        actionHandler   <- map["handler"]
        recommendedAction   <- map["recommended_action"]
        
        detailsMarkdown <- map["details_markdown"]
        closingMarkdown <- map["closing_markdown"]
        
        tooltipEnabled  <- map["tooltip_enabled"]
        tooltipTitle    <- map["tooltip_title"]
        tooltipContent  <- map["tooltip_content"]
        
    }
}

