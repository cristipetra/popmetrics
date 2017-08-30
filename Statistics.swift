//
//  Statistics.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 29/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import Foundation
import UIKit

class StatisticsItem: CalendarItem {
}

class StatisticsSection: NSObject{
    dynamic var name = ""
    dynamic var status: String = "";
    dynamic var index = 0
    
    var items = [StatisticsItem]()
}
