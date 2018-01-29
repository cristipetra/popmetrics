//
//  DateExtensions.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 25/01/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//
import Foundation
import UIKit

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    var nextDay: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    func formatDateForSocial() -> String {
        
        let dateFormater = DateFormatter()
        var days: String = ""
        var hour: String = ""
        var fullDate: String = ""
        
        dateFormater.dateFormat = "MM/dd"
        dateFormater.pmSymbol = "p.m"
        days = dateFormater.string(from: self)
        
        dateFormater.dateFormat = "h:mm a"
        dateFormater.amSymbol = "a.m"
        hour = dateFormater.string(from: self)
        
        
        fullDate = "\(days) @ \(hour)"
        return fullDate
        
    }
    
}
