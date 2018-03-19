//
//  StoreLocally.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import Foundation

struct StoreLocally {
    
    var todoStore: TodoStore = TodoStore()
    
    func createTodoLocally() {
        try! todoStore.realm.write {
            let socialCard = TodoCard()
            socialCard.cardId = "234234safdfd"
            socialCard.name = "social.control_articles"
            todoStore.realm.add(socialCard, update: true)
            
            let twitterPost1 = TodoSocialPost()
            twitterPost1.todoCard = socialCard
            twitterPost1.todoCardId = socialCard.cardId
            twitterPost1.type = "twitter"
            todoStore.realm.add(twitterPost1, update: true)
            
            
            //my card
            let myActionCard = TodoCard()
            myActionCard.cardId = "fsadfsadf2radf"
            myActionCard.status = "live"
            myActionCard.type = TodoCardType.myAction.rawValue
            myActionCard.section = TodoSectionType.myActions.rawValue
            //myActionCard.headerTitle = "Hello my card"
            myActionCard.imageUri = "http://blog.popmetrics.io/wp-content/uploads/sites/13/2017/12/emptystate_emptystate-02.png"
            
            todoStore.realm.add(myActionCard, update: true)
        }
    }
    
}
