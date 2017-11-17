//
//  ApiModels.swift
//  ipopmetrics
//
//  Created by Rares Pop on 04/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import ObjectMapper


class ResponseWrapperEmpty: Mappable {
    
    var code:String?
    var message: String?
    
    
    required init?(map:Map) {
        
    }
    
    func mapping(map:Map) {
        code    <- map["code"]
        message <- map["message"]
    }
    
}


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
    var brandName: String?
    var roles: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        brandId      <- map["brand_id"]
        brandName    <- map["brand_name"]
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
    
    var businessURL: String {
        get {
            return "http//www.google.com"
        }
    }
    
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

class Brand: Mappable {

    var id: String?
    var name: String?
    var logoURL: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        name        <- map["name"]
        id          <- map["id"]
        logoURL     <- map["logo_url"]
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

class TodoResponse: Mappable {
    
    var cards: [TodoCard]?
    var socialPosts: [TodoSocialPost]?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        cards               <- map["cards"]
        socialPosts         <- map["social_posts"]
    }
    
    func matchCard(_ cardId:String) -> (Bool, TodoCard?) {
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
    
    func matchSocialPost(_ postId:String) -> (Bool, TodoSocialPost?) {
        if self.socialPosts == nil {
            return (false, nil)
        }
        if let i = self.socialPosts?.index(where: {$0.postId == postId}) {
            return (true, self.socialPosts![i])
        }
        else {
            return (false, nil)
        }
        
    }
    
}

class CalendarResponse: Mappable {
    
    var cards: [CalendarCard]?
    var socialPosts: [CalendarSocialPost]?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        cards               <- map["cards"]
        socialPosts         <- map["social_posts"]
    }
    
    func matchCard(_ cardId:String) -> (Bool, CalendarCard?) {
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
    
    func matchSocialPost(_ postId:String) -> (Bool, CalendarSocialPost?) {
        if self.socialPosts == nil {
            return (false, nil)
        }
        if let i = self.socialPosts?.index(where: {$0.postId == postId}) {
            return (true, self.socialPosts![i])
        }
        else {
            return (false, nil)
        }
        
    }
    
}

class StatisticsResponse: Mappable {
    
    var cards: [StatisticsCard]?
    var metrics: [StatisticMetric]?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        cards               <- map["cards"]
        metrics   <- map["metrics"]
    }
    
    func matchCard(_ cardId:String) -> (Bool, StatisticsCard?) {
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



