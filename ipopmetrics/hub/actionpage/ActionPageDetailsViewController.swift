//
//  ActionPageDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import markymark

class ActionPageDetailsViewController: UIViewController {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogSummary: UILabel!
    @IBOutlet weak var impactScore: ImpactScoreView!
    
    
    @IBOutlet weak var constraintHeightDetailsMarkdown: NSLayoutConstraint!
    @IBOutlet weak var containerIceView: UIView!
    @IBOutlet weak var containerDetailsMarkdown: UIView!
    @IBOutlet weak var containerInsightArguments: UIView!

    @IBOutlet weak var constraintHeightClosingMarkdown: NSLayoutConstraint!
    private var recommendActionHandler: RecommendActionHandler?
    
    @IBOutlet weak var containerClosingMarkdown: UIView!
    
    private var feedCard: FeedCard!
    private var todoCard: TodoCard!
    
    private var actionModel: ActionPageModel!
    
    let statsView = IndividualTaskView()
    let iceView = IceExtendView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addIceView()
        impactScore.setProgress(0.0)
        setupNavigationWithBackButton()
        
       updatView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addIceView() {
        self.containerIceView.addSubview(iceView)
        
        iceView.translatesAutoresizingMaskIntoConstraints = false
        iceView.topAnchor.constraint(equalTo: self.containerIceView.topAnchor, constant: 0).isActive = true
        iceView.rightAnchor.constraint(equalTo: self.containerIceView.rightAnchor, constant: 0).isActive = true
        iceView.bottomAnchor.constraint(equalTo: self.containerIceView.bottomAnchor, constant: 0).isActive = true
        iceView.leftAnchor.constraint(equalTo: self.containerIceView.leftAnchor, constant: 0).isActive = true
        
    }
    
    public func configure(_ feedCard: FeedCard, handler: RecommendActionHandler? = nil) {
        self.feedCard = feedCard
        actionModel = ActionPageModel(feedCard: feedCard)
        recommendActionHandler = handler
        iceView.configure(feedCard)
    }
    
    public func configure(todoCard: TodoCard) {
        self.todoCard = todoCard
        iceView.configure(todoCard: todoCard)
        actionModel = ActionPageModel(todoCard: todoCard)
    }
    
    private func updatView() {
        if let url = actionModel.imageUri {
            cardImage.af_setImage(withURL: URL(string: url)!)
        }
        
        if let title = actionModel.titleArticle {
            titleArticle.text = title
        }
        
        let progress = CGFloat(actionModel.impactPercentage) / CGFloat(100)
        impactScore.setProgress(progress)
        
        displayMarkdownDetails()
        displayMarkdownClosing()
    }
    
    private func setupNavigationWithBackButton() {
        let titleWindow = "Action Page"
        
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

    private func getDetailsMarkdownString() -> String {
        return actionModel.detailsMarkdown ?? ""
    }
    
    private func getClosingMarkdownString() -> String {
        return actionModel.closingMarkdown ?? ""
    }
    
    internal func displayMarkdownDetails() {
        let mark = Markdown()
        mark.addMarkInExtendedView(containerMark: containerDetailsMarkdown, containerHeightConstraint: constraintHeightDetailsMarkdown, markdownString: getDetailsMarkdownString())
    }
    
    internal func displayMarkdownClosing() {
        let mark = Markdown()
        mark.addMarkInExtendedView(containerMark: containerClosingMarkdown, containerHeightConstraint: constraintHeightClosingMarkdown, markdownString: getClosingMarkdownString())
    }

    @IBAction func handlerViewArticleBtn(_ sender: Any) {
        if let url = actionModel.blogUrl {
            self.openURLInside(url: url)
        }
    }
    
    @IBAction func handlerViewInstructions(_ sender: Any) {
        let instructionsPageVc: ActionInstructionsPageViewController = ActionInstructionsPageViewController(nibName: "ActionInstructionsPage", bundle: nil)
        if (feedCard != nil) {
            instructionsPageVc.configure(feedCard)
        }
        if todoCard != nil {
            instructionsPageVc.configure(todoCard: todoCard)
        }
        self.navigationController?.pushViewController(instructionsPageVc, animated: true)
    }
    
    @IBAction func handlerAddToMyActions(_ sender: Any) {
        if feedCard != nil {
            FeedApi().postAddToMyActions(feedCardId: self.feedCard.cardId!, brandId: UserStore.currentBrandId) { todoCard in
                TodoStore.getInstance().addTodoCard(todoCard!)
                FeedStore.getInstance().removeCard(self.feedCard)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}


class ActionPageModel: NSObject {
    internal var titleArticle: String? = ""
    internal var imageUri: String?
    internal var impactPercentage: Int = 0
    internal var detailsMarkdown: String? = ""
    internal var closingMarkdown: String? = ""
    internal var blogUrl: String? = ""
    
    init(todoCard: TodoCard) {
        titleArticle         = todoCard.headerTitle
        imageUri             = todoCard.imageUri
        impactPercentage     = todoCard.iceImpactPercentage
        detailsMarkdown      = todoCard.detailsMarkdown
        closingMarkdown      = todoCard.closingMarkdown
        blogUrl              = todoCard.blogUrl
    }
    
    init(feedCard: FeedCard) {
        titleArticle        = feedCard.headerTitle
        imageUri            = feedCard.imageUri
        impactPercentage    = feedCard.iceImpactPercentage
        detailsMarkdown     = feedCard.detailsMarkdown
        closingMarkdown     = feedCard.closingMarkdown
        blogUrl             = feedCard.blogUrl
    }
}
