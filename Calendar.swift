//
//  Calendar.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 26/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation

class CalendarItem: NSObject{
    
    dynamic var index = 0
    
    dynamic var type = ""
    dynamic var status: String? = nil
    dynamic var statusDate: String? = nil
    dynamic var articleCategory:String? = nil
    dynamic var articleTitle:String? = nil
    
    dynamic var articleText = ""
    dynamic var articleUrl = ""
    dynamic var articleHastags:String? = nil
    dynamic var articleImage:String? = nil
}


class CalendarSection: NSObject{
    
    dynamic var name = ""
    dynamic var status: String = "";
    dynamic var index = 0
    
    //let items = List<CalendarItem>()
    var items = [CalendarItem]()
}
