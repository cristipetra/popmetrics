//
//  InsightPageDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import markymark

class InsightPageDetailsViewController: UIViewController {

    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var titleArticle: UILabel!
    
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogSummary: UILabel!
    @IBOutlet weak var blogImage: UIImageView!
    
    @IBOutlet weak var labelInsightArguments: UILabel!
    
    @IBOutlet weak var constraintHeightDetailsMarkdown: NSLayoutConstraint!
    @IBOutlet weak var containerClosingMarkdown: UIView!
    @IBOutlet weak var containerDetailsMarkdown: UIView!
    @IBOutlet weak var containerInsightArguments: UIView!
    @IBOutlet weak var constraintHeightClosingMarkdown: NSLayoutConstraint!
    
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
        
        if let imageUrl = feedCard.blogImageUrl {
            blogImage.af_setImage(withURL: URL(string: imageUrl)!)
        }
        
        blogTitle.text = feedCard.blogTitle
        blogSummary.text = feedCard.blogSummary
        
        displayInsightArguments()
        displayMarkDetails()
        displayMarkClosing()
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
    
    internal func displayInsightArguments() {
        let insightsArguments = feedCard.getInsightArgumentsArray()
        var textString = ""
        for argument in insightsArguments {
            textString += "\(argument) \n\n"
        }
        labelInsightArguments.text = textString
    }
    
    func getMarkDownString() -> String {
        return feedCard.detailsMarkdown!
    }
    
    func getMarkClosingString() -> String {
        return feedCard.closingMarkdown!
    }
    
    internal func displayMarkDetails() {
        let mark = Markdown()
        
        mark.addMarkInExtendedView(containerMark: containerDetailsMarkdown, containerHeightConstraint: constraintHeightDetailsMarkdown, markdownString: getMarkDownString())
    }
    
    internal func displayMarkClosing() {
        let mark = Markdown()
        
        mark.addMarkInExtendedView(containerMark: containerClosingMarkdown, containerHeightConstraint: constraintHeightClosingMarkdown, markdownString: getMarkClosingString())
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
