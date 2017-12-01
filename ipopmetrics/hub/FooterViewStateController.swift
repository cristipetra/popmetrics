//
//  FooterViewStateController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class FooterViewStateController: NSObject {
    
    var footerView: FooterView!
    
    func configureCard(item: FeedCard, view: FooterView) {
        footerView = view
        view.displayOnlyActionButton()
        view.cardType = .required
        
        
        changetActionButton(item)
    }
    
    private func changetActionButton(_ item: FeedCard) {
        footerView.actionButton.changeTitle(item.actionLabel)
        
    }
    
}
