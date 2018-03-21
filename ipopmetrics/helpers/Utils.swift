//
//  Utils.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 12/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class Utils {
    static var isIphoneX: Bool {
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            return true
        }
        return false
    }
    
    static var isPlusSize: Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeScale == 3 {
                if !Utils.isIphoneX {
                    return true
                }
            }
        }
        return false
    }
}
