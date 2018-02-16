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

    lazy var approvePostBtn: ActionTodoButton = {
        let button = ActionTodoButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var todoSocialPost: TodoSocialPost!
    private var calendarSocialPost: CalendarSocialPost!
    
    var bottomContainerViewBottomAnchor: NSLayoutConstraint!
    internal var isBottomVisible = false
    
    weak var actionSocialDelegate: ActionSocialPostProtocol!
    weak var bannerDelegate: BannerProtocol!
    private var indexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationWithBackButton()
        
        scrollView.delegate = self
        
        addBottomButtons()
    
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
     
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlerClickArticleUrl));
        articleUrl.isUserInteractionEnabled = true
        articleUrl.addGestureRecognizer(tapGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    
        displayContainerBtnsIfNeeded()
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
    
    func addBottomButtons() {
        
        containerView.addSubview(buttonContainerView)
        
        //buttonContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bottomContainerViewBottomAnchor = buttonContainerView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        bottomContainerViewBottomAnchor.isActive = true
        buttonContainerView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        buttonContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        buttonContainerView.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
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
        approvePostBtn.layer.cornerRadius = 17
        
        separatorView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 0).isActive = true
        separatorView.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: buttonContainerView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        denyPostBtn.addTarget(self, action: #selector(handlerDenyPost(sender:)), for: .touchUpInside)
        approvePostBtn.addTarget(self, action: #selector(approvePost(sender:)), for: .touchUpInside)
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
        guard let message = containerView.messageFacebook.text else { return }
        
//        if !containerView.isMessageFacebookSet() {
//            EZAlertController.alert("Please add a message to be posted on facebook.")
//            return
//        }
        
        approvePostBtn.animateButton()
        
        if actionSocialDelegate !=  nil {
            self.actionSocialDelegate.approvePostFromFacebookSocial!(post: todoSocialPost, indexPath: indexPath, message: message)
            self.navigationController?.popViewController(animated: true)
        }
        
        try! todoSocialPost.realm?.write {
            todoSocialPost.isApproved = true
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
    @objc optional func approvePostFromFacebookSocial(post: TodoSocialPost, indexPath: IndexPath, message: String)
    @objc optional func displayFacebookDetails(post: TodoSocialPost, indexPath: IndexPath)
}

@objc protocol BannerProtocol: class {
    @objc optional func presentErrorNetwork()
}

