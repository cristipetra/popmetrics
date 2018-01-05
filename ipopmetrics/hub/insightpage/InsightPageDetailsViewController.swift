//
//  InsightPageDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import markymark

class InsightPageDetailsViewController: BaseViewController {

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
    
    @IBOutlet weak var constraintBottomStackView: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightContainerFailed: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightContainerImpactScore: NSLayoutConstraint!
    private var feedCard: FeedCard!
    private var recommendActionHandler: RecommendActionHandler?
    
    @IBOutlet weak var impactScore: ImpactScoreView!
    let statsView = IndividualTaskView()
    
    var bottomContainerViewBottomAnchor: NSLayoutConstraint!
    internal var isBottomVisible = false
    
    let persistentFooter: PersistentFooter =  PersistentFooter()
    let store: FeedStore = FeedStore.getInstance()
    
    private var openedFrom: String = "home"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationWithBackButton()
        
        updateView()
        
        self.view.addSwipeGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        
        if UIScreen.main.nativeBounds.height == 2436 {
            constraintBottomStackView.constant = constraintBottomStackView.constant - 34
        }
        
        addPersistentFooter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func configure(_ feedCard: FeedCard, handler: RecommendActionHandler? = nil) {
        self.feedCard = feedCard
        recommendActionHandler = handler
        
        if self.feedCard.recommendedAction == "" {
            self.persistentFooter.rightBtn.isHidden = true            
        }
    }
    
    public func configure(_ feedCard: FeedCard, openedFrom: String) {
        self.openedFrom = openedFrom
        self.feedCard = feedCard
        
        if self.feedCard.recommendedAction == "" {
            self.persistentFooter.rightBtn.isHidden = true
        }
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
        
        hideFailedSection()
        
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
    
    private func hideFailedSection() {
        constraintHeightContainerFailed.constant = 0
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
        guard let _ = feedCard.detailsMarkdown else { return "" }
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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openURLInside(self, url: url)
        }
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addPersistentFooter() {
        view.addSubview(persistentFooter)
        persistentFooter.translatesAutoresizingMaskIntoConstraints = false
        persistentFooter.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        persistentFooter.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        persistentFooter.heightAnchor.constraint(equalToConstant: 81).isActive = true
        
        bottomContainerViewBottomAnchor = persistentFooter.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomContainerViewBottomAnchor.isActive = true
        
        persistentFooter.leftBtn.isHidden = true
        persistentFooter.rightBtn.changeTitle("View Action")
        
        persistentFooter.rightBtn.addTarget(self, action: #selector(handlerActionBtn), for: .touchUpInside)
    }
    
    @objc func handlerActionBtn() {
        if feedCard.recommendedAction == "" {
            self.presentAlertWithTitle("Error", message: "This insight has no recommended action!", useWhisper: true);
            return
        }
        guard let actionCard = TodoStore.getInstance().getTodoCardWithName(feedCard.recommendedAction)
            else {
                self.presentAlertWithTitle("Error", message: "No card to show with name: "+feedCard.recommendedAction, useWhisper: true);
                return
        }
    
        let actionPageVc: ActionPageDetailsViewController = ActionPageDetailsViewController(nibName: "ActionPage", bundle: nil)
        
        actionPageVc.hidesBottomBarWhenPushed = true
        if openedFrom == "home" {
            actionPageVc.configure(actionCard, handler: recommendActionHandler)
        } else  {
            actionPageVc.configure(actionCard, openedFrom: "todo")
        }
        

        self.navigationController?.pushViewController(viewController: actionPageVc, animated: true, completion: {
            self.closePreviousViewControllerFromNavigation()
        })
        
    }
    
}

extension UIViewController {
    func closePreviousViewControllerFromNavigation() {
        self.navigationController?.viewControllers.remove(at: ((self.navigationController?.viewControllers.count)! - 2))
    }
}

extension UINavigationController {
    
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
}
