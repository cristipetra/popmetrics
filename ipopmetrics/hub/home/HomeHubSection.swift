//
//  HomeHubSection.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 27/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import Foundation


class HomeHubSection {
    
    let store = FeedStore()
    
    /*
     * api might returns cards in section that hasn't been yet implemented; or cards
     * has set wrong type.
     * used for 'insight' section
     */
    internal func getSectionCardsThatHasActiveCellView(_ section: String) -> [FeedCard] {
        let nonEmptyCards = store.getNonEmptyFeedCardsWithSection(section)
        var cardsWithView : [FeedCard] = []
        
        cardsWithView = nonEmptyCards.filter{ $0.type == HomeCardType.insight.rawValue || $0.type == HomeCardType.poptip.rawValue }

        return cardsWithView
    }
    
    
}
