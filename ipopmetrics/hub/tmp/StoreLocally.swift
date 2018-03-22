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
    var feedStore: FeedStore = FeedStore()
    
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
    
    func createHomeCards() {
        try! feedStore.realm.write {
            let insightCard = FeedCard()
            insightCard.cardId = "sadfasfsadff"
            insightCard.section = HomeSectionType.insights.rawValue
            insightCard.status = "live"
            insightCard.type = HomeCardType.insight.rawValue
            insightCard.imageUri = "http://blog.popmetrics.io/wp-content/uploads/sites/13/2018/01/Pop-Tips-1-100.jpg"
            insightCard.recommendedAction = "fd.d"
            insightCard.actionLabel = "Learn more"
            
            insightCard.headerTitle = "We couldn't find your business' and going onto a lot of "
            insightCard.message = "Out of the first things customers will look for is your company's Facebook page. Having a facebook page will help you find new customers over the internet. Having a facebook page will help you find new customers over the internet."

            
            feedStore.realm.add(insightCard, update: true)
            
            
            let popTipCard = FeedCard()
            popTipCard.cardId = "sadfasfsafdsadff"
            popTipCard.section = HomeSectionType.insights.rawValue
            popTipCard.status = "live"
            popTipCard.type = HomeCardType.poptip.rawValue
            
            popTipCard.headerTitle = "Business Budgeting 101"
            popTipCard.message = "Learn the fundamentals of tracking, planning and preparing your budget."
            popTipCard.imageUri = "http://blog.popmetrics.io/wp-content/uploads/sites/13/2018/01/Pop-Tips-1-100.jpg"
            popTipCard.actionLabel = "Learn more"
            
            feedStore.realm.add(popTipCard, update: true)
        }

    }
    
}
