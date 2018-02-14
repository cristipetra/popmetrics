//
//  IntercomTabBarItem.swift
//  Live
//
//  Created by Cristian Petra on 12/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import Intercom

class IntercomTabBarItem: UITabBarItem {
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUnreadCount(_:)), name: NSNotification.Name.IntercomUnreadConversationCountDidChange, object: nil)
        
    }
    
    @objc func updateUnreadCount(_ count: Int) {
        updateBadgeCount()
    }
    
    private func updateBadgeCount() {
        let count = Intercom.unreadConversationCount()
        
        if count < 1 {
            self.badgeValue = ""
            self.badgeColor = .clear
        } else  {
            self.badgeValue = ""
            self.badgeColor = PopmetricsColor.salmondColor
        }
    }

}
