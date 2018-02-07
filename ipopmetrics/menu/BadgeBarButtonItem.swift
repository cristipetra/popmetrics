//
//  BadgeBarButtonItem.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import Intercom

class BadgeBarButtonItem: UIBarButtonItem {
    
    internal func addBadgeObservers() {
        let nc = NotificationCenter.default
        
        nc.addObserver(self,
                       selector: #selector(handlerUpdateCountDidChange(_:)),
                       name: NSNotification.Name.IntercomUnreadConversationCountDidChange,
                       object: nil)
    }
    
    @objc func handlerUpdateCountDidChange(_ value: Any) {
        updateBadge()
    }
    
    internal func updateBadge() {
        let count = Intercom.unreadConversationCount()
        if count < 1 {
            self.removeBadge()
        } else {
            self.addCircleBadge(withOffset: CGPoint.init(x: 5, y: 10), andColor: PopmetricsColor.salmondColor, andFilled: true)
        }
    }
    
    internal func addTmpBadge() {
        self.addCircleBadge(withOffset: CGPoint.init(x: 5, y: 10), andColor: PopmetricsColor.salmondColor, andFilled: true)
    }

}
