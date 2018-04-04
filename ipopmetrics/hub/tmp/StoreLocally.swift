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
    var calendarStore: CalendarStore = CalendarStore()
    
    
    func createCalendarLocally() {
        try! calendarStore.realm.write {
            let socialCard = CalendarCard()
            socialCard.cardId = "234asfaf234safdfd"
            socialCard.section = CalendarSection.Scheduled.rawValue
            socialCard.status = "live"
            socialCard.type = "scheduled_social_posts"
            calendarStore.realm.add(socialCard, update: true)
            
            let twitterPost1 = CalendarSocialPost()
            twitterPost1.postId = "fsafas241"
            twitterPost1.calendarCard = socialCard
            twitterPost1.calendarCardId = socialCard.cardId!
            twitterPost1.section = CalendarSection.Scheduled.rawValue
            twitterPost1.status = "live"
            twitterPost1.type = "twitter"
            twitterPost1.message = "Post something on twitter"
            twitterPost1.socialAccount = "@john.doe"
            twitterPost1.scheduledDate = Date()
            calendarStore.realm.add(twitterPost1, update: true)
            
            let facebookPost1 = CalendarSocialPost()
            facebookPost1.postId = "fsafas2asfa41"
            facebookPost1.calendarCard = socialCard
            facebookPost1.calendarCardId = socialCard.cardId!
            facebookPost1.section = CalendarSection.Scheduled.rawValue
            facebookPost1.status = "live"
            facebookPost1.type = "facebook"
            facebookPost1.message = "We have cookies"
            facebookPost1.socialAccount = "John Doe Desing"
            facebookPost1.scheduledDate = Date()
            calendarStore.realm.add(facebookPost1, update: true)
   
        }
    }
    
    func createTodoLocally() {
        try! todoStore.realm.write {
            let socialCard = TodoCard()
            socialCard.cardId = "234234safdfd"
            socialCard.name = "social.control_articles"
            todoStore.realm.add(socialCard, update: true)
            
            let twitterPost1 = TodoSocialPost()
            twitterPost1.postId = "fsafas241"
            twitterPost1.todoCard = socialCard
            twitterPost1.todoCardId = socialCard.cardId
            twitterPost1.type = "twitter"
            twitterPost1.message = "Post something on twitter"
            twitterPost1.socialAccount = "@john.doe"
            todoStore.realm.add(twitterPost1, update: true)
            
            let facebookPost1 = TodoSocialPost()
            facebookPost1.postId = "fsafdasfas241"
            facebookPost1.todoCard = socialCard
            facebookPost1.todoCardId = socialCard.cardId
            facebookPost1.type = "facebook"
            facebookPost1.message = "Post something on facebook..."
            facebookPost1.socialAccount = "Joe Doe desings"
            todoStore.realm.add(facebookPost1, update: true)
            
            
            //my card
            let myActionCard = TodoCard()
            myActionCard.cardId = "fsadfsadf2radf"
            myActionCard.status = "live"
            myActionCard.type = TodoCardType.myAction.rawValue
            myActionCard.section = TodoSectionType.myActions.rawValue
            //myActionCard.headerTitle = "Hello my card"
            myActionCard.imageUri = "http://blog.popmetrics.io/wp-content/uploads/sites/13/2017/12/emptystate_emptystate-02.png"
            
            todoStore.realm.add(myActionCard, update: true)
            
            
            let facebookPayment = TodoCard()
            facebookPayment.cardId = "dfafsadf0sd9fdasf"
            facebookPayment.name = "facebook.payment.tmp"
            facebookPayment.headerTitle = "Create A Facebook Page For Your Business."
            facebookPayment.status = "live"
            facebookPayment.type = TodoCardType.myAction.rawValue
            facebookPayment.section = TodoSectionType.myActions.rawValue
            facebookPayment.imageUri = "http://blog.popmetrics.io/wp-content/uploads/sites/13/2017/12/emptystate_emptystate-02.png"
            facebookPayment.actionLabel = "Take Action"
            todoStore.realm.add(facebookPayment, update: true)
        }
    }
    
    
}
