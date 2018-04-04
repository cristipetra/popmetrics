//
//  SocialPostDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 27/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ObjectMapper
import EZAlertController

class SocialPostDetailsViewController: BaseViewController {
    
    @IBOutlet var containerView: SocialPostDetailsView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var articleUrl: UILabel!
    
    @IBOutlet weak var messageFacebook: UITextView!
    @IBOutlet weak var scheduleInfoLabel: UILabel!
    @IBOutlet weak var denyPostBtn: UIButton!
    @IBOutlet weak var approvePostBtn: ActionTodoButton!
    @IBOutlet weak var bottomContainerViewBottomAnchor: NSLayoutConstraint!
    
    private var todoSocialPost: TodoSocialPost!
    private var calendarSocialPost: CalendarSocialPost!
    
    internal var isBottomVisible = false
    
    weak var actionSocialDelegate: ActionSocialPostProtocol!
    weak var bannerDelegate: BannerProtocol!
    private var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationWithBackButton()
        
        scrollView.delegate = self
        
    
        if todoSocialPost != nil {
            containerView.configure(todoSocialPost: todoSocialPost)
            updateView()
        } else if calendarSocialPost != nil {
            containerView.configure(calendarSocialPost: calendarSocialPost)
            updateViewCalendar()
        }
        
        self.view.addSwipeGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
     
        addHandlers()
    
        displayContainerBtnsIfNeeded()
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    private func addHandlers() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlerClickArticleUrl));
        articleUrl.isUserInteractionEnabled = true
        articleUrl.addGestureRecognizer(tapGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        denyPostBtn.addTarget(self, action: #selector(handlerDenyPost(sender:)), for: .touchUpInside)
        approvePostBtn.addTarget(self, action: #selector(approvePost(sender:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func configure(todoSocialPost: TodoSocialPost) {
        self.todoSocialPost = todoSocialPost
    }
    
    func configure(calendarSocialPost: CalendarSocialPost) {
        self.calendarSocialPost = calendarSocialPost
    }
    
    internal func setIndexPath(_ indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    private func updateViewCalendar() {
        hideStatusBtns()
    }
    
    @objc internal func dismissKeyboard() {
        if containerView.messageFacebook != nil {
            containerView.messageFacebook.resignFirstResponder()
        }
        if containerView.recommendedText != nil {
            containerView.recommendedText.resignFirstResponder()
        }
    }
    
    private func updateView() {
        setupStatusCardView()
    }
    
    func setupStatusCardView() {
        var isApproved: Bool = false
        if todoSocialPost != nil {
            isApproved = todoSocialPost.isApproved
        }
        print("approved \(isApproved)")
        if !isApproved {
            denyPostBtn.isHidden = false
            approvePostBtn.displayUnapproved()
        } else {
            approvePostBtn.displayApproved()
            denyPostBtn.isHidden = true
            approvePostBtn.removeTarget(self, action: #selector(approvePost), for: .touchUpInside)
        }
    }
    
    internal func hideStatusBtns() {
        denyPostBtn.isHidden = true
        approvePostBtn.isHidden = true
    }
    
    private func setupNavigationWithBackButton() {
        let titleWindow = "Recommended Social Post"
        
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
    
    @objc func handlerClickArticleUrl(sender: Any) {
        if todoSocialPost != nil {
            if todoSocialPost.articleUrl.isValidUrl() {
                openArticle(todoSocialPost.articleUrl)
            }
        }
        
        if calendarSocialPost != nil {
            if calendarSocialPost.url.isValidUrl() {
                openArticle(calendarSocialPost.url)
            }
        }
        
    }
    
    private func openArticle(_ articleUrl: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.openURLInside(self, url: articleUrl)
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handlerDenyPost(sender: Any) {
        if !ReachabilityManager.shared.isNetworkAvailable {
            presentErrorNetwork()
            return
        }
        self.showProgressIndicator()
        if actionSocialDelegate != nil {
            self.actionSocialDelegate.denyPostFromSocial!(post: self.todoSocialPost, indexPath: indexPath)
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (_) in
                self.navigationController?.popViewController(animated: true)
                self.hideProgressIndicator()
            })
            
        }
    }
    
    private func approvePostFacebook() {
        guard var message = containerView.messageFacebook.text else { return }

        if !containerView.isMessageFacebookSet() {
            message = ""
        }
        
        approvePostBtn.animateButton()
        
        try! todoSocialPost.realm?.write {
            todoSocialPost.isApproved = true
            todoSocialPost.message = containerView.messageFacebook.text
        }
        
        print(todoSocialPost.isApproved)
        if actionSocialDelegate !=  nil {
            self.actionSocialDelegate.approvePostFromSocialWithMessage!(post: todoSocialPost, indexPath: indexPath, message: message)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @objc func approvePost(sender: AnyObject) {
        
        if !ReachabilityManager.shared.isNetworkAvailable {
            presentErrorNetwork()
            return
        }
        
        if todoSocialPost.type == "facebook" {
            approvePostFacebook()
            return
        }
        
        approvePostBtn.animateButton()
        
        try! todoSocialPost.realm?.write {
            todoSocialPost.message = containerView.recommendedText.text
        }
        
        if actionSocialDelegate !=  nil {
            self.actionSocialDelegate.approvePostFromSocial!(post: self.todoSocialPost, indexPath: indexPath)
            self.navigationController?.popViewController(animated: true)
        }
        
        try! todoSocialPost.realm?.write {
            todoSocialPost.isApproved = true
        }
    }
    
}

extension SocialPostDetailsViewController: BannerProtocol {
    
}

extension SocialPostDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*
        if ((scrollView.contentOffset.y + 60) >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            
            scrollView.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.6, animations: {
                if self.isBottomVisible == false {
                    self.bottomContainerViewBottomAnchor.constant = 0
                }
                self.isBottomVisible = true
                self.containerView.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.bottomContainerViewBottomAnchor.constant = 61
                self.isBottomVisible = false
                self.containerView.layoutIfNeeded()
            })
        }
     */
    }
    
    func displayContainerBtnsIfNeeded() {
        if ((scrollView.contentOffset.y + 60) >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            UIView.animate(withDuration: 0.6, animations: {
                self.bottomContainerViewBottomAnchor.constant = 0
                self.isBottomVisible = true
            })
        }
    }
    
}

@objc protocol ActionSocialPostProtocol: class {
    @objc optional func denyPostFromSocial(post: TodoSocialPost, indexPath: IndexPath)
    @objc optional func cancelPostFromSocial(post: CalendarSocialPost, indexPath: IndexPath)
    @objc optional func approvePostFromSocial(post: TodoSocialPost, indexPath: IndexPath)
    @objc optional func approvePostFromSocialWithMessage(post: TodoSocialPost, indexPath: IndexPath, message: String)
    @objc optional func displayFacebookDetails(post: TodoSocialPost, indexPath: IndexPath)
}

@objc protocol BannerProtocol: class {
    @objc optional func presentErrorNetwork()
}

