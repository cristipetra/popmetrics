//
//  ActionPageDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import markymark

class ActionDetailsViewController: BaseViewController {
    
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
    @IBOutlet weak var addToMyActionsView: UIView!
    @IBOutlet weak var addToPaidActionsView: UIView!
    
    var cardInfoHandlerDelegate: CardInfoHandler?
    
    @IBOutlet weak var containerClosingMarkdown: UIView!
    
    private var todoCard: TodoCard!
    private var fromInsight = false
    
    let iceView = IceExtendView()
    
    let persistentFooter: PersistentFooter =  PersistentFooter()
    var bottomContainerViewBottomAnchor: NSLayoutConstraint!
    internal var isBottomVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.nativeBounds.height == 2436 {
            constraintBottomStackView.constant = constraintBottomStackView.constant - 34
        }
        
        addIceView()
        setupNavigationWithBackButton()
        
        updatView()
        
        self.view.addSwipeGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        
        addPersistentFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.whyThisRecommendationView.isHidden = fromInsight
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
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
    
    func addPersistentFooter() {
        view.addSubview(persistentFooter)
        persistentFooter.translatesAutoresizingMaskIntoConstraints = false
        persistentFooter.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        persistentFooter.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        persistentFooter.heightAnchor.constraint(equalToConstant: 81).isActive = true
        
        bottomContainerViewBottomAnchor = persistentFooter.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottomContainerViewBottomAnchor.isActive = true
        
        persistentFooter.rightBtn.addTarget(self, action: #selector(handlerOrder(_:)), for: .touchUpInside)
        persistentFooter.leftBtn.addTarget(self, action: #selector(handlerAddToMyActions(_:)), for: .touchUpInside)
        

    }
    
    public func configure(_ todoCard: TodoCard, fromInsight:Bool? = false) {
        self.todoCard = todoCard
        self.fromInsight = fromInsight ?? false
        iceView.configure(todoCard: todoCard)
        displayActionButton()
    }
    
    private func displayActionButton() {
        if todoCard == nil {
            persistentFooter.rightBtn.isHidden = true
            return
        }

        persistentFooter.leftBtn.isHidden = false
//        } else {
//            persistentFooter.rightBtn.changeTitle("Mark As Complete")
//            persistentFooter.rightBtn.hideImageBtn()
//
//            if todoCard.name == "social.automated_posts" {
//                persistentFooter.rightBtn.isHidden = true
//            }
//        }
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
    
    private func setupNavigationWithBackButton() {
        let titleWindow = "Action Recommendation"
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 5
        
        let titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: #selector(handlerClickBack))
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .selected)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        leftButtonItem.tintColor = PopmetricsColor.darkGrey
        
        self.navigationItem.leftBarButtonItems = [leftSpace, leftButtonItem, titleButton]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
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
    
    @objc func handlerOrder(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "OneOffPaymentViewController") as! OneOffPaymentViewController
        
        let brandId = UserStore.currentBrandId
        let planId = Config.sharedInstance.environment.stripeBasicPlanId
        var amount = Config.sharedInstance.environment.stripeBasicPlanAmount
        amount = 0
        vc.configure(brandId:brandId, amount:amount, planId:planId)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handlerAddToMyActions(_ sender: Any) {
        if !ReachabilityManager.shared.isNetworkAvailable {
            presentErrorNetwork()
            return
        }
        if self.todoCard != nil {
            HubsApi().postAddToMyActions(cardId: self.todoCard.cardId!, brandId: UserStore.currentBrandId) { todoCard in
                
                //TodoStore.getInstance().addTodoCard(todoCard!)
                self.performSegue(withIdentifier: "showMyActionPopup", sender: nil)
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
    
    @objc func handlerTakeActionPayment(_ sender: Any) {
        print("handler take action payment")
        Alert.showActionSheetPayment(parent: self) { (actionSheet) -> (Void) in
            self.openPopup()
        }
    }
    
    private func openPopup() {
        let alertCard = UIStoryboard.init(name: "Payment", bundle: nil).instantiateViewController(withIdentifier: "PaymentPopupViewController") as! PaymentPopupViewController
        
        alertCard.providesPresentationContextTransitionStyle = true
        alertCard.definesPresentationContext = true
        alertCard.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertCard.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        //alertCard.delegate = self
        self.present(alertCard, animated: true, completion: nil)
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

    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ActionDetailsViewController: BannerProtocol {
    
}
