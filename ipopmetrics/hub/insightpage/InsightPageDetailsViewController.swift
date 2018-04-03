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

    
    @IBOutlet weak var containerDetailsMarkdown: UIView!
    @IBOutlet weak var constraintHeightDetailsMarkdown: NSLayoutConstraint!
    
    
    @IBOutlet weak var containerArgumentsMarkdown: UIView!
    @IBOutlet weak var constraintHeightArgumentsMarkdown: NSLayoutConstraint!
    
    @IBOutlet weak var containerClosingMarkdown: UIView!
    @IBOutlet weak var constraintHeightClosingMarkdown: NSLayoutConstraint!
    
    @IBOutlet weak var constraintBottomStackView: NSLayoutConstraint!
    
    private var feedCard: FeedCard!
    private var segueCard: TodoCard?
    
    private var recommendActionHandler: RecommendActionHandler?
    var cardInfoHandlerDelegate: CardInfoHandler?
    

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

    override func viewWillAppear(_ animated:Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(animated)        
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

        hideFailedSection()
        
        blogTitle.text = feedCard.blogTitle
        if let blogImageUrl = feedCard.blogImageUrl {
            blogImage.af_setImage(withURL: URL(string: blogImageUrl)!)
        }
        blogSummary.text = feedCard.blogSummary
        
        displayMarkDetails()
        displayMarkClosing()
        displayMarkInsights()
    }
    
    private func hideFailedSection() {
        constraintHeightArgumentsMarkdown.constant = 0
    }

    private func setupNavigationWithBackButton() {
        let titleWindow = "Analysis"
        
        let leftSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpace.width = 5
        
        let titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: nil)
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        leftButtonItem.tintColor = PopmetricsColor.darkGrey
        
        self.navigationItem.leftBarButtonItems = [leftSpace, leftButtonItem]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        self.title = titleWindow
    }
    
    func getMarkDownString() -> String {
        guard let _ = feedCard.detailsMarkdown else { return "" }
        return feedCard.detailsMarkdown!
    }
    
    func getMarkClosingString() -> String {
        return feedCard.closingMarkdown ?? ""
    }
    
    func getMarkInsightsString() -> String {
        return feedCard.insightArguments ?? ""
    }
    
    internal func displayMarkDetails() {
        let mark = Markdown()
        
        mark.addMarkInExtendedView(containerMark: containerDetailsMarkdown, containerHeightConstraint: constraintHeightDetailsMarkdown, markdownString: getMarkDownString())
        
        constraintHeightDetailsMarkdown.constant = constraintHeightDetailsMarkdown.constant + containerClosingMarkdown.frame.origin.y
        
        if getMarkDownString().isEmpty || getMarkDownString().count <= 1 {
            constraintHeightDetailsMarkdown.constant = 0
        } else {
            constraintHeightDetailsMarkdown.constant  = constraintHeightDetailsMarkdown.constant + 80
        }
    }
    
    internal func displayMarkInsights() {
        let mark = Markdown()
        
        mark.addMarkInExtendedView(containerMark: containerArgumentsMarkdown, containerHeightConstraint: constraintHeightArgumentsMarkdown, markdownString: getMarkInsightsString())
        
        constraintHeightArgumentsMarkdown.constant = constraintHeightArgumentsMarkdown.constant + containerArgumentsMarkdown.frame.origin.y
        
        if getMarkInsightsString().isEmpty || getMarkInsightsString().count <= 1 {
            constraintHeightArgumentsMarkdown.constant = 0
        } else {
            constraintHeightArgumentsMarkdown.constant  = constraintHeightArgumentsMarkdown.constant + 80
        }
    }
    
    internal func displayMarkClosing() {
        let mark = Markdown()
        
        mark.addMarkInExtendedView(containerMark: containerClosingMarkdown, containerHeightConstraint: constraintHeightClosingMarkdown, markdownString: getMarkClosingString())
        
        constraintHeightClosingMarkdown.constant = constraintHeightClosingMarkdown.constant + containerClosingMarkdown.frame.origin.y
        
        if getMarkClosingString().isEmpty || getMarkClosingString().count <= 1 {
            constraintHeightClosingMarkdown.constant = 0
        } else {
            constraintHeightClosingMarkdown.constant  = constraintHeightClosingMarkdown.constant + 80
        }
        
    }
    
    @IBAction func handlerViewArticleBtn(_ sender: Any) {
        
        if let url = feedCard.blogUrl {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openURLInside(self, url: url)
        }
    }

    @IBAction func handlerClickArticle(_ sender: UIButton) {
        if let url = feedCard.blogUrl {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openURLInside(self, url: url)
        }
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didPressShare(_ sender: AnyObject) {
        print("Pressed Share")
        
        let textToShare = "Check out this Popmetrics Analysis... "+Config.sharedInstance.environment.baseURL+"/card/"+feedCard.cardId!
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
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
    
    func openActionDetails(_ actionCard: TodoCard) {
        
        self.segueCard = actionCard
        self.performSegue(withIdentifier:"showActionDetails", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showActionDetails" {
            if self.segueCard != nil {
                let vc = segue.destination as! ActionDetailsViewController
                vc.configure(self.segueCard!, fromInsight: true)
            }
        }
        
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
        
        openActionDetails(actionCard)
        
    }
    
    @IBAction func unwindToInsight(segue:UIStoryboardSegue) {
    
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
