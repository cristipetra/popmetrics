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
        button.setTitleColor(PopmetricsColor.salmondColor, for: .normal)
        button.setTitle("Deny Post", for: .normal)
        return button
    }()
    
    lazy var approvePostBtn: TwoColorButton = {
        let button = TwoColorButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationWithBackButton()
        
        addBottomButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    func configure(socialPost: TodoSocialPost) {
        recommendedLabel.text = socialPost.articleText
        if let title = socialPost.articleTitle {
            titleLabel.text = title
        }
        postUrl.text = socialPost.articleUrl
        
        scheduleTimeLabel.text = formatDate(date: socialPost.updateDate)
        
    }
     */
    
    private func setupNavigationWithBackButton() {
        let titleWindow = "Social Post"
        let titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: nil)
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        
        self.navigationItem.leftBarButtonItems = [leftButtonItem, titleButton]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addBottomButtons() {
        
        containerView.addSubview(buttonContainerView)
        
        buttonContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        buttonContainerView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        buttonContainerView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        buttonContainerView.heightAnchor.constraint(equalToConstant: 61).isActive = true
        
        buttonContainerView.addSubview(denyPostBtn)
        buttonContainerView.addSubview(approvePostBtn)
        buttonContainerView.addSubview(separatorView)
        
        denyPostBtn.leftAnchor.constraint(equalTo: buttonContainerView.leftAnchor, constant: 30).isActive = true
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
        
        //denyPostBtn.addTarget(self, action: #selector(denyPost(sender:)), for: .touchUpInside)
        //approvePostBtn.addTarget(self, action: #selector(approvePost(sender:)), for: .touchUpInside)
        
        buttonContainerView.isHidden = true
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


@objc protocol ActionSocialPostProtocol: class {
    @objc optional func denyPostFromSocial(post: TodoCard, indexPath: IndexPath)
    @objc optional func cancelPostFromSocial(post: CalendarSocialPost, indexPath: IndexPath)
    @objc optional func approvePostFromSocial(post: TodoSocialPost, indexPath: IndexPath)
}

