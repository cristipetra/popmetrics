//
//  InfoCardViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 24/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import markymark

enum ConverterConfiguration {
    case view
    case attributedString
}

class InfoCardViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleTooltip: UILabel!
    
    var typeCard: String = "";
    
    fileprivate var markdownString: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideViewElements()
        updateView()
    }
    
    private func hideViewElements() {
        messageLabel.isHidden = true
        titleTooltip.isHidden = true
    }
    
    func changeCardType(type: String) {
        typeCard = type
    }
    
    func updateView() {
        switch typeCard {
        case "insight":
            titleTooltip.text = "What is a 'Popmetrics Insight'?"
            messageLabel.text = "Consider an insight card as a doorway of opportunity to improve your business. We constantly run tests on areas of your business and wherever we find one of these opportunities, we present the solution as one of these insight cards."
        default:
            messageLabel.text = "Popmetrics needs access to your Twitter account to analyze your account so that we can paint a picture of how strong your online brand is, and how it stacks up against the competition. We can scan the people and businesses that folow your account, and then analyze who follows them. With this information we can better identify the same groups of people you and your competition are marketing towards. Popmetrics also identifies the types of content you and your followers share, like and generally engage with on Twitter. We use this engagement metric to determine the best content to post."
            break
        }
    }
    
    internal func displayMarkInfo(text: String, _ title: String? = nil) {
        markdownString = text
        hideViewElements()
        
        if(title != nil) {
            titleTooltip.isHidden = false
            titleTooltip.text = title
        }
        
        displayMark()
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
        view.addSubview(scrollView)
        scrollView.addSubview(markDownView)
        view.bringSubview(toFront: closeButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 90).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        
        markDownView.translatesAutoresizingMaskIntoConstraints = false
        markDownView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        NSLayoutConstraint(item: markDownView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        markDownView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        markDownView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension InfoCardViewController {
    
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
    
    func getMarkDownString() -> String {
        return markdownString
    }
}
