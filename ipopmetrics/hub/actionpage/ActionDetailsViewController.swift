//
//  ActionPageDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import markymark

class ActionDetailsViewController: BaseCardDetailsViewController {
    
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
    
    @IBOutlet weak var whyThisRecommendationView: UIView!

    @IBOutlet weak var diyButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    var cardInfoHandlerDelegate: CardInfoHandler?
    
    @IBOutlet weak var containerClosingMarkdown: UIView!
    
    private var todoCard: TodoCard!
    private var fromInsight = false
    
    let iceView = IceExtendView()
    
    var bottomContainerViewBottomAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addIceView()
        
        updatView()
        self.title = "Recommended Action"
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.whyThisRecommendationView.isHidden = fromInsight
        
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
    
    public func configureWithTodoCard(_ todoCard: TodoCard, fromInsight:Bool? = false) {
        // this is the the method to configure things with an old todoCard
        // will go away
        
        guard let card = PopHubStore.getInstance().getHubCardWithId(todoCard.cardId!) else { return }
        self.configure(card: card)
        
        self.todoCard = todoCard
        self.fromInsight = fromInsight ?? false
        iceView.configure(todoCard: todoCard)
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

    @IBAction func handleDiyAction(_ sender: Any) {
    
        if !ReachabilityManager.shared.isNetworkAvailable {
            presentErrorNetwork()
            return
        }
        if self.todoCard != nil {
            HubsApi().postAddToMyActions(cardId: self.todoCard.cardId!, brandId: UserStore.currentBrandId) { todoCard in
                
                TodoStore.getInstance().addTodoCard(todoCard!)
                if let insightCard = FeedStore.getInstance().getFeedCardWithRecommendedAction((todoCard?.name)!) {
                    FeedStore.getInstance().updateCardSection(insightCard, section:"None")
                }
                self.cardInfoHandlerDelegate?.handleActionComplete()

                NotificationCenter.default.post(name: Notification.Popmetrics.UiRefreshRequired, object: nil,
                                                userInfo: ["sucess":true])
                self.performSegue(withIdentifier: "showDIYPopup", sender: nil)
            }
        }
    }
    
    @IBAction func handleOrderAction(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OneOffPaymentViewController") as! OneOffPaymentViewController
        
        let brandId = UserStore.currentBrandId
        var amount = Config.sharedInstance.environment.stripeBasicPlanAmount
        amount = 0
        
        vc.configure(brandId:brandId, amount:amount, todoCard: self.todoCard)
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func handlerInsightPage(_ sender: UIButton) {
        
        // see if we need to navigate back or go forward
        
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

extension ActionDetailsViewController: BannerProtocol {
    
}

extension ActionDetailsViewController: PopupAlertViewDelegate {
    func goToHome() {
        self.navigationController?.popViewController(animated: true)
    }
}
