//
//  HomzenColor.swift
//  Popmetrics
//
//  Created by Rares Pop
//  Copyright © 2016 Popmetrics. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green: CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha: CGFloat(255 * alpha) / 255)
    }
}

class PopmetricsColor {
    
    static let textLight = UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
    static let textMedium = UIColor(red: 160/255.0, green: 160/255.0, blue: 160/255.0, alpha: 1.0)
    static let textDark = UIColor(red: 36/255.0, green: 36/255.0, blue: 36/255.0, alpha: 1.0)
    
    static let shadowLight = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 0.8)
    static let shadowMedium = UIColor(red: 144/255.0, green: 144/255.0, blue: 144/255.0, alpha: 0.8)
    static let shadowDark = UIColor(red: 22/255.0, green: 22/255.0, blue: 22/255.0, alpha: 0.8)
    
    static let borderLight = PopmetricsColor.textLight
    static let borderMedium = PopmetricsColor.textMedium
    static let borderDark = PopmetricsColor.textDark
    
    static let orange = UIColor(red: 227/255.0, green: 135/255.0, blue: 58/255.0, alpha: 1.0)
    
    static let greenLight = UIColor(red: 176/255.0, green: 247/255.0, blue: 222/255.0, alpha: 1.0)
    static let greenMedium = UIColor(red: 73/255.0, green: 196/255.0, blue: 153/255.0, alpha: 1.0)
    static let greenDark = UIColor(red: 0/255.0, green: 127/255.0, blue: 120/255.0, alpha: 1.0)
    
    static let transparentGrayDark = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 0.7)
    
    static let grayMedium = UIColor(red: 194/255.0, green: 194/255.0, blue: 194/255.0, alpha: 1.0)
    static let blueMedium = UIColor(red: 100/255.0, green: 159/255.0, blue: 237/255.0, alpha: 1.0)
    static let redMedium = UIColor(red: 224/255.0, green: 114/255.0, blue: 114/255.0, alpha: 1.0)
    
    static let overlayBGColor = UIColor(red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 0.5)
    
    static let notificationBGColor = UIColor(red: 179/255, green: 50/255, blue: 39/255, alpha: 1.0)
    
    static let yellowBGColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1.0)
    static let salmondColor = UIColor(red: 255/255, green: 119/255, blue: 106/255, alpha: 1.0)
}
