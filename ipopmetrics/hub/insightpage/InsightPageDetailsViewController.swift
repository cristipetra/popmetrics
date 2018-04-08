//
//  InsightPageDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import markymark

class InsightPageDetailsViewController: BaseCardDetailsViewController {

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
    
    private var segueCard: TodoCard?
    
    @IBOutlet weak var btnViewAction: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated:Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        super.viewWillAppear(animated)
        self.title = "Analysis"
        
        guard let popHubCard = self.hubCard as? PopHubCard else { return }
        self.actionsView.isHidden = ("" == popHubCard.recommendedAction)
        
        titleArticle.text = popHubCard.headerTitle
        if let cardImageUrl = popHubCard.imageUri {
            if let url =  URL(string: cardImageUrl) {
                cardImage.af_setImage(withURL: url)
            }
        }
        if let aBlogImageUrl = popHubCard.blogImageUrl {
            if let url =  URL(string: aBlogImageUrl) {
                blogImage.af_setImage(withURL: url)
            }
        }
        
        if let ablogTitle = popHubCard.blogTitle {
            self.blogTitle.text = ablogTitle
        }
        if let aBlogSummary = popHubCard.blogSummary {
            self.blogSummary.text = aBlogSummary
        }
        
        displayMarkDetails(popHubCard.detailsMarkdown)
        displayMarkClosing(popHubCard.closingMarkdown)
        displayMarkInsights(popHubCard.insightArguments)

    }
    
    internal func displayMarkDetails(_ content:String?) {
        
        if content == nil || content == "" {
            self.containerDetailsMarkdown.isHidden = true
            return
        }

        let mark = Markdown()
        
        mark.addMarkInExtendedView(containerMark: containerDetailsMarkdown, containerHeightConstraint: constraintHeightDetailsMarkdown, markdownString: content!)
    }
    
    internal func displayMarkClosing(_ content:String?) {
        
        if content == nil || content == "" {
            self.containerClosingMarkdown.isHidden = true
            return
        }
        
        let mark = Markdown()
        
        mark.addMarkInExtendedView(containerMark: containerClosingMarkdown, containerHeightConstraint: constraintHeightDetailsMarkdown, markdownString: content!)
    }
    
    internal func displayMarkInsights(_ content:String?) {
        
        if content == nil || content == "" {
            self.containerArgumentsMarkdown.isHidden = true
            return
        }
        
        let mark = Markdown()
        
        mark.addMarkInExtendedView(containerMark: containerArgumentsMarkdown, containerHeightConstraint: constraintHeightArgumentsMarkdown, markdownString: content!)
    }
    
    @IBAction func viewActionButtonHandler(_ sender: Any) {
        
        guard let popHubCard = self.hubCard as? PopHubCard else { return }
        
        guard let actionCard = TodoStore.getInstance().getTodoCardWithName(popHubCard.recommendedAction)
            else {
                self.presentAlertWithTitle("Error", message: "No card to show with name: "+popHubCard.recommendedAction, useWhisper: true);
                return
        }

        openActionDetails(actionCard)
        
    }

    @IBAction func handlerViewArticleBtn(_ sender: Any) {
        guard let popHubCard = self.hubCard as? PopHubCard else { return }
        if let url = popHubCard.blogUrl {
            navigator.open(url)
        }
        
        
    }

    @IBAction func handlerClickArticle(_ sender: UIButton) {
        guard let popHubCard = self.hubCard as? PopHubCard else { return }
        if let url = popHubCard.blogUrl {
            navigator.open(url)
        }
    }
    
    
    func openActionDetails(_ actionCard: TodoCard) {
        self.segueCard = actionCard
        self.performSegue(withIdentifier:"showActionDetails", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showActionDetails" {
            if self.segueCard != nil {
                let vc = segue.destination as! ActionDetailsViewController
                vc.configureWithTodoCard(self.segueCard!, fromInsight: true)
            }
        }
        
    }
    
    @IBAction func unwindToInsight(segue:UIStoryboardSegue) {
    
    }
    
}


//extension UINavigationController {
//
//    public func pushViewController(viewController: UIViewController,
//                                   animated: Bool,
//                                   completion: (() -> Void)?) {
//        CATransaction.begin()
//        CATransaction.setCompletionBlock(completion)
//        pushViewController(viewController, animated: animated)
//        CATransaction.commit()
//    }
//
//}
