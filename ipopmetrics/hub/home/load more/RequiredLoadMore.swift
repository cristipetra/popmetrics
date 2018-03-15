//
//  RequiredLoadMore.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import Foundation


protocol RequiredActionLoadMore {
    func loadMoreRequiredCard()
}

class RequiredLoadMore {
    private var maxNoRequiredMore = 2
    var countCards: Int = 1 {
        didSet {
            updateIsVisibleRequiredLoadMore()
        }
    }
    
    internal var isVisibleRequiredLoadMore: Bool = false
    
    private var didCardsLoaded = false
    
    func getCountCards(countCardsSection: Int) -> Int {
        self.countCards = countCardsSection
        
        if didCardsLoaded {
            return countCards
        }
        return countCards <= maxNoRequiredMore ? countCardsSection : maxNoRequiredMore
    }
    
    internal func loadAllRequiredCards() {
        didCardsLoaded = true
    }
    
    private func updateIsVisibleRequiredLoadMore() {
        if didCardsLoaded {
            isVisibleRequiredLoadMore = false
            return
        }
        
        if countCards <= maxNoRequiredMore{
            isVisibleRequiredLoadMore = false
        } else {
            isVisibleRequiredLoadMore = true
        }
    }
    
}

