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
        return realm.objects(TodoCard.self).sorted(byKeyPath: "index")
    }
    
    public func getNonEmptyTodoCardsWithSection(_ section: String) -> Results<TodoCard> {
        let predicate = NSPredicate(format: "section = %@ && type != %@", section, "empty_state")
        return realm.objects(TodoCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:true)
    }
    
    public func getEmptyTodoCardsWithSection(_ section: String) -> Results<TodoCard> {
        let predicate = NSPredicate(format: "section = %@ && type == %@", section, "empty_state")
        return realm.objects(TodoCard.self).filter(predicate).sorted(byKeyPath: "index", ascending:true)
    }
    
    public func getTodoCardWithId(_ cardId: String) -> TodoCard? {
        return realm.object(ofType: TodoCard.self, forPrimaryKey: cardId)
    }
    
    public func getTodoSocialPostWithId(_ postId: String) -> TodoSocialPost? {
        return realm.object(ofType: TodoSocialPost.self, forPrimaryKey: postId)
    }
    
    public func getTodoCardsWithSection(_ section: String) -> Results<TodoCard> {
        let predicate = NSPredicate(format: "section = %@", section)
        return realm.objects(TodoCard.self).filter(predicate)
    }
    
    public func getTodoSocialPostsForCard(_ todoCard: TodoCard) -> Results<TodoSocialPost> {
        let predicate = NSPredicate(format: "todoCard = %@", todoCard)
        return realm.objects(TodoSocialPost.self).filter(predicate)
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
        let predicate = NSPredicate(format: "name = %@", name)
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
    
    public func updateTodos(_ todoResponse: TodoResponse) {
        
        let realm = try! Realm()
        let cards = realm.objects(TodoCard.self).sorted(byKeyPath: "index")
        
        var cardsToDelete: [TodoCard] = []
        try! realm.write {
            for existingCard in cards {
                let (exists, newCard) = todoResponse.matchCard(existingCard.cardId!)
                if !exists {
                    cardsToDelete.append(existingCard)
                }
                else {
                    newCard?.cardId = existingCard.cardId!
                    realm.add(newCard!, update:true)
                }
                
            }
            
            for card in cardsToDelete {
                
                let socialPosts = self.getTodoSocialPostsForCard(card)
                for post in socialPosts {
                    realm.delete(post)
                }
                
                realm.delete(card)
            }
            
            for newCard in todoResponse.cards! {
                if let exCard = self.getTodoCardWithId(newCard.cardId!) {
                    if exCard.updateDate == newCard.updateDate {
                        continue
                    }
                }
                
                realm.add(newCard, update:true)
            }
            
        }//try
        
        let posts = realm.objects(TodoSocialPost.self)
        var postsToDelete: [TodoSocialPost] = []
        // update social postings
        try! realm.write {
            for existingPost in posts {
                let (exists, newPost) = todoResponse.matchSocialPost(existingPost.postId!)
                if !exists {
                    postsToDelete.append(existingPost)
                }
            }
            
            for post in postsToDelete {
                //TODO delete all related items first
                realm.delete(post)
            }
            
            for newPost in todoResponse.socialPosts! {
                
                if let exPost = self.getTodoSocialPostWithId(newPost.postId!) {
                    if exPost.updateDate == newPost.updateDate {
                        continue
                    }
                }
                
                newPost.todoCard = getTodoCardWithId(newPost.todoCardId!)
                realm.add(newPost, update:true)
            }
        }//try
        
    }
    
}
