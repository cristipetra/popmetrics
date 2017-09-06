//
//  Todo.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class TodoCard:  Object, Mappable {

    dynamic var cardId: String? = nil
    dynamic var index = 0
    
    dynamic var type = ""
    dynamic var section = ""
    dynamic var headerTitle: String? = nil
    dynamic var headerSubtitle: String? = nil
    dynamic var headerIconUri:String? = nil
    dynamic var message:String? = nil
    
    dynamic var actionLabel = ""
    dynamic var imageUri:String? = nil
    dynamic var tooltipTitle: String? = nil
    dynamic var tooltipContent: String? = nil
    
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
        headerTitle     <- map["header_title"]
        headerSubtitle  <- map["header_subtitle"]
        headerIconUri   <- map["header_icon"]
        message         <- map["message"]
        //actionLabel     <- map["action_label"]
        tooltipTitle    <- map["tooltip_title"]
        tooltipContent  <- map["tooltip_conent"]
        
    }

    
}

class TodoSocialPost: Object, Mappable {
    
    dynamic var postId:  String? = nil
    
    dynamic var todoCardId: String? = nil
    dynamic var todoCard: TodoCard? = nil
    dynamic var index = 0
    dynamic var isApproved = false
    
    dynamic var type = ""
    dynamic var status: String? = nil
    dynamic var statusDate: Date? = nil
    
    dynamic var articleCategory:String? = nil
    dynamic var articleTitle:String? = nil
    
    dynamic var articleText = ""
    dynamic var articleUrl = ""
    dynamic var articleHashtags = ""
    dynamic var articleImage:String? = nil
    
    
    override static func primaryKey() -> String? {
        return "postId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        todoCardId      <- map["todo_card_id"]
        postId          <- map["id"]
        index           <- map["index"]
        type            <- map["type"]
        status          <- map["status"]
        articleCategory <- map["article_category"]
        articleTitle    <- map["article_title"]
        articleText     <- map["article_text"]
        articleUrl      <- map["article_url"]
        articleHashtags <- map["article_hashtags"]
        articleImage    <- map["article_image"]
        
    }
    
    
    //TODO: check if can find another please to add these helpers
    var socialIcon: String {
        get {
            switch type {
            case TypeArticle.twitter.rawValue:
                return "icon_twitter"
            case TypeArticle.linkedin.rawValue:
                return "icon_google"
            default:
                return "icon_twitter"
            }
            
        }
    }
    
    var socialPost: String {
        get {
            switch type {
            case TypeArticle.twitter.rawValue:
                return "Twitter Post"
            case TypeArticle.linkedin.rawValue:
                return "Linkedin Post"
            default:
                return ""
            }
        }
    }
    
    var socialTextString: String {
        get {
            switch status! {
            case StatusArticle.scheduled.rawValue:
                return "Scheduled"
            case StatusArticle.failed.rawValue:
                return "Failed"
            case StatusArticle.executed.rawValue:
                return "Completed"
            case StatusArticle.unapproved.rawValue:
                return "Unapproved"
            default:
                return ""
            }
        }
    }
    
    var socialTextStringColor: UIColor {
        get {
            switch status! {
            case StatusArticle.scheduled.rawValue:
                return PopmetricsColor.blueMedium
            case StatusArticle.failed.rawValue:
                return PopmetricsColor.salmondColor
            case StatusArticle.executed.rawValue:
                return PopmetricsColor.greenSelectedDate
            default:
                return PopmetricsColor.blueMedium
            }
        }
    }
    
    var getSectionColor: UIColor {
        get {
            switch status! {
            case StatusArticle.scheduled.rawValue:
                return UIColor.darkGray
            case StatusArticle.failed.rawValue:
                return PopmetricsColor.salmondColor
            case StatusArticle.executed.rawValue:
                return PopmetricsColor.greenSelectedDate
            case StatusArticle.unapproved.rawValue:
                return PopmetricsColor.yellowUnapproved
            default:
                return UIColor.white
            }
        }
    }
    
    var socialURLColor: UIColor {
        get {
            return PopmetricsColor.blueURLColor
        }
    }
    
}
