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
    
    func  handleRequiredAction(_ sender : SimpleButton, item: FeedCard)
}

protocol CardInfoHandler {
    func handleInfoAction( _ sender: SimpleButton, item: FeedCard)
}

protocol CardRecommendActionHandler: class {
    func handleRecommendAction(item: FeedCard)
}

