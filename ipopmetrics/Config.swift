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
            return "http://chat.popmetrics.io/#/aimee/start/58fe437ac7631a139803757e/59525092c7631a102e88b9ea"
        }
    }
    
    class var mailContact: String {
        get {
            return "concierge@popmetrics.io"
        }
    }
    

}
