//
//  PopmetricsHubItems.swift
//  ipopmetrics
//
//  Created by Rares Pop on 03/04/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


class StatsSummaryItem: Object, Mappable {
    
    @objc dynamic var feedCard: FeedCard? = nil
    
    @objc dynamic var value: Float = 0
    @objc dynamic var label: String = ""
    @objc dynamic var delta: Float = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        value <- map["value"]
        label <- map["label"]
        delta <- map["delta"]
    }
    
}



class PopHubCard: HubCard {
    
    @objc dynamic var recommendedAction = ""
    @objc dynamic var forInsight = ""
    
    @objc dynamic var blogUrl:String? = nil
    @objc dynamic var blogTitle:String? = nil
    @objc dynamic var blogImageUrl:String? = nil
    @objc dynamic var blogSummary:String? = nil
    
    @objc dynamic var detailsMarkdown:String? = ""
    @objc dynamic var closingMarkdown:String? = ""
    
    @objc dynamic var iceEnabled: Int = 0
    @objc dynamic var iceImpactPercentage: Int = 0
    @objc dynamic var iceImpactSplitJson: String? = nil // "[{'label': "Website Traffice", 'percentage': 10}]"
    var iceImpactSplit: [LabelAndPercentage] = []
    
    @objc dynamic var iceCostLabel: String? = nil
    @objc dynamic var iceCostPercentage: Int = 0
    @objc dynamic var iceEffortLabel: String? = nil
    @objc dynamic var iceEffortPercentage: Int = 0
    
    @objc dynamic var iceAimee: String? = nil
    
    @objc dynamic var impactPercentage: Int = 0
    @objc dynamic var impactSplitJson: String? = nil // "[{'label': "Website Traffice", 'percentage': 10}]"
    var impactSplit: [LabelAndPercentage] = []
    
    @objc dynamic var diyInstructions: String? = nil // ['## markdown1', '### markdown 2 *b']
    @objc dynamic var insightArguments: String? = nil // ['## markdown1', '### amrkdown 2']
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        blogUrl         <- map["blog_url"]
        blogTitle       <- map["blog_title"]
        blogImageUrl    <- map["blog_image_url"]
        blogSummary     <- map["blog_summary"]
        
        detailsMarkdown <- map["details_markdown"]
        closingMarkdown <- map["closing_markdown"]
        
        iceEnabled          <- map["ice_enabled"]
        iceImpactPercentage <- map["ice_impact_percentage"]
        iceImpactSplit  <- map["ice_impact_split"]
        iceImpactSplitJson = iceImpactSplit.toJSONString()
        
        iceCostLabel        <- map["ice_cost_label"]
        iceCostPercentage   <- map["ice_cost_percentage"]
        iceEffortLabel      <- map["ice_effort_label"]
        iceEffortPercentage <- map["ice_effort_percentage"]
        
        impactPercentage    <- map["impact_percentage"]
        impactSplit         <- map["impact_split"]
        impactSplitJson     <- map["impact_split"]
        
        diyInstructions     <- map["diy_instructions"]
        insightArguments    <- map["insight_arguments"]
    }
    
    func getInsightArgumentsArray() -> [String] {
        if self.insightArguments == nil {
            return []
        }
        return self.insightArguments?.toJSON() as! [String]
    }
    
    func getDiyInstructions() -> [String] {
        if self.diyInstructions == nil {
            return []
        }
        return self.diyInstructions?.toJSON() as! [String]
    }
    
}

class LabelAndPercentage: Mappable {
    
    var label: String = ""
    var percentage: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        label           <- map["label"]
        percentage      <- map["percentage"]
    }
    
}
