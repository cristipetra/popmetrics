//
//  Config.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 20/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

enum Environment: String {
    case Staging = "staging"
    case Production = "production"
    
    var baseURL: String {
        switch self {
        case .Staging: return "https://staging-api.myservice.com"
        case .Production: return "https://api.myservice.com"
        }
    }
    
    var token: String {
        switch self {
        case .Staging: return "lktopir156dsq16sbi8"
        case .Production: return "5zdsegr16ipsbi1lktp"
        }
    }
    
}

struct Configuration {
    lazy var environment: Environment = {
        if let configuration = NSBundle.mainBundle().objectForInfoDictionaryKey("Backend") as? String {
            if configuration.rangeOfString("staging") != nil {
                return Environment.Staging
            }
            if configuration.rangeOfString("production") != nil {
                return Environment.Production
            }
            
        }
        return Environment.Production
    }()
}



class Config: NSObject {
    
    static let sharedInstance = Config();
    
    class var appWebLink: String {
        get {
            return "http://www.popmetrics.io"
        }
    }
    
    class var aboutWebLink: String {
        get {
            return "Popmetrics.ai"
        }
    }
    
    class var appWebAimeeLink: String {
        get {
            return CHAT_URL
        }
    }
    
    class var mailContact: String {
        get {
            return "concierge@popmetrics.ai"
        }
    }
    
    class var mailSettings: String {
        get {
            return "help@popmetrics.ai"
        }
    }
    
    class var socialAutomationLink: String {
        get {
            return "http://blog.popmetrics.io/how-to-automate-your-social-media/"
        }
    }
    
    class var howToTurnNotificationLink: String {
        get {
            return "http://blog.popmetrics.io/how-to-turn-on-push-notifications/"
        }
    }
    
    class var aboutPopmetricsLink: String {
        get {
            return "http://popmetrics.io/c1/about-popmetrics/"
        }
    }
    
    class var legalBitsLink: String {
        get {
            return "http://popmetrics.io/legal-bits/"
        }
    }
    

}
