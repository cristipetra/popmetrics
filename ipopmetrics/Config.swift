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
    
    var apiHost: String {
        switch self {
        case .Staging: return "testapi.popmetrics.ai"
        case .Production: return "api.popmetrics.ai"
        }
    }
    
    
    var baseURL: String {
        switch self {
        case .Staging: return "https://testapi.popmetrics.ai"
        case .Production: return "https://api.popmetrics.io"
        }
    }
    
    var token: String {
        switch self {
        case .Staging: return "lktopir156dsq16sbi8"
        case .Production: return "5zdsegr16ipsbi1lktp"
        }
    }
    
}

class Config: NSObject {
    
    static let sharedInstance = Config()
    
    var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey:"Backend") as? String {
            
            if configuration.range(of:"staging") != nil {
                return Environment.Staging
            }
            if configuration.range(of:"production") != nil {
                return Environment.Production
            }
            
        }
        return Environment.Production
    }()
    
    
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
