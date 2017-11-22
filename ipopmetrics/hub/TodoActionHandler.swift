//
//  TodoActionHandler.swift
//  ipopmetrics
//
//  Created by Rares Pop on 06/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation

protocol TodoCardActionProtocol: class {
    func handleCardAction(_ action:String, todoCard: TodoCard, params:[String:Any])
}

protocol CalendarCardActionHandler: class {
    func handleCardAction(_ action: String, calendarCard: CalendarCard, params: [String:Any])
}

/*
class TodoCardActionHandler: TodoCardActionProtocol {
    func handleCardAction(_ action:String, todoCard: TodoCard, params:[String:Any]) {
        
    }
}
*/
