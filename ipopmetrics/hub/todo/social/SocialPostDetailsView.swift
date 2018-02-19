//
//  SocialPostDetailsView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 24/01/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class SocialPostDetailsView: UIView {
    
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var titleBlogLabel: UILabel!
    @IBOutlet weak var blogMessage: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var articleUrl: UILabel!
    @IBOutlet weak var socialBrand: UILabel!
    @IBOutlet weak var scheduleInfoLabel: UILabel!
    @IBOutlet weak var socialIcon: SocialIconView!
    
    @IBOutlet weak var messageFacebook: UITextView!
    private var initMessageText = "Say something about this on Facebook…"

    private var calendarSocialPost: CalendarSocialPost!
    private var todoSocialPost: TodoSocialPost!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {

    }
    
    private func cleanView() {
        //socialBrand.text =  ""
    }
    
    internal func configure(calendarSocialPost: CalendarSocialPost) {
        self.calendarSocialPost = calendarSocialPost
        cleanView()
        updateViewCalendar()
    }
    
    internal func configure(todoSocialPost: TodoSocialPost) {
        self.todoSocialPost = todoSocialPost
        cleanView()
        updateViewTodo()
    }
    
    internal func updateViewTodo() {
        if todoSocialPost == nil { return }
        if let imageUri = todoSocialPost.articleImage {
            if imageUri.isValidUrl() {
                cardImage.af_setImage(withURL: URL(string: imageUri)!)
            }
        }
        
        articleUrl.text = todoSocialPost.articleUrl
        
        if todoSocialPost.type == "twitter" {
            updateTwitter()
            if let name = UserStore.currentBrand?.twitterDetails?.name {
                socialBrand.text =  "@\(name)"
            }
        } else if todoSocialPost.type == "facebook" {
            updateFacebook()
        }
        
        if let title = todoSocialPost.articleTitle {
            titleBlogLabel.text = "\"\(title)\""
        }
        
        blogMessage.text  = todoSocialPost.articleText
        
    }
    
    internal func updateViewCalendar() {
        if let imageUrl = calendarSocialPost.image {
            if imageUrl.isValidUrl() {
                cardImage.af_setImage(withURL: URL(string: imageUrl)!)
            }
        }
        
        articleUrl.text = calendarSocialPost.url
        
        if calendarSocialPost.type == "twitter" {
            recommendedLabel.text = calendarSocialPost.text
            if let name = UserStore.currentBrand?.twitterDetails?.name {
                socialBrand.text =  "@\(name)"
            }
        } else if calendarSocialPost.type == "facebook" {
            updateFacebook()
        }
        
        socialIcon.socialType = calendarSocialPost.type
        
        if let title = calendarSocialPost.title {
            titleBlogLabel.text = "\"\(title)\""
        }
        
        blogMessage.text  = calendarSocialPost.text
        
        if scheduleInfoLabel != nil {
            guard let scheduledDate = calendarSocialPost.scheduledDate else { return }
            scheduleInfoLabel.text = "Scheduled for \(scheduledDate.formatDateForSocial())"
        }
        
    }
    
    internal func isMessageFacebookSet() -> Bool {
        if messageFacebook.text == "" || messageFacebook.text == initMessageText {
            return false
        }
        return true
    }
    
    
    private func updateTwitter() {
        if recommendedLabel != nil {
            recommendedLabel.text = todoSocialPost.articleText
        }
    }
    
    private func updateFacebook() {
        if messageFacebook != nil {
            messageFacebook.translatesAutoresizingMaskIntoConstraints = false
            messageFacebook.isScrollEnabled = false
            messageFacebook.delegate = self
        }
        if socialBrand != nil {
            socialBrand.text = UserStore.currentBrand?.facebookDetails?.name ?? "Business Name"
        }
        
    }
    
    
}

extension SocialPostDetailsView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == messageFacebook {
            if textView.text == initMessageText {
                textView.text = ""
                textView.textColor = PopmetricsColor.borderButton
            }
        }
    }
}
