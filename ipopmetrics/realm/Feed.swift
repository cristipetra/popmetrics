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

class FeedCard: Object, Mappable {

    @objc dynamic var cardId: String? = nil
    
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var updateDate: Date = Date()

    @objc dynamic var index = 0
    
    @objc dynamic var type = ""
    @objc dynamic var section = ""
    
    @objc dynamic var headerTitle: String? = nil
    @objc dynamic var headerSubtitle: String? = nil
    @objc dynamic var headerIconUri:String? = nil
    @objc dynamic var message:String? = nil
    
    @objc dynamic var actionLabel = ""
    @objc dynamic var actionHandler = ""
    @objc dynamic var imageUri:String? = nil
    @objc dynamic var blogUrl:String? = nil
    @objc dynamic var detailsMarkdown:String? = ""
    
    
    @objc dynamic var tooltipEnabled = 0
    @objc dynamic var tooltipTitle: String? = nil
    @objc dynamic var tooltipContent: String? = nil
    
    @objc dynamic var iceEnabled: Int = 0
    @objc dynamic var iceImpactPercentage: Int = 0
    @objc dynamic var iceImpactSplit: String? = nil // "[{'label': "Website Traffice", 'percentage': 10}]"
    
    @objc dynamic var iceCostLabel: String? = nil
    @objc dynamic var iceCostPercentage: Int = 0
    @objc dynamic var iceEffortLabel: String? = nil
    @objc dynamic var iceEffortPercentage: Int = 0
    
    @objc dynamic var iceAimee: String? = nil
    
    @objc dynamic var diyInstructions: String? = nil // ['## markdown1', '### markdown 2 *b']
    @objc dynamic var insightArguments: String? = nil // ['## markdown1', '### amrkdown 2']
    
    
    override static func primaryKey() -> String? {
        return "cardId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        print(map["ice_impact_split"].currentValue)
        cardId          <- map["id"]
        index           <- map["index"]
        type            <- map["type"]
        section         <- map["section"]
        headerTitle     <- map["header_title"]
        headerSubtitle  <- map["header_subtitle"]
        headerIconUri   <- map["header_icon"]
        blogUrl         <- map["blog_url"]
        message         <- map["message"]
        actionLabel     <- map["action_label"]
        actionHandler   <- map["handler"]
        detailsMarkdown <- map["details_markdown"]
        
        tooltipEnabled  <- map["tooltip_enabled"]
        tooltipTitle    <- map["tooltip_title"]
        tooltipContent  <- map["tooltip_content"]
        
        createDate      <- (map["create_dt"], DateTransform())
        updateDate      <- (map["update_dt"], DateTransform())
        
        iceEnabled      <- map["ice_enabled"]
        iceImpactPercentage <- map["ice_impact_percentage"]
        iceImpactSplit <- map["ice_impact_split"]
        iceCostLabel <- map["ice_cost_label"]
        iceCostPercentage <- map["ice_cost_percentage"]
        iceEffortLabel <- map["ice_effort_label"]
        iceEffortPercentage <- map["ice_effort_percentage"]
        
        diyInstructions     <- map["diy_instructions"]
        insightArguments    <- map["insight_arguments"]
    }
    
    func getInsightArgumentsArra() -> [String]{
        
        if insightArguments != nil {
            let sarr = self.insightArguments?.components(separatedBy: ",")
            return sarr.map{ ($0) }!
        }
        return []
    }
    
    func getDiyInstructions() -> [String] {
        return ["## markdown1", "##### markdown 2 *b"]
    }

}


extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
