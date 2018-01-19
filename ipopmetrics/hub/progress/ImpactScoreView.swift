//
//  ImpactScoreView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 24/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import GTProgressBar

@IBDesignable
class ImpactScoreView: UIView {
    
    private lazy var titleView : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Impact Score"
        label.font = UIFont(name: FontBook.semibold, size: 15)
        label.textAlignment = .left
        label.textColor = PopmetricsColor.textGrey
        return label
        
    }()
    
    private lazy var impactScoreLbl : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: FontBook.extraBold, size: 15)
        label.textAlignment = .right
        label.textColor = PopmetricsColor.borderButton
        return label
    }()
    
    private lazy var progress: GTProgressBar = {
        let progressBar = GTProgressBar()
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.barBackgroundColor = PopmetricsColor.barBackground
        progressBar.barFillColor = PopmetricsColor.calendarCompleteGreen
        progressBar.barBorderWidth = 0
        progressBar.barFillInset = 0
        progressBar.barBorderColor = PopmetricsColor.calendarCompleteGreen
        progressBar.displayLabel = false
        progressBar.cornerRadius = 5
        progressBar.progress = 0
        return progressBar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup()
    }
    
    override func layoutSubviews() {
        
        titleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        self.titleView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        let constraintScoreLbl = impactScoreLbl.leftAnchor.constraint(equalTo: self.titleView.rightAnchor, constant: 10)
        constraintScoreLbl.isActive = true
        impactScoreLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        //impactScoreLbl.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        impactScoreLbl.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        progress.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        progress.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let constraintProgressWidthAnchor: NSLayoutConstraint = progress.widthAnchor.constraint(equalToConstant: 179)
        constraintProgressWidthAnchor.priority = UILayoutPriority.defaultLow
        constraintProgressWidthAnchor.isActive = true
        
        impactScoreLbl.rightAnchor.constraint(equalTo: progress.leftAnchor, constant: -10).isActive = true
    }
    
    private func setup() {
        addElements()
    }
    
    private func addElements() {
        //text left
        self.addSubview(titleView)
        
        //impact score lbl
        self.addSubview(impactScoreLbl)
        
        //progress bar
        self.addSubview(progress)
    }
    
    internal func setProgress(_ value: CGFloat) {
        self.progress.animateTo(progress: value)
        setScore(value)
    }
    
    internal func setTitle(_ title: String) {
        self.titleView.text = title
    }
    
    internal func setScore(_ value: CGFloat) {
        let no = Int(value * 100)
        self.impactScoreLbl.text = "+\(no)"
    }
    
    internal func setProgressPercentage(_ value: CGFloat) {
        self.progress.animateTo(progress: value)
        self.setPercentage(value)
    }
    
    private func setPercentage(_ value: CGFloat) {
        let no = Int(value * 100)
        self.impactScoreLbl.text = "\(no)%"
    }
}
