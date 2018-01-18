//
//  PeriodGraphDateView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/01/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class PeriodGraphDateView: UIView {
    
    lazy internal var indicatorStartDate: UIView = {
        let view = UIView()
        view.backgroundColor = PopmetricsColor.grayStats
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy internal var startDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = PopmetricsColor.textGrey
        label.font = UIFont(name: FontBook.regular, size: 10)
        label.text = "Jun23"
        return label
    }()
    
    lazy var indicatorEndDate: UIView = {
        let view = UIView()
        view.backgroundColor = PopmetricsColor.grayStats
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy internal var endDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = PopmetricsColor.textGrey
        label.font = UIFont(name: FontBook.regular, size: 10)
        label.text = "July22"
        return label
    }()
    
    override func layoutSubviews() {
        
        indicatorStartDate.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        indicatorStartDate.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        indicatorStartDate.widthAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorStartDate.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        startDateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        startDateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        
        indicatorEndDate.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        indicatorEndDate.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        indicatorEndDate.widthAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorEndDate.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        endDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        endDateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    
    private func setupViews() {
        self.addSubview(indicatorStartDate)
        self.addSubview(startDateLabel)
        
        self.addSubview(indicatorEndDate)
        self.addSubview(endDateLabel)
        
        self.clipsToBounds = true
        self.backgroundColor = .clear
    }
    
    internal func configure(_ statsMetric: StatsMetric) {
        startDateLabel.text = statsMetric.currentPeriodStartDate.toShortString()
        endDateLabel.text = statsMetric.currentPeriodEndDate.toShortString()
    }
    
    
    
}


extension Date {
    func toShortString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
}

