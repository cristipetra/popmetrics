//
//  TodoStore.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation

class TodoStore {
    
    static func getInstance() -> TodoStore {
        return TodoStore()
    }
    
    var sections:[TodoSection] = []
    
    public func getFeed() -> [TodoSection] {
        return sections
    }
    
    public func storeItem(item: TodoItem) {
        if !existSection(item) {
            var section: TodoSection = TodoSection()
            section.status = item.status!
            section.items.append(item)
            sections.append(section)
        }
        
    }
    
    internal func existSection(_ item: TodoItem) -> Bool {
        for section in sections{
            if(section.status ==  item.status) {
                print("fouund")
                section.items.append(item)
                return true
            }
        }
        return false
    }
    
}
