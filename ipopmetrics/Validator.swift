//
//  Validator.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 20/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation


class Validator {
    static func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
