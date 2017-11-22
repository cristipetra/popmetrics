//
//  ActionPageDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import markymark

class ActionPageDetailsViewController: UIViewController {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogSummary: UILabel!
    
    
    @IBOutlet weak var containerIceView: UIView!
    @IBOutlet weak var containerDetailsMarkdown: UIView!
    @IBOutlet weak var containerInsightArguments: UIView!
    
    private var feedCard: FeedCard!
    private var recommendActionHandler: RecommendActionHandler?
    
    let statsView = IndividualTaskView()
    let iceView = IceExtendView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addIceView()
        
        setupNavigationWithBackButton()
        updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addIceView() {
        self.containerIceView.addSubview(iceView)
        
        iceView.translatesAutoresizingMaskIntoConstraints = false
        iceView.topAnchor.constraint(equalTo: self.containerIceView.topAnchor, constant: 0).isActive = true
        iceView.rightAnchor.constraint(equalTo: self.containerIceView.rightAnchor, constant: 0).isActive = true
        iceView.bottomAnchor.constraint(equalTo: self.containerIceView.bottomAnchor, constant: 0).isActive = true
        iceView.leftAnchor.constraint(equalTo: self.containerIceView.leftAnchor, constant: 0).isActive = true
        
    }
    
    public func configure(_ feedCard: FeedCard, handler: RecommendActionHandler? = nil) {
        self.feedCard = feedCard
        print(feedCard)
        recommendActionHandler = handler
        iceView.configure(feedCard)
    }
    
    private func updateView() {
        titleArticle.text = feedCard.headerTitle
        
        if let imageUrl = feedCard.blogImageUrl {
            cardImage.af_setImage(withURL: URL(string: imageUrl)!)
        }
        
        
        
        
        displayMark()
    }
    
    private func setupNavigationWithBackButton() {
        let titleWindow = "Action Page"
        let titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: nil)
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, titleButton]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    
    func getMarkDownString() -> String {
        return feedCard.detailsMarkdown!
    }
    
    internal func displayMark() {
        
        //MarkyMark
        let markyMark = MarkyMark(build: {
            $0.setFlavor(ContentfulFlavor())
        })
        
        let markDownItems = markyMark.parseMarkDown(getMarkDownString())
        
        let converterConfiguration = ConverterConfiguration.attributedString
        
        let markDownView: UIView
        let scrollView: UIScrollView = UIScrollView()
        
        switch converterConfiguration {
        case .view:
            markDownView = getViewWithViewConverter(markDownItems)
        case .attributedString:
            markDownView = getViewWithAttributedStringConverter(markDownItems)
        }
        
        /// Layout
        containerDetailsMarkdown.addSubview(scrollView)
        scrollView.addSubview(markDownView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: self.containerDetailsMarkdown.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.containerDetailsMarkdown.rightAnchor, constant: 00).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.containerDetailsMarkdown.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.containerDetailsMarkdown.bottomAnchor, constant: 0).isActive = true
        
        markDownView.translatesAutoresizingMaskIntoConstraints = false
        markDownView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        NSLayoutConstraint(item: markDownView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        markDownView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        markDownView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
    }
    
    
    @IBAction func handlerViewArticleBtn(_ sender: Any) {
        if let url = feedCard.blogUrl {
            self.openURLInside(url: url)
        }
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ActionPageDetailsViewController {
    
    func getViewWithViewConverter(_ markDownItems: [MarkDownItem]) -> UIView {
        let styling = DefaultStyling()
        
        let configuration = MarkdownToViewConverterConfiguration(styling: styling)
        let converter = MarkDownConverter(configuration: configuration)
        
        return converter.convert(markDownItems)
    }
    
    func getViewWithAttributedStringConverter(_ markDownItems: [MarkDownItem]) -> UIView {
        let styling = DefaultStyling()
        let configuration = MarkDownToAttributedStringConverterConfiguration(styling: styling)
        let converter = MarkDownConverter(configuration: configuration)
        
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.dataDetectorTypes = .link
        textView.attributedText = converter.convert(markDownItems)
        textView.tintColor = styling.linkStyling.textColor
        textView.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        
        textView.backgroundColor = UIColor.clear
        return textView
    }
}

