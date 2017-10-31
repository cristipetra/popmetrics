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
    @objc dynamic var imageUri:String? = nil
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
        
        createDate      <- (map["create_dt"], DateTransform())
        updateDate      <- (map["update_dt"], DateTransform())
        
    }

    
    var getSectionColor: UIColor {
        get {
            switch section {
            case StatusArticle.scheduled.rawValue:
                return UIColor.darkGray
            case StatusArticle.failed.rawValue:
                return PopmetricsColor.salmondColor
            case StatusArticle.executed.rawValue:
                return PopmetricsColor.greenSelectedDate
            case StatusArticle.unapproved.rawValue:
                return PopmetricsColor.darkGrey
            case StatusArticle.manual.rawValue:
                return PopmetricsColor.purpleToDo
            default:
                return UIColor.white
            }
        }
    }
    
    var getCardToolbarTitle: String {
        get {
            switch section {
            case StatusArticle.unapproved.rawValue:
                return ""
            default:
                return "Recommended Action"
            }
        }
    }
    
    var getCardSectionTitle: String {
        get {
            switch section {
            case StatusArticle.unapproved.rawValue:
                return "Posts for Your Approval"
            case StatusArticle.manual.rawValue:
                return "Doing Yourself"
            case StatusArticle.failed.rawValue:
                return "Failed Actions"
            default:
                return "Recommended Action"
            }
        }
    }
}

class TodoSocialPost: Object, Mappable {
    
    @objc dynamic var postId:  String? = nil
    
    @objc dynamic var todoCardId: String? = nil
    @objc dynamic var todoCard: TodoCard? = nil

    @objc dynamic var createDate: Date = Date()
    @objc dynamic var updateDate: Date = Date()
    
    @objc dynamic var index = 0
    @objc dynamic var isApproved = false
    
    @objc dynamic var type = ""
    @objc dynamic var status: String? = nil
    
    @objc dynamic var articleCategory:String? = nil
    @objc dynamic var articleTitle:String? = nil
    
    @objc dynamic var articleText = ""
    @objc dynamic var articleUrl = ""
    @objc dynamic var articleHashtags = ""
    @objc dynamic var articleImage:String? = nil
    @objc dynamic var articleSummary: String? = nil
    
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
        articleSummary  <- map["article_summary"]
        
        createDate      <- (map["create_dt"], DateTransform())
        updateDate      <- (map["update_dt"], DateTransform())
        
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
                return PopmetricsColor.yellowUnapproved
            }
        }
    }
    
    var getCardToolbarTitle: String {
        get {
            switch (status?.lowercased())! {
            case StatusArticle.unapproved.rawValue:
                return ""
            default:
                return "Recommended Action"
            }
        }
    }
    
    var socialURLColor: UIColor {
        get {
            return PopmetricsColor.blueURLColor
        }
    }
    
}
