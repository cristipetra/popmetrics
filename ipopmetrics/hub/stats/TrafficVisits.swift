//
//  TrafficVisits.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import GTProgressBar

class TrafficVisits: UITableViewCell {
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var firstValueLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var secondValueLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var containerProgressView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var deltaProgress: GTProgressBar = {
        let progress = GTProgressBar()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.barBackgroundColor = PopmetricsColor.statisticsTableBackground
        progress.barBackgroundColor = .clear
        progress.barFillColor = PopmetricsColor.secondGray
        progress.barBorderWidth = 0
        progress.barFillInset = 0
        progress.barBorderColor = PopmetricsColor.secondGray
        progress.displayLabel = false
        progress.cornerRadius = 0
        progress.animateTo(progress: 0.0)
        return progress
    }()
    
    lazy var valueProgress: GTProgressBar = {
       let second = GTProgressBar()
        second.translatesAutoresizingMaskIntoConstraints = false
        second.barBackgroundColor = PopmetricsColor.statisticsTableBackground
        second.barBackgroundColor = .clear
        second.barFillColor = PopmetricsColor.textGrey
        second.barBorderWidth = 0
        second.barFillInset = 0
        second.barBorderColor = PopmetricsColor.textGrey
        second.displayLabel = false
        second.cornerRadius = 0
        second.animateTo(progress: 0.0)
        return second
    }()
    
    var statisticMetric: StatisticMetric!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.white
        
        self.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        titleLabel.text = ""
        titleLabel.font = UIFont(name: FontBook.regular, size: 15)
        titleLabel.textColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)
        titleLabel.textAlignment = .left
        
        self.addSubview(firstValueLabel)
        //firstValueLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 2).isActive = true
        firstValueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        firstValueLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        self.addSubview(secondValueLabel)
        secondValueLabel.leftAnchor.constraint(equalTo: firstValueLabel.rightAnchor, constant: 20).isActive = true
        secondValueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        secondValueLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        secondValueLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -21).isActive = true
        
        self.addSubview(containerProgressView)
        containerProgressView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        containerProgressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13).isActive = true
        containerProgressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -21).isActive = true
        containerProgressView.heightAnchor.constraint(equalToConstant: 19).isActive = true
        containerProgressView.backgroundColor = PopmetricsColor.statisticsTableBackground
        
        containerProgressView.addSubview(deltaProgress)
        deltaProgress.bottomAnchor.constraint(equalTo: self.containerProgressView.bottomAnchor, constant: 0).isActive  = true
        deltaProgress.topAnchor.constraint(equalTo: self.containerProgressView.topAnchor, constant: 0).isActive  = true
        deltaProgress.leftAnchor.constraint(equalTo: self.containerProgressView.leftAnchor, constant: 0).isActive = true
        deltaProgress.rightAnchor.constraint(equalTo: self.containerProgressView.rightAnchor, constant: 0).isActive = true
        
        
        containerProgressView.addSubview(valueProgress)
        valueProgress.bottomAnchor.constraint(equalTo: self.containerProgressView.bottomAnchor, constant: 0).isActive  = true
        valueProgress.topAnchor.constraint(equalTo: self.containerProgressView.topAnchor, constant: 0).isActive  = true
        valueProgress.leftAnchor.constraint(equalTo: self.containerProgressView.leftAnchor, constant: 0).isActive = true
        valueProgress.rightAnchor.constraint(equalTo: self.containerProgressView.rightAnchor, constant: 0).isActive = true
 
        
        updateViews()
        
    }
    
    private func updateViews() {
        firstValueLabel.font = UIFont(name: FontBook.extraBold, size: 18)
        firstValueLabel.textColor = PopmetricsColor.visitFirstColor
        firstValueLabel.textAlignment = .left
        
        secondValueLabel.font = UIFont(name: FontBook.extraBold, size: 18)
        secondValueLabel.textColor = PopmetricsColor.visitSecondColor
        secondValueLabel.textAlignment = .left
        
        containerProgressView.layer.cornerRadius = 10
        containerProgressView.clipsToBounds = true
    }
    
    func configure(metricBreakdown: MetricBreakdown, statisticMetric: StatisticMetric) {
        self.statisticMetric = statisticMetric
        
        self.titleLabel.text = metricBreakdown.label
        self.firstValueLabel.text = "\(Int(metricBreakdown.currentValue!))"
        self.secondValueLabel.text = " +\(Int(metricBreakdown.deltaValue!))%"
    
        let maximumValue = statisticMetric.value + (statisticMetric.value * (statisticMetric.delta / Float(100) ))
    
        let percentageCurrentValue = (metricBreakdown.currentValue! * 100) / maximumValue
        
        var percentageDelta = ( metricBreakdown.currentValue! + (metricBreakdown.currentValue! * ( metricBreakdown.deltaValue! / Float(100) ) ) ) / maximumValue
        
        
        self.valueProgress.animateTo(progress: CGFloat(percentageCurrentValue / 100))
        self.deltaProgress.animateTo(progress: CGFloat(percentageDelta))
        
    }
    
    func getNumberByDeltaPercentage(currentValue: Float, delta: Float) -> Float {
        return currentValue + ( currentValue * (delta / 100) )
    }
    
    func configure(statisticMetric: StatisticMetric) {
        self.statisticMetric = statisticMetric
        self.titleLabel.text = statisticMetric.label
        self.firstValueLabel.text = "\(Int(statisticMetric.value))"
        self.secondValueLabel.text = " +\(Int(statisticMetric.delta))"
        
    }
  
}
