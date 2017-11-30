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
}

class EmailMessages: NSObject {
    
    static func getInstance() -> EmailMessages {
        return EmailMessages()
    }
    
    func getEmailMessages(emailMessageType: EmailMessageType) -> EmailInfo{

        switch emailMessageType {
        case .name:
            var emailInfo: EmailInfo = EmailInfo()
            emailInfo.subject = "Change my Name"
            emailInfo.messageBody = "I'd like to change the Name on my account to: [Insert your new Name]"
            return emailInfo
        case .brand:
            var emailInfo: EmailInfo = EmailInfo()
            emailInfo.subject = "Change My Brand Name"
            emailInfo.messageBody = "I'd like to change the Brand Name on my account to: [Insert your new Brand Name]"
            return emailInfo
        case .phone:
            var emailInfo: EmailInfo = EmailInfo()
            emailInfo.subject = "I'd like to change my Cell Phone Number"
            emailInfo.messageBody  = "Hi Aimee,\n \nHey, I’d like to change my Cell Phone Number that I log in to my account to the following number: [insert number]"
            return emailInfo
        default:
            return EmailInfo()
            break
        }
    }
    
}

struct EmailInfo {
    var subject: String? = ""
    var messageBody: String? = ""
}
