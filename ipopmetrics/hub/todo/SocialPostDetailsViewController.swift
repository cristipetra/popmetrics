//
//  SocialPostDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 27/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SocialPostDetailsViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var titleBlogLabel: UILabel!
    @IBOutlet weak var blogUrl: UILabel!
    @IBOutlet weak var blogMessage: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    private var todoCard: TodoCard!
    
    var bottomContainerViewBottomAnchor: NSLayoutConstraint!
    internal var isBottomVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationWithBackButton()
        
        scrollView.delegate = self
        
        addBottomButtons()
        updateView()
        
        self.view.addSwipeGestureRecognizer {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configure(todoCard: TodoCard) {
        self.todoCard = todoCard
    }
    
    private func updateView() {
        if let imageUri = todoCard.imageUri {
            if let url = URL(string: imageUri) {
                cardImage.af_setImage(withURL: url)
            }
        }
    
        if let message = todoCard.message {
            recommendedLabel.text = message
        }
    
        scheduleLabel.text = formatDate(date: todoCard.updateDate)
    
        if let url = todoCard.blogUrl {
            blogUrl.text = url
        }
    
        if let title = todoCard.blogTitle {
            titleBlogLabel.text = title
        }
    
        if let message = todoCard.message {
            blogMessage.text = message
        }
        
        displayContainerBtnsIfNeeded()
    }
    
    private func setupNavigationWithBackButton() {
        let titleWindow = "Social Post"
        
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
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addBottomButtons() {
        
        containerView.addSubview(buttonContainerView)
        
        //buttonContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bottomContainerViewBottomAnchor = buttonContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
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
        
        separatorView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor, constant: 0).isActive = true
        separatorView.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: buttonContainerView.rightAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        denyPostBtn.addTarget(self, action: #selector(denyPost(sender:)), for: .touchUpInside)
        approvePostBtn.addTarget(self, action: #selector(approvePost(sender:)), for: .touchUpInside)
    }
    
    @objc func denyPost(sender: Any) {
        
    }
    
    @objc func approvePost(sender: AnyObject) {
        
    }
    
    func formatDate(date: Date) -> String {
        
        let dateFormater = DateFormatter()
        var days: String = ""
        var hour: String = ""
        var fullDate: String = ""
        
        dateFormater.dateFormat = "MM/dd"
        dateFormater.pmSymbol = "p.m"
        days = dateFormater.string(from: date)
        
        dateFormater.dateFormat = "h:mm a"
        dateFormater.amSymbol = "a.m"
        hour = dateFormater.string(from: date)
        
        
        fullDate = "\(days) @ \(hour)"
        return fullDate
        
    }
    
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
    @objc optional func denyPostFromSocial(post: TodoCard, indexPath: IndexPath)
    @objc optional func cancelPostFromSocial(post: CalendarSocialPost, indexPath: IndexPath)
    @objc optional func approvePostFromSocial(post: TodoSocialPost, indexPath: IndexPath)
}

