//
//  Config.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 20/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class Config: NSObject {
    
    static let sharedInstance = Config();
    
    class var appWebLink: String {
        get {
            return "http://www.popmetrics.io"
        }
    }
    
    class var appWebAimeeLink: String {
        get {
            return "http://popmetrics.io/aimee"
        }
    }
    
    class var mailContact: String {
        get {
            return "concierge@popmetrics.io"
        }
    }
    
    class var socialAutomationLink: String {
        get {
            return "http://blog.popmetrics.io/how-to-automate-your-social-media/"
        }
    }
    

}
