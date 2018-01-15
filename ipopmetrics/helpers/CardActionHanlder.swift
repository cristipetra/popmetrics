//
//  ActionHanlder.swift
//  ipopmetrics
//
//  Created by Rares Pop on 18/05/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit

protocol CardActionHandler {
    func handleRequiredAction(_ item: FeedCard )
}

@objc protocol CardInfoHandler {
    @objc func handleActionComplete()
}

protocol CardRecommendActionHandler: class {
    func handleRecommendAction(item: FeedCard)
}

