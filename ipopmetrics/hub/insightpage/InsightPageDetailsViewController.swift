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
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogSummary: UILabel!
    
    @IBOutlet weak var containerInsightArguments: UIView!
    
    private var feedCard: FeedCard!
    private var recommendActionHandler: RecommendActionHandler?
    
    let statsView = IndividualTaskView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationWithBackButton()
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func configure(_ feedCard: FeedCard, handler: RecommendActionHandler? = nil) {
        self.feedCard = feedCard
        print(feedCard)
        recommendActionHandler = handler
    }
    
    private func updateView() {
        titleArticle.text = feedCard.headerTitle
        
        blogTitle.text = feedCard.blogTitle
        blogSummary.text = feedCard.blogSummary
    }
    

    private func setupNavigationWithBackButton() {
        let titleWindow = "Insight Page"
        let titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: nil)
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, titleButton]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @IBAction func handlerViewArticleBtn(_ sender: Any) {
        if let url = feedCard.blogUrl {
            self.openURLInside(url: url)
        }
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
