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
    @objc dynamic var name = ""
    
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
    
    @objc dynamic var iceEnabled: Int = 0
    @objc dynamic var iceImpactPercentage: Int = 0
    @objc dynamic var iceImpactSplit: String? = nil // "[{'label': "Website Traffice", 'percentage': 10}]"
    
    @objc dynamic var iceCostLabel: String? = nil
    @objc dynamic var iceCostPercentage: Int = 0
    @objc dynamic var iceEffortLabel: String? = nil
    @objc dynamic var iceEffortPercentage: Int = 0
    
    @objc dynamic var iceAimee: String? = nil
    
    @objc dynamic var impactPercentage: Int = 0
    @objc dynamic var impactSplit: String? = nil // "[{'label': "Website Traffice", 'percentage': 10}]"
    
    @objc dynamic var diyInstructions: String? = nil // ['## markdown1', '### markdown 2 *b']
    @objc dynamic var insightArguments: String? = nil // ['## markdown1', '### amrkdown 2']
    
    
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
        name            <- map["name"]
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
        
        createDate      <- (map["create_dt"], DateTransform())
        updateDate      <- (map["update_dt"], DateTransform())
        
        iceEnabled      <- map["ice_enabled"]
        iceImpactPercentage <- map["ice_impact_percentage"]
        iceImpactSplit <- map["ice_impact_split"]
        iceCostLabel <- map["ice_cost_label"]
        iceCostPercentage <- map["ice_cost_percentage"]
        iceEffortLabel <- map["ice_effort_label"]
        iceEffortPercentage <- map["ice_effort_percentage"]
        
        impactPercentage <- map["impact_percentage"]
        impactSplit <- map["impact_split"]
        
        
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
    
    func getIceImpactSplit() -> [ImpactSplit] {
        guard let _  = iceImpactSplit else { return [] }
        let values = iceImpactSplit!
        let splitImpactArray = values.toJSON() as! NSMutableArray
        
        var dict: [ImpactSplit] = []
        dict.removeAll()
        for index in 0..<splitImpactArray.count {
            if let obj = splitImpactArray.object(at: index) as? [String: Any] {
                var impact = ImpactSplit()
                impact.initParam(param: obj)
                dict.append(impact)
            }
        }
        return dict
    }

}

struct ImpactSplit {
    var label: String = ""
    var percentage: Int = 0
    
    mutating func initParam(param: [String: Any]) {
        label = param["label"] as! String
        percentage = param["percentage"] as! Int
    }
}


extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
