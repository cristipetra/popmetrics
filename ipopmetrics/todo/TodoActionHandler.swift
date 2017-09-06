//
//  TodoActionHandler.swift
//  ipopmetrics
//
//  Created by Rares Pop on 06/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation

protocol TodoCardActionHandler: class {
    
    func handleCardAction(_ action:String, todoCard: TodoCard, params:[String:Any])

}
