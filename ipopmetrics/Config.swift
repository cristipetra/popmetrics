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
    case Localdev = "localdev"
    
    var apiHost: String {
        switch self {
        case .Staging: return "testapi.popmetrics.ai"
        case .Production: return "api.popmetrics.ai"
        case .Localdev: return "localdev.popmetrics.ai"
        }
    }
    
    
    var baseURL: String {
        switch self {
        case .Staging: return "https://testapi.popmetrics.ai"
        case .Production: return "https://api.popmetrics.io"
        case .Localdev: return "http://localdev.popmetrics.ai:5030"
        }
    }
    
    var token: String {
        switch self {
        case .Staging: return "lktopir156dsq16sbi8"
        case .Production: return "5zdsegr16ipsbi1lktp"
        case .Localdev: return "lktopir156dsq16sbi8"
        }
    }
    
    var intercomAppKey: String {
        switch self {
        case .Staging: return "ios_sdk-b07a4fa44e59e0914ce414c278c284e2b18e6caa"
        case .Production: return "ios_sdk-56bb7df2b3d88934f7d564b7a353c66b68b54f12"
        case .Localdev: return "ios_sdk-b07a4fa44e59e0914ce414c278c284e2b18e6caa"
        }
    }
    
    var intercomAppId: String {
        switch self {
        case .Staging: return "w4ce6nmv"
        case .Production: return "f2713n8d"
        case .Localdev: return "w4ce6nmv"
        }
    }
    
    var googleClientIdIos: String {
        return "850179116799-12c7gg09ar5eo61tvkhv21iisr721fqm.apps.googleusercontent.com"
    }
    
    var googleClientIdWeb: String {
        return "850179116799-024u4fn5ddmkm3dnius3fq3l1gs81toi.apps.googleusercontent.com"
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
            if configuration.range(of:"localdev") != nil {
                return Environment.Localdev
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
