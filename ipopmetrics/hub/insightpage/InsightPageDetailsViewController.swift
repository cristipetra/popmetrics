//
//  InsightPageDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class InsightPageDetailsViewController: UIViewController {

    @IBOutlet weak var titleArticle: UILabel!
    
    private var feedCard: FeedCard!
    private var recommendActionHandler: RecommendActionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func configure(_ feedCard: FeedCard, handler: RecommendActionHandler? = nil) {
        self.feedCard = feedCard
        
        recommendActionHandler = handler
    }
    
    private func updateView() {
        titleArticle.text = feedCard.headerTitle
    }
    

}
