//
//  MainTabInfo.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 09/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class MainTabInfo: NSObject {
    
    static var _instance = MainTabInfo()
    static func getInstance() -> MainTabInfo {
        return _instance
    }
    
    var currentItemIndex: Int = 0
    
    var lastItemIndex: Int = 0

}
