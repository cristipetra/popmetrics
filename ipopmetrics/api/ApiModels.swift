//
//  ApiModels.swift
//  ipopmetrics
//
//  Created by Rares Pop on 04/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import ObjectMapper

class PNotification: Mappable {
    
    var alert: String?
    var title: String?
    var subtitle: String?
    var type: String?
    var sound: String?
    var badge: Int?
    
    var deepLink: String?
    
    required init?(map:Map) {
        
    }
    
    
    func mapping(map:Map) {
        alert         <- map["aps.alert"]
        title         <- map["title"]
        subtitle      <- map["subtitle"]
        type          <- map["type"]
        sound         <- map["aps.sound"]
        badge         <- map["aps.badge"]
        deepLink      <- map["deep_link"]        
    }
}

protocol ResponseWrap: class {
    
    func getCode() -> String
    func getMessage() -> String
}

class ResponseWrapper<T:Mappable>: Mappable {
    
    var code:String?
    var message: String?
    
    required init?(map:Map) {
        
    }
    
    
    func mapping(map:Map) {
        code    <- map["code"]
        message <- map["message"]
    }
    
}

class ResponseWrapperEmpty: Mappable, ResponseWrap {
    
    var code:String?
    var message: String?
    
    func getCode() -> String {
        return self.code ?? "unsuccessfull"
    }
    func getMessage() -> String {
        return self.message ?? "Unspecified error message"
    }
    
    required init?(map:Map) {
        
    }
    
    
    func mapping(map:Map) {
        code    <- map["code"]
        message <- map["message"]

    }
    
}


class ResponseWrapperOne<T:Mappable>: Mappable, ResponseWrap {
    
    var code:String?
    var message: String?
    var data: T?
    
    func getCode() -> String {
        return self.code ?? "unsuccessfull"
    }
    func getMessage() -> String {
        return self.message ?? "Unspecified error message"
    }
    
    required init?(map:Map) {
        
    }
    
    
    func mapping(map:Map) {
        code    <- map["code"]
        message <- map["message"]
        data    <- map["data"]
    }
    
}

class ResponseWrapperArray<T:Mappable>: Mappable, ResponseWrap {
    
    var code:String?
    var message: String?
    var data: [T]?
    
    func getCode() -> String {
        return self.code ?? "unsuccessfull"
    }
    func getMessage() -> String {
        return self.message ?? "Unspecified error message"
    }
    
    required init?(map:Map) {
        
    }
    
    
    func mapping(map:Map) {
        code    <- map["code"]
        message <- map["message"]
        data    <- map["data"]
    }
    
}


class TeamMembership: Mappable{
    var brandId: String?
    var brandName: String?
    var roles: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        print(map.JSON)
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

class UserSettings: Mappable {
    var userAccount: UserAccount?
    var currentBrand: Brand?
    
    var overlayActions: String?
    var overlayDescription: String?
    var overlayActionUrl: String?
    
    var allowSounds: Bool = true
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userAccount         <- map["user_account"]
        currentBrand        <- map["brand"]
        allowSounds         <- map["allow_sounds"]
        
        overlayDescription  <- map["overlay_description"]
        overlayActions      <- map["overlay_actions"]
        overlayActionUrl    <- map["overlay_action_url"]
    }
    
    func getOverlayActions() -> [String] {
        let actions =  overlayActions?.components(separatedBy: ",")
        return actions!
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

class GoogleAnalyticsDetails: Mappable {
    
    var name: String?
    var tracker: String?
    
    var connectionDate: Date?
    var connectionEmail: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        name        <- map["view.web_property_name"]
        tracker     <- map["view.web_property_id"]
        
        connectionDate <- (map["connection.date"], DateTransform())
        connectionEmail <- map["connection.email"]
        
    }
}



class Brand: Mappable {

    var id: String?
    var name: String?
    var logoURL: String?
    
    var googleAnalytics: GoogleAnalyticsDetails?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        name        <- map["name"]
        id          <- map["id"]
        logoURL     <- map["logo_url"]
        
        googleAnalytics <- map["data.google_analytics"]
        
        
    }
}

class RequiredActionResponse: Mappable {
    
    var scheduled: Bool?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        scheduled               <- map["scheduled"]
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

class HubsResponse: Mappable {
    
    var feed: FeedResponse?
    var todo: TodoResponse?
    var calendar: CalendarResponse?
    var stats: StatisticsResponse?
    
    var sendApnToken: Bool
    
    required init?(map: Map) {
        sendApnToken = false
    }
    
    func mapping(map:Map) {
        feed               <- map["feed"]
        todo               <- map["todo"]
        calendar           <- map["calendar"]
        stats              <- map["stats"]
        sendApnToken       <- map["send_apn_token"]
    }
    
}

