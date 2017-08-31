//
//  Todo.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit

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

