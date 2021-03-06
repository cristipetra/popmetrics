//
//  EmailMessages.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation

enum EmailMessageType {
    case name
    case brand
    case phone
    case webAddress
    case overlayAction
    case deleteAccount
    case contact
}

class EmailMessages: NSObject {
    
    static func getInstance() -> EmailMessages {
        return EmailMessages()
    }
    
    func getEmailMessages(emailMessageType: EmailMessageType) -> EmailInfo{
        var emailInfo: EmailInfo = EmailInfo()
        switch emailMessageType {
        case .name:
            emailInfo.subject = "Change my Name"
            emailInfo.messageBody = "I'd like to change the Name on my account to: [Insert your new Name]"
        case .brand:
            emailInfo.subject = "Change My Brand Name"
            emailInfo.messageBody = "I'd like to change the Brand Name on my account to: [Insert your new Brand Name]"
        case .phone:
            emailInfo.subject = "I'd like to change my Cell Phone Number"
            emailInfo.messageBody  = "Hi Aimee,\n \nHey, I’d like to change my Cell Phone Number that I log in to my account to the following number: [insert number]"
        case .webAddress:
            emailInfo.subject = "Change my Primary Web Address"
            emailInfo.messageBody = "Hi Aimee,\n \nI’d like to change the Primary Website to the following: [insert new URL]"
        case .overlayAction:
            emailInfo.subject = "Suggestion for an Overlay Call To Action (CTA)"
            emailInfo.messageBody = "Hi Aimee,\n \nI have a suggestion for a new CTA. What about having: [Inser CTA suggestion]"
        case .deleteAccount:
            emailInfo.subject = "Request account deletion"
            emailInfo.messageBody = "Hi Aimee,\n \nI'd like to delete my account for the following reason: [describe why you'd like to delete your account]"
        case .contact:
            emailInfo.subject = ""
            emailInfo.messageBody = ""
        default:
            break
        }
        return emailInfo
    }
    
}

struct EmailInfo {
    var subject: String? = ""
    var messageBody: String? = ""
}
