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
    
    @IBOutlet weak var constraintHeightContainerImpactScore: NSLayoutConstraint!
    private var feedCard: FeedCard!
    private var recommendActionHandler: RecommendActionHandler?
    
    @IBOutlet weak var impactScore: ImpactScoreView!
    let statsView = IndividualTaskView()
    
    
    var bottomContainerViewBottomAnchor: NSLayoutConstraint!
    internal var isBottomVisible = false
    
    lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 189/255, green: 197/255, blue: 203/255, alpha: 1)
        return view
    }()
    
    lazy var denyPostBtn: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(PopmetricsColor.secondGray, for: .normal)
        button.setTitle("Deny Post", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont(name: FontBook.bold, size: 15)
        return button
    }()
    
    lazy var approvePostBtn: TwoColorButton = {
        let button = TwoColorButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.changeTitle("Approve Post")
        button.titleLabel?.font = UIFont(name: FontBook.bold, size: 15)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationWithBackButton()
        
        updateView()
        
        self.view.addSwipeGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        
        addBottomButtons()
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
        
        if let cardImageUrl = feedCard.imageUri {
            if let url =  URL(string: cardImageUrl) {
                cardImage.af_setImage(withURL: url)
            }
        }
        
        if(!Bool(feedCard.iceEnabled)) {
            hideImpactScoreView()
        }
        
        let progress = CGFloat(feedCard.iceImpactPercentage) / CGFloat(100)
        
        impactScore.setProgress(progress)
        
        blogTitle.text = feedCard.blogTitle
        if let blogImageUrl = feedCard.blogImageUrl {
            blogImage.af_setImage(withURL: URL(string: blogImageUrl)!)
        }
        blogSummary.text = feedCard.blogSummary
        
        displayInsightArguments()
        displayMarkDetails()
        displayMarkClosing()
    }
    
    private func hideImpactScoreView() {
        constraintHeightContainerImpactScore.constant = 0
        impactScore.isHidden = true
    }
    
    private func setupNavigationWithBackButton() {
        let titleWindow = "Insight Page"
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 5
        
        let titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: nil)
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        leftButtonItem.tintColor = PopmetricsColor.darkGrey
        
        self.navigationItem.leftBarButtonItems = [leftSpace, leftButtonItem, titleButton]
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
    
    func addBottomButtons() {
        
        view.addSubview(buttonContainerView)
        
        //buttonContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bottomContainerViewBottomAnchor = buttonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomContainerViewBottomAnchor.isActive = true
        buttonContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        buttonContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        buttonContainerView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        buttonContainerView.addSubview(denyPostBtn)
        buttonContainerView.addSubview(approvePostBtn)
        buttonContainerView.addSubview(separatorView)
        
        denyPostBtn.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor, constant: 25).isActive = true
        denyPostBtn.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 18).isActive = true
        denyPostBtn.widthAnchor.constraint(equalToConstant: 90).isActive = true
        denyPostBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        approvePostBtn.rightAnchor.constraint(equalTo: buttonContainerView.rightAnchor, constant: -24).isActive = true
        approvePostBtn.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 12).isActive = true
        approvePostBtn.widthAnchor.constraint(equalToConstant: 161).isActive = true
        approvePostBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        separatorView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 0).isActive = true
        separatorView.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: buttonContainerView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //denyPostBtn.addTarget(self, action: #selector(denyPost(sender:)), for: .touchUpInside)
        //approvePostBtn.addTarget(self, action: #selector(approvePost(sender:)), for: .touchUpInside)
    }
    
}
