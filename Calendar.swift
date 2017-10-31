//
//  Calendar.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 26/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper


class CalendarCard:  Object, Mappable {
    
    @objc dynamic var cardId: String? = nil
    
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var updateDate: Date = Date()
    
    @objc dynamic var index = 0
    
    @objc dynamic var type = ""
    @objc dynamic var section = ""
    @objc dynamic var status = ""
    
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
            switch section {
            case StatusArticle.scheduled.rawValue:
                return "Scheduled Tweets"
            case StatusArticle.failed.rawValue:
                return "Failed"
            case StatusArticle.executed.rawValue:
                return "Completed"
            case StatusArticle.unapproved.rawValue:
                return "Unapproved"
            case StatusArticle.completed.rawValue:
                return "Completed"
            default:
                return ""
            }
        }
    }
    
    var socialTextStringColor: UIColor {
        get {
            switch status {
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
            switch section {
            case StatusArticle.scheduled.rawValue:
                return PopmetricsColor.blueURLColor
            case StatusArticle.failed.rawValue:
                return PopmetricsColor.salmondColor
            case StatusArticle.executed.rawValue:
                return PopmetricsColor.greenSelectedDate
            case StatusArticle.completed.rawValue:
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
    
    var getCardToolbarTitle: String {
        get {
            switch section {
            case StatusArticle.scheduled.rawValue:
                return ""
            case StatusArticle.executed.rawValue:
                return ""
            default:
                return "Scheduled Tweets"
            }
        }
    }
    
    var getCardSectionTitle: String {
        get {
            switch section{
            case StatusArticle.scheduled.rawValue:
                return "Scheduled Tweets"
            case StatusArticle.executed.rawValue:
                return "Completed Tweets"
            case StatusArticle.completed.rawValue:
                return "Completed Tweets"
            default:
                return "Scheduled"
            }
        }
    }
    

    
}

class CalendarSocialPost: Object, Mappable {
    
    @objc dynamic var postId:  String? = nil
    @objc dynamic var calendarCard: CalendarCard? = nil
    @objc dynamic var calendarCardId = ""
    
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var updateDate: Date = Date()

    
    @objc dynamic var index = 0
    @objc dynamic var isApproved = false
    
    @objc dynamic var scheduledDate: Date? = nil
    
    @objc dynamic var type = ""
    @objc dynamic var section = ""
    @objc dynamic var status = ""
    @objc dynamic var title:String? = nil
    
    @objc dynamic var text = ""
    @objc dynamic var url = ""
    @objc dynamic var hashtags = ""
    @objc dynamic var image:String? = nil
    @objc dynamic var articleSummary: String? = ""
    
    override static func primaryKey() -> String? {
        return "postId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
 
    func mapping(map: Map) {
        postId          <- map["id"]
        calendarCardId  <- map["calendar_card_id"]
        index           <- map["index"]
        type            <- map["type"]
        scheduledDate   <- (map["schedule_dt"], DateTransform())
        section         <- map["section"]
        status          <- map["status"]
        title           <- map["title"]
        text            <- map["text"]
        url             <- map["url"]
        hashtags        <- map["hashtags"]
        image           <- map["image"]
        
        createDate      <- (map["create_dt"], DateTransform())
        updateDate      <- (map["update_dt"], DateTransform())
        
    }
    
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
            switch status.capitalized {
            case StatusArticle.scheduled.rawValue:
                return "Scheduled "
            case StatusArticle.failed.rawValue:
                return "Failed"
            case StatusArticle.executed.rawValue:
                return "Completed"
            case StatusArticle.unapproved.rawValue:
                return "Scheduled"
            default:
                return ""
            }
            return status.capitalized
        }
    }
    
    var socialTextTime: String {
        get {
            switch status.capitalized {
            case StatusArticle.scheduled.rawValue:
                return "Scheduled "
            case StatusArticle.failed.rawValue:
                return "Failed"
            case StatusArticle.executed.rawValue:
                return "Completed"
            case StatusArticle.unapproved.rawValue:
                return "Scheduled for"
            default:
                return ""
            }
            return status.capitalized
        }
    }
    
    var socialTextStringColor: UIColor {
        get {
            switch status {
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
            switch status.capitalized {
            case StatusArticle.scheduled.rawValue:
                return PopmetricsColor.blueURLColor
            case StatusArticle.failed.rawValue:
                return PopmetricsColor.salmondColor
            case StatusArticle.executed.rawValue:
                return PopmetricsColor.greenSelectedDate
            case StatusArticle.unapproved.rawValue:
                return PopmetricsColor.blueURLColor
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


enum TypeArticle: String {
    case twitter = "twitter_article"
    case linkedin = "linkedin_article"
}

enum StatusArticle: String {
    case scheduled = "Scheduled"
    case failed = "Failed"
    case executed = "Executed"
    case manual = "Manual" 
    case unapproved = "Unapproved"
    case inProgress = "In-progress"
    case completed = "Completed"
}
