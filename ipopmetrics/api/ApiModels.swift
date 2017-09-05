//
//  ApiModels.swift
//  ipopmetrics
//
//  Created by Rares Pop on 04/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseWrapperOne<T:Mappable>: Mappable {
    
    var code:String?
    var message: String?
    var data: T?
    
    
    required init?(map:Map) {
        
    }
    
    func mapping(map:Map) {
        code    <- map["code"]
        data    <- map["data"]
        message <- map["message"]
    }
    
}

class ResponseWrapperArray<T:Mappable>: Mappable {
    
    var code:String?
    var message:String?
    var data: [T]?
    
    
    required init?(map:Map) {
        
    }
    
    func mapping(map:Map) {
        code  <- map["code"]
        data  <- map["data"]
        message <- map["message"]
    }
    
}


class TeamMembership: Mappable{
    var brandId: String?
    var roles: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        brandId      <- map["brand_id"]
        roles        <- map["roles"]
    }
}

class UserProfileDetails: Mappable{
    var brandTeams: [TeamMembership]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        brandTeams      <- map["brand_teams"]
    }
    
}

class UserAccount: Mappable {
    var name: String?
    var email: String?
    var id: String?
    var authToken: String?
    var phone: String?
    var profileDetails: UserProfileDetails?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        name        <- map["name"]
        email       <- map["email"]
        id          <- map["id"]
        authToken   <- map["authentication_token"]
        phone       <- map["phone"]
        profileDetails <- map["profile_details"]
    }
}

class FeedResponse: Mappable {
    
    var cards: [FeedCard]?
    var statsSummaryItem: StatsSummaryItem?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        cards               <- map["cards"]
        statsSummaryItem    <- map["stats_summary_item"]
    }
    
    func matchCard(_ cardId:String) -> (Bool, FeedCard?) {
        if self.cards == nil {
            return (false, nil)
        }
        if let i = self.cards?.index(where: {$0.cardId == cardId}) {
            return (true, self.cards![i])
        }
        else {
            return (false, nil)
        }
        
    }
    
}



