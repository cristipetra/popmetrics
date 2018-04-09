//
//  ActionStatusViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import markymark

class ActionStatusViewController: BaseCardDetailsViewController {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogSummary: UILabel!
    
    @IBOutlet weak var containerFixIt: UIView!
    
    @IBOutlet weak var constraintHeightFixIt: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightDetailsMarkdown: NSLayoutConstraint!
    @IBOutlet weak var containerIceView: UIView!
    @IBOutlet weak var containerDetailsMarkdown: UIView!
    @IBOutlet weak var containerInsightArguments: UIView!
    
    @IBOutlet weak var constraintBottomStackView: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightClosingMarkdown: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightIceView: NSLayoutConstraint!
    
    @IBOutlet weak var addToMyActionsView: UIView!
    @IBOutlet weak var addToPaidActionsView: UIView!
    
    private var recommendActionHandler: RecommendActionHandler?
    
    var cardInfoHandlerDelegate: CardInfoHandler?
    
    @IBOutlet weak var containerClosingMarkdown: UIView!
    
    private var todoCard: TodoCard!
    
    let iceView = IceExtendView()

    var bottomContainerViewBottomAnchor: NSLayoutConstraint!

    @IBOutlet weak var btnCompleted: UIButton!
    @IBOutlet weak var btnDoItForMe: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addIceView()
        
        updatView()
        
        self.title = "Action Status"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.btnCompleted.isHidden = true
        self.btnDoItForMe.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        
        iceView.topAnchor.constraint(equalTo: self.containerIceView.topAnchor, constant: 0).isActive = true
        iceView.rightAnchor.constraint(equalTo: self.containerIceView.rightAnchor, constant: 0).isActive = true
        iceView.bottomAnchor.constraint(equalTo: self.containerIceView.bottomAnchor, constant: 0).isActive = true
        iceView.leftAnchor.constraint(equalTo: self.containerIceView.leftAnchor, constant: 0).isActive = true
        
    }
    
    private func addIceView() {
        self.containerIceView.addSubview(iceView)
        iceView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addHandlerForActionsBtns() {
        btnDoItForMe.addTarget(self, action: #selector(orderAction(_:)), for: .touchUpInside)
        if todoCard.name != "social.automated_twitter_posts" || todoCard.name != "social.automated_facebook_posts" {
            btnCompleted.addTarget(self, action: #selector(markAsCompleteAction(_:)), for: .touchUpInside)
        }
    }
    
    public func configureWithTodoCard(_ todoCard: TodoCard, openedFrom: String) {
        
        guard let card = PopHubStore.getInstance().getHubCardWithId(todoCard.cardId!) else { return }
        self.configure(card: card)
        
        self.todoCard = todoCard
        
        iceView.configure(todoCard:todoCard)
    }
    
    private func updatView() {
        if let url = todoCard.imageUri {
            cardImage.af_setImage(withURL: URL(string: url)!)
        }
        
        if let title = todoCard.blogTitle {
            titleArticle.text = title
        }
        
        displayMarkdownDetails()
        displayMarkdownClosing()
        displayMarkdownFixIt()
    }
    
    
    private func getDetailsMarkdownString() -> String {
        return todoCard.detailsMarkdown ?? ""
    }
    
    private func getClosingMarkdownString() -> String {
        return todoCard.closingMarkdown ?? ""
    }
    
    private func getFixItMarkdownString() -> String {
        return todoCard.diyInstructions ?? ""
    }
    
    internal func displayMarkdownDetails() {
        let mark = Markdown()
        mark.addMarkInExtendedView(containerMark: containerDetailsMarkdown, containerHeightConstraint: constraintHeightDetailsMarkdown, markdownString: getDetailsMarkdownString())
        
        if getDetailsMarkdownString().isEmpty || getDetailsMarkdownString().count <= 1 {
            constraintHeightDetailsMarkdown.constant = 0
        } else {
            constraintHeightDetailsMarkdown.constant  = constraintHeightDetailsMarkdown.constant + 80
        }
        
    }
    
    internal func displayMarkdownFixIt() {
        let mark = Markdown()
        mark.addMarkInExtendedView(containerMark: containerFixIt, containerHeightConstraint: constraintHeightFixIt, markdownString: getFixItMarkdownString())
        
        if getFixItMarkdownString().isEmpty || getFixItMarkdownString().count <= 1 {
            constraintHeightFixIt.constant = 0
        } else {
            constraintHeightFixIt.constant  = constraintHeightFixIt.constant + 80
        }
    }
    
    internal func displayMarkdownClosing() {
        let mark = Markdown()
        mark.addMarkInExtendedView(containerMark: containerClosingMarkdown, containerHeightConstraint: constraintHeightClosingMarkdown, markdownString: getClosingMarkdownString())
        
        if getClosingMarkdownString().isEmpty || getClosingMarkdownString().count <= 1 {
            constraintHeightClosingMarkdown.constant = 0
        } else {
            constraintHeightClosingMarkdown.constant  = constraintHeightClosingMarkdown.constant + 80
        }
    }
    
    @IBAction func handlerViewArticleBtn(_ sender: Any) {
        if let url = todoCard.blogUrl {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openURLInside(self, url: url)
        }
    }
    
    @IBAction func handlerViewInstructions(_ sender: Any) {
        
        if let url = todoCard.blogUrl {
            if url.isValidUrl() {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.openURLInside(self, url: url)
            }
        }
        
    }
    

    @IBAction func markAsCompleteAction(_ sender: Any) {
        
        if self.todoCard != nil {
            HubsApi().postAddToMyActions(cardId: self.todoCard.cardId!, brandId: UserStore.currentBrandId) { todoCard in
                
                  self.performSegue(withIdentifier: "showInReviewPopup", sender: nil)
//                TodoStore.getInstance().addTodoCard(todoCard!)
//
//                if let insightCard = FeedStore.getInstance().getFeedCardWithRecommendedAction((todoCard?.name)!) {
//                    FeedStore.getInstance().updateCardSection(insightCard, section:"None")
//                }
//                self.cardInfoHandlerDelegate?.handleActionComplete()
//
//                NotificationCenter.default.post(name: Notification.Popmetrics.UiRefreshRequired, object: nil,
//                                                userInfo: ["sucess":true])
//
//                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func orderAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "OneOffPaymentViewController") as! OneOffPaymentViewController
        
        let brandId = UserStore.currentBrandId
        let planId = Config.sharedInstance.environment.stripeBasicPlanId
        var amount = Config.sharedInstance.environment.stripeBasicPlanAmount
        amount = 0
        vc.configure(brandId:brandId, amount:amount, todoCard: self.todoCard)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handlerInsightPage(_ sender: UIButton) {
        
        // unwind segue
    }
    
    func getRelatedInsightCard() -> FeedCard? {
        let store = FeedStore.getInstance()
        if todoCard != nil {
            if let insightCard = store.getFeedCardWithRecommendedAction((todoCard?.name)!) {
                return insightCard
            }
        }
        return nil
    }

}
