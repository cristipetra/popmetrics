//
//  Markdown.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import markymark

class Markdown {
    
    func addMarkInScrollView(containerMark: UIView, markdownString: String) {
        //MarkyMark
        let markyMark = MarkyMark(build: {
            $0.setFlavor(ContentfulFlavor())
        })
        
        let markDownItems = markyMark.parseMarkDown(markdownString)
        
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
        containerMark.addSubview(scrollView)
        scrollView.addSubview(markDownView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: containerMark.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: containerMark.rightAnchor, constant: 00).isActive = true
        scrollView.topAnchor.constraint(equalTo: containerMark.topAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: containerMark.bottomAnchor, constant: 0).isActive = true
        
        markDownView.translatesAutoresizingMaskIntoConstraints = false
        markDownView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        NSLayoutConstraint(item: markDownView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        markDownView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        markDownView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        
    }
    
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
