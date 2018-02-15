//
//  BusinessContact.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import Foundation
import ObjectMapper

class BusinessContact: Mappable {
    
    var phone: String = ""
    var fax: String = ""
    var businessEmail: String = ""
    var address: String = ""
    var unit: String = ""
    var city: String = ""
    var state: String = ""
    var zipCode: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        phone          <- map["phone"]
        fax            <- map["fax"]
        businessEmail  <- map["business_email"]
        address        <- map["address"]
        unit           <- map["unit"]
        city           <- map["city"]
        state          <- map["state"]
        zipCode        <- map["zip_code"]
    }
    
    
}
