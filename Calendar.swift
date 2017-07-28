//
//  Calendar.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 26/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit

class CalendarItem: NSObject{
    
    dynamic var index = 0
    
    dynamic var type = ""
    dynamic var status: String? = nil
    dynamic var statusDate: Date? = nil
    dynamic var articleCategory:String? = nil
    dynamic var articleTitle:String? = nil
    
    dynamic var articleText = ""
    dynamic var articleUrl = ""
    dynamic var articleHastags:String? = nil
    dynamic var articleImage:String? = nil
    
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
                return "Scheduled for"
            case StatusArticle.failed.rawValue:
                return "Failed"
            case StatusArticle.executed.rawValue:
                return "Executed"
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
                return PopmetricsColor.greenDark
            default:
                return PopmetricsColor.blueMedium
            }
        }
    }
    
    func tmp() {
        
    }

}


class CalendarSection: NSObject{

    
    dynamic var name = ""
    dynamic var status: String = "";
    dynamic var index = 0
    
    //let items = List<CalendarItem>()
    var items = [CalendarItem]()
    
}

enum TypeArticle: String {
    case twitter = "twitter_article"
    case linkedin = "linkedin_article"
}

enum StatusArticle: String {
    case scheduled = "scheduled"
    case failed = "failed"
    case executed = "executed"
    case inProgress = "in-progress"
}
