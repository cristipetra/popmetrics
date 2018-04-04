//
//  HomeFeedHubController.swift
//  
//
//  Created by Rares Pop on 04/04/2018.
//

import UIKit
import DGElasticPullToRefresh

class HomeFeedHubController: BaseHubViewController {
    
    let onwSectionToIndex = ["Required Actions":0,
                          "Insights":1,
                          "Recommended For You":2,
                          "Recommended Actions":3,
                          "Summaries":4,
                          "More On The Way":5]

    override func getHubName()->String {
        return "Home"
    }
    
    
    override func viewDidLoad() {
        
        setStore(PopHubStore.getInstance())
        
        
        for (k,v) in self.onwSectionToIndex {
            self.registerSection(k, atIndex:v)
        }
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        
        registerNibForCardType("required_action", nibName:"RequiredActionCard", nibIdentifier:"RequiredActionCard")
        registerNibForCardType("empty_state", nibName:"EmptyStateCard", nibIdentifier:"EmptyStateCard")
        registerNibForCardType("insight", nibName:"InsightCard", nibIdentifier:"InsightCard")
        registerNibForCardType("pop_tip", nibName:"PopTipCard", nibIdentifier:"PopTipCard")
        
        // elastic pull to refresh loader
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = PopmetricsColor.yellowBGColor
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // old code: self?.fetchItems(silent:false)
            SyncService.getInstance().syncAll(silent: false)
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PopmetricsColor.borderButton)
        tableView.dg_setPullToRefreshBackgroundColor(PopmetricsColor.loadingBackground)
        
    }
    
}

