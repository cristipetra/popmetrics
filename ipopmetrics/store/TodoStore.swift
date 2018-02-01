//
//  TodoStore.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift

class TodoStore {
    
    static func getInstance() -> TodoStore {
        return TodoStore()
    }
    
    public let realm = try! Realm()
    
    
    public func getTodoCards() -> Results<TodoCard> {
        let predicate = NSPredicate(format: "status !='archived'")
        return realm.objects(TodoCard.self).filter(predicate).sorted(byKeyPath: "index", ascending: false)
    }
    
    public func getNonEmptyTodoCardsWithSection(_ section: String) -> Results<TodoCard> {
        let predicate = NSPredicate(format: "section = %@ && type != %@ && status != 'archived'", section, "empty_state")
        return realm.objects(TodoCard.self).filter(predicate).sorted(byKeyPath: "index", ascending: false)
    }
    
    public func getEmptyTodoCardsWithSection(_ section: String) -> Results<TodoCard> {
        let predicate = NSPredicate(format: "section = %@ && type == %@ && status != 'archived'", section, "empty_state")
        return realm.objects(TodoCard.self).filter(predicate).sorted(byKeyPath: "index", ascending: false)
    }
    
    public func getTodoCardWithId(_ cardId: String) -> TodoCard? {
        return realm.object(ofType: TodoCard.self, forPrimaryKey: cardId)
    }
    
    public func getTodoSocialPostWithId(_ postId: String) -> TodoSocialPost? {
        return realm.object(ofType: TodoSocialPost.self, forPrimaryKey: postId)
    }
    
    public func getTodoCardsWithSection(_ section: String) -> Results<TodoCard> {
        let predicate = NSPredicate(format: "section = %@ && status !='archived'", section)
        return realm.objects(TodoCard.self).filter(predicate)
    }
    
    public func getTodoSocialPostsForCard(_ todoCard: TodoCard) -> Results<TodoSocialPost> {
        let predicate = NSPredicate(format: "todoCard = %@ && status != 'archived'", todoCard)
        return realm.objects(TodoSocialPost.self).filter(predicate).sorted(byKeyPath: "index", ascending: false)
    }
    
    public func removeTodoSocialPost(_ todoSocialPost: TodoSocialPost) -> Void {
        try! realm.write {
            realm.delete(todoSocialPost)
        }
    }
    
    public func addTodoCard(_ todoCard: TodoCard) {
        try! realm.write {
            realm.add(todoCard, update:true)
        }
    }

    public func getTodoCardWithName(_ name: String) -> TodoCard? {
        let predicate = NSPredicate(format: "name = %@ && status != 'archived' ", name)
        let rset = realm.objects(TodoCard.self).filter(predicate)
        if rset.count > 0 {
            return rset[0]
        }
        else {
            return nil
        }
    }
   
    
    public func countSections() -> Int {
        let distinctTypes = Array(Set(self.getTodoCards().value(forKey: "section") as! [String]))
        return distinctTypes.count
    }
    
    public func getLastSocialPostUpdateDate() -> Date {
        let result = realm.objects(TodoSocialPost.self).sorted(byKeyPath: "updateDate", ascending:false)
        if result.count > 0 {
            return result[0].updateDate
        }
        else {
            return Date(timeIntervalSince1970: 0)
        }
    }
    
    public func getLastCardUpdateDate() -> Date {
        let result = realm.objects(TodoCard.self).sorted(byKeyPath: "updateDate", ascending:false)
        if result.count > 0 {
            return result[0].updateDate
        }
        else {
            return Date(timeIntervalSince1970: 0)
        }
    }
    
    public func wipe() {
        let realm = try! Realm()
        let allCards = realm.objects(TodoCard.self)
        let allPosts = realm.objects(TodoSocialPost.self)
        
        try! realm.write {
            realm.delete(allCards)
            realm.delete(allPosts)
        }
    }
    
    
    public func updateTodos(_ todoResponse: TodoResponse) {
        
        let realm = try! Realm()
        try! realm.write {
            for newCard in todoResponse.cards! {
                realm.add(newCard, update:true)
            }
            
            for newPost in todoResponse.socialPosts! {
                newPost.todoCard = getTodoCardWithId(newPost.todoCardId!)
                realm.add(newPost, update:true)
            }
        }//try
        
    }
    
}
