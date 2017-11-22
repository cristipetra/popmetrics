//
//  TextFieldValidator.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

// MARK: - Constants
private let FONT = UIFont.systemFont(ofSize: 18.0)
private let TITLE_FONT = UIFont.systemFont(ofSize: 10.0)
private let TEXT_COLOR = PopmetricsColor.textDark
private let LINE_COLOR = PopmetricsColor.textMedium
private let OVERCAST_COLOR = PopmetricsColor.textMedium
private let ERROR_COLOR = UIColor.red

struct TextValidatorValidation {
    var message: String
    var regex: String
}

class TextFieldValidator: UITextField {
    
    var validations = [TextValidatorValidation]()
    var errorMessage: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupField()
    }
    
    fileprivate func setupField() {
        tintColor = LINE_COLOR
        textColor = TEXT_COLOR
        font = FONT
    }
    
    func addValidations(_ validations: [TextValidatorValidation]) {
        self.validations += validations
    }
    
    func validate() -> Bool {
        return true
        //        for validation in validations {
        //            let test = NSPredicate(format: "SELF MATCHES %@", validation.regex)
        //            if !test.evaluate(with: text) {
        //                errorMessage = validation.message
        //                return false
        //            }
        //        }
        //        errorMessage = nil
        //        return true
    }
}
