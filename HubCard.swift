//
//  HubCard.swift
//  ipopmetrics
//
//  Created by Rares Pop on 03/04/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

protocol HubCardProtocol {
    
    func getName() -> String
    func getSection() -> String
    func getType()  -> String
    
}


class HubCard:  Object, Mappable, HubCardProtocol {
    
    
    
    @objc dynamic var cardId: String? = nil
    
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var updateDate: Date = Date()
    
    @objc dynamic var priority = 0
    
    @objc dynamic var hub = ""
    @objc dynamic var ctype = ""
    @objc dynamic var section = ""
    @objc dynamic var name = ""
    @objc dynamic var status = ""
    @objc dynamic var isTest = false
    
    @objc dynamic var headerIconUri:String? = nil
    @objc dynamic var imageUri:String? = nil
    @objc dynamic var headerTitle: String? = nil
    @objc dynamic var headerSubtitle: String? = nil
    @objc dynamic var message:String? = nil
    
    @objc dynamic var primaryActionLabel = ""
    @objc dynamic var primaryAction = ""
    
    @objc dynamic var secondaryActionLabel = ""
    @objc dynamic var secondaryAction = ""
    
    
    @objc dynamic var tooltipEnabled = 0
    @objc dynamic var tooltipTitle: String? = nil
    @objc dynamic var tooltipMarkdown: String? = nil
   
    override static func primaryKey() -> String? {
        return "cardId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cardId          <- map["id"]
        hub             <- map["hub"]
        priority        <- map["sort_priority"]
        ctype           <- map["ctype"]
        section         <- map["section"]
        name            <- map["name"]
        status          <- map["status"]
        isTest          <- map["is_test"]
        
        headerTitle        <- map["header_title"]
        headerSubtitle     <- map["header_subtitle"]
        headerIconUri      <- map["header_icon"]
        imageUri           <- map["image_url"]
        
        message            <- map["message"]
        primaryActionLabel <- map["primary_action_label"]
        primaryAction      <- map["primary_action"]
        
        secondaryActionLabel <- map["secondary_action_label"]
        secondaryAction      <- map["secondary_action"]
        
        tooltipEnabled  <- map["tooltip_enabled"]
        tooltipTitle    <- map["tooltip_title"]
        tooltipMarkdown <- map["tooltip_markdown"]
        
        createDate      <- (map["create_dt"], DateTransform())
        updateDate      <- (map["update_dt"], DateTransform())
        
    }
    
    func getName() -> String {
        return name
    }
    
    func getSection() -> String {
        return section
    }
    
    func getType() -> String {
        return ctype
    }
}
