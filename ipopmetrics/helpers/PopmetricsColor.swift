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
    static let textGrey = UIColor(red: 67/255.0, green: 76/255.0, blue: 84/255.0, alpha: 1.0)
    static let weekDaysGrey = UIColor(red: 189/255.0, green: 197/255.0, blue: 203/255.0, alpha: 1.0)
    static let darkGrey = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1.0)
    static let shadowLight = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 0.8)
    static let shadowMedium = UIColor(red: 144/255.0, green: 144/255.0, blue: 144/255.0, alpha: 0.8)
    static let shadowDark = UIColor(red: 22/255.0, green: 22/255.0, blue: 22/255.0, alpha: 0.8)
    static let purpleToDo = UIColor(red: 177/255, green: 154/255, blue: 219/255, alpha: 1.0)
    static let trafficEmptyApproveLbl = UIColor(red: 255/255, green: 132/255, blue: 171/255, alpha: 1.0)
    static let trafficHeaderColor = UIColor(red: 255/255, green: 32/255, blue: 128/255, alpha: 1.0)
    static let statisticsGradientStartColor = UIColor(red: 255/255, green: 34/255, blue: 105/255, alpha: 1.0)
    static let statisticsGradientEndColor = UIColor(red: 255/255, green: 41/255, blue: 138/255, alpha: 1.0)
    static let calendarCompleteGreen = UIColor(red: 124/255, green: 202/255, blue: 176/255, alpha: 1.0)
    static let borderLight = PopmetricsColor.textLight
    static let borderMedium = PopmetricsColor.textMedium
    static let borderDark = PopmetricsColor.textDark
    static let statisticsTableBackground = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    static let dividerBorder = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
    static let orange = UIColor(red: 227/255.0, green: 135/255.0, blue: 58/255.0, alpha: 1.0)
    static let bannerSuccessText = UIColor(red: 13/255, green: 88/255, blue: 63/255, alpha: 1.0)
    
    static let todoBrown = UIColor(red: 166/255, green: 135/255, blue: 28/255, alpha: 1)
    static let greenLight = UIColor(red: 176/255.0, green: 247/255.0, blue: 222/255.0, alpha: 1.0)
    static let greenMedium = UIColor(red: 73/255.0, green: 196/255.0, blue: 153/255.0, alpha: 1.0)
    static let greenDark = UIColor(red: 0/255.0, green: 127/255.0, blue: 120/255.0, alpha: 1.0)
    static let greenSelectedDate = UIColor(red: 68/255.0, green: 180/255.0, blue: 142/255.0, alpha: 1.0)
    static let greenBtn = UIColor(red: 54/255.0, green: 172/255.0, blue: 130/255.0, alpha: 1.0)
    
    static let todoTopColor = UIColor(red: 250.255, green: 189/255, blue: 63/255, alpha: 1)
    static let todoBottomColor = UIColor(red: 252/255, green: 205/255, blue: 87/255, alpha: 1)
    
    static let transparentGrayDark = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 0.7)
    
    static let grayMedium = UIColor(red: 194/255.0, green: 194/255.0, blue: 194/255.0, alpha: 1.0)
    static let blueMedium = UIColor(red: 100/255.0, green: 159/255.0, blue: 237/255.0, alpha: 1.0)
    static let redMedium = UIColor(red: 224/255.0, green: 114/255.0, blue: 114/255.0, alpha: 1.0)
    
    static let onboardingButtonDisabled = UIColor(red: 255/255, green: 210/255, blue: 55/255, alpha: 1.0)
    static let onboardingButtonTextDisabled = UIColor(red: 228/255, green: 185/255, blue: 39/255, alpha: 1.0)
    static let overlayBGColor = UIColor(red: 20/255.0, green: 20/255.0, blue: 20/255.0, alpha: 0.5)
    
    static let notificationBGColor = UIColor(red: 179/255, green: 50/255, blue: 39/255, alpha: 1.0)
    
    static let yellowBGColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1.0)
    static let salmondColor = UIColor(red: 255/255, green: 119/255, blue: 106/255, alpha: 1.0)
    
    static let blueURLColor = UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1.0)
    
    static let yellowUnapproved = UIColor(red: 255/255, green: 189/255, blue: 80/255, alpha: 1.0)
    
    static let separatorColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
    static let unselectedTabBarItemTint = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1.0)
    
    static let visitFirstColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1)
    static let visitSecondColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
    
    static let topButtonColor = UIColor(red: 252/255, green: 221/255, blue: 105/255, alpha: 1)
    static let bottomButtonColor = UIColor(red: 251/255, green: 192/255, blue: 46/255, alpha: 1)
    static let salmondBottomColor = UIColor(red: 246/255, green: 101/255, blue: 87/255, alpha: 1)
    
    static let tableBackground = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    static let textGraySettings = UIColor(red: 109/255, green: 109/255, blue: 114/255, alpha: 1)
    
    static let barBackground = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    
    static let myActionCircle = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)
    
    static let secondGray = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
    
    static let borderButton = UIColor(red: 64/255, green: 60/255, blue: 59/255, alpha: 1)
    
    static let phoneNumberField = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    static let buttonTitle = #colorLiteral(red: 0.262745098, green: 0.2980392157, blue: 0.3294117647, alpha: 1)
}
