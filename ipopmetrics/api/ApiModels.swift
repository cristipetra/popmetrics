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

class ResponseWebsite: Mappable {
    var code: String?
    var message: String?
    var data: String?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code      <- map["code"]
        message   <- map["message"]
        data      <- map["data"]
    }
}

class ResponseSignup: Mappable {
    var code: String?
    var message: String?
    var data: String?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code      <- map["code"]
        message   <- map["message"]
        data      <- map["data"]
    }
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
    
    var allowSounds: Bool = true
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userAccount         <- map["user_account"]
        currentBrand        <- map["brand"]
        allowSounds         <- map["allow_sounds"]

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
        tracker     <- map["view.id"]
        
        connectionDate <- (map["connection.date"], DateTransform())
        connectionEmail <- map["connection.email"]
        
    }
}

class FacebookDetails: Mappable {
    var name: String?
    var screenName: String?
    var connectionDate: Date?
    
    var accessToken: String?
    var selectedAccountId: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name              <- map[""]
        connectionDate    <- (map["connection.date"], DateTransform())
    }
    
}

class TwitterDetails: Mappable {
    
    var name: String?
    var screenName: String?
    
    var connectionDate: Date?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        name        <- map["name"]
        screenName     <- map["screen_name"]
        
        connectionDate <- (map["connection_date"], DateTransform())
        
    }
}

class OverlayDetails: Mappable {

    var id: String?
    var title:String?
    var layout:String?
    var colorScheme:String?
    
    var message:String?
    var ctaText:String?
    var ctaLink:String?
    var ctaType:String?
    
    var availableActions: [String] = []
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        id              <- map["id"]
        title           <- map["title"]
        layout          <- map["layout"]
        colorScheme     <- map["color_scheme"]
        message         <- map["message"]
        ctaText         <- map["cta_text"]
        ctaLink          <- map["cta_link"]
        ctaType         <- map["cta_type"]
        availableActions <- map["actions"]
    }
    
}

class Brand: Mappable {

    var id: String?
    var name: String?
    var logoURL: String?
    var domainURL: String?
    var isTestBrand: Bool?
    
    var googleAnalytics: GoogleAnalyticsDetails?
    var twitterDetails: TwitterDetails?
    var facebookDetails: FacebookDetails?
    
    var overlayDetails: OverlayDetails?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        name        <- map["name"]
        id          <- map["id"]
        logoURL     <- map["logo_url"]
        domainURL   <- map["domain_url"]
        isTestBrand <- map["is_test_brand"]
        
        googleAnalytics <- map["data.google_analytics"]
        twitterDetails  <- map["social.twitter"]
        facebookDetails <- map["social.facebook"]
        overlayDetails  <- map["overlay"]
        
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
    
    var cards: [StatsCard]?
    var metrics: [StatsMetric]?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        cards               <- map["cards"]
        metrics   <- map["metrics"]
    }
    
    func matchCard(_ cardId:String) -> (Bool, StatsCard?) {
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
    
    var lastDate: Date = Date()
    
    var sendApnToken: Bool
    
    required init?(map: Map) {
        sendApnToken = false
    }
    
    func mapping(map:Map) {
        feed               <- map["Home"]
        todo               <- map["Todo"]
        calendar           <- map["Calendar"]
        stats              <- map["Stats"]
        sendApnToken       <- map["send_apn_token"]
        lastDate           <- (map["last_date"], DateTransform())
        
    }
    
}

