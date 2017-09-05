//
//  Todo.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift


class TodoCard:  Object {

    dynamic var cardId: String? = nil
    dynamic var index = 0
    
    dynamic var type = ""
    dynamic var section = ""
    dynamic var headerTitle: String? = nil
    dynamic var headerSubtitle: String? = nil
    dynamic var headerIconUri:String? = nil
    dynamic var message:String? = nil
    
    dynamic var actionHandler = ""
    dynamic var actionLabel = ""
    dynamic var imageUri:String? = nil
    dynamic var tooltipTitle: String? = nil
    dynamic var tooltipContent: String? = nil
    
}

class TodoSocialPost: Object {
    
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
    var articleHastags: [Any?] = []
    dynamic var articleImage:String? = nil
    
    
}


class TodoItem: CalendarItem {
    dynamic var isApproved = false
}

class TodoSection: NSObject{
    dynamic var name = ""
    dynamic var status: String = "";
    dynamic var index = 0
    
    var allApproved: Bool = false
    
    var items = [TodoItem]()
}

