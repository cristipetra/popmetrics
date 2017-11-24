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
        label.text = "Impact"
        label.font = UIFont(name: FontBook.semibold, size: 15)
        label.textAlignment = .left
        label.textColor = PopmetricsColor.textGrey
        return label
        
    }()
    
    private lazy var impactScoreLbl : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+13"
        label.font = UIFont(name: FontBook.semibold, size: 15)
        label.textAlignment = .left
        label.textColor = PopmetricsColor.calendarCompleteGreen
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
    
    private func setup() {
        
        addTitle()
        addImpactScores()
    }
    
    private func addTitle() {
        self.addSubview(titleView)
        
        titleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        self.titleView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    private func addImpactScores() {
        self.addSubview(impactScoreLbl)
        
        impactScoreLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 105).isActive = true
        impactScoreLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        
        self.addSubview(progress)
        progress.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        progress.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        progress.heightAnchor.constraint(equalToConstant: 10).isActive = true
        progress.widthAnchor.constraint(equalToConstant: 179).isActive = true
    
    }
    
    internal func setProgress(_ value: CGFloat) {
        self.progress.animateTo(progress: value)
    }
}
