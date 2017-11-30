//
//  StringExtensions.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 29/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isValidUrl() -> Bool {
        let value: String? = self
        guard let urlString = value,
            let url = URL(string: urlString) else {
                return false
        }
    
        return UIApplication.shared.canOpenURL(url)
    }
}
