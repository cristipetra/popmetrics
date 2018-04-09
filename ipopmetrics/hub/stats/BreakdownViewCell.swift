//
//  BreakdownViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import GTProgressBar

class BreakdownViewCell: UITableViewCell {
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: FontBook.regular, size: 15)
        label.textColor = PopmetricsColor.myActionCircle
        label.textAlignment = .left
        return label
    }()
    
    lazy var firstValueLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontBook.bold, size: 18)
        label.textColor = PopmetricsColor.visitFirstColor
        label.textAlignment = .left
        return label
    }()
    
    lazy var secondValueLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontBook.semibold, size: 10)
        label.textColor = PopmetricsColor.calendarCompleteGreen
        label.textAlignment = .right
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
    
    var statisticMetric: StatsMetric!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func layoutSubviews() {
        //Add constraint title
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        //constraints value
        firstValueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        firstValueLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        //constraints percent
        secondValueLabel.leftAnchor.constraint(equalTo: firstValueLabel.rightAnchor, constant: 10).isActive = true
        secondValueLabel.lastBaselineAnchor.constraint(equalTo: firstValueLabel.lastBaselineAnchor).isActive = true
        secondValueLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -21).isActive = true
        //secondValueLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //constraint container progress
        containerProgressView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        containerProgressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13).isActive = true
        containerProgressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        containerProgressView.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        //constraints delta progress
        deltaProgress.bottomAnchor.constraint(equalTo: self.containerProgressView.bottomAnchor, constant: 0).isActive  = true
        deltaProgress.topAnchor.constraint(equalTo: self.containerProgressView.topAnchor, constant: 0).isActive  = true
        deltaProgress.leftAnchor.constraint(equalTo: self.containerProgressView.leftAnchor, constant: 0).isActive = true
        deltaProgress.rightAnchor.constraint(equalTo: self.containerProgressView.rightAnchor, constant: 0).isActive = true
        
        //constraints value progress
        valueProgress.bottomAnchor.constraint(equalTo: self.containerProgressView.bottomAnchor, constant: 0).isActive  = true
        valueProgress.topAnchor.constraint(equalTo: self.containerProgressView.topAnchor, constant: 0).isActive  = true
        valueProgress.leftAnchor.constraint(equalTo: self.containerProgressView.leftAnchor, constant: 0).isActive = true
        valueProgress.rightAnchor.constraint(equalTo: self.containerProgressView.rightAnchor, constant: 0).isActive = true

    }
    
    func setup() {
        self.addSubview(titleLabel)
        
        self.addSubview(firstValueLabel)
        
        self.addSubview(secondValueLabel)
        
        self.addSubview(containerProgressView)
        containerProgressView.backgroundColor = PopmetricsColor.statisticsTableBackground
        
        containerProgressView.addSubview(deltaProgress)
        
        containerProgressView.addSubview(valueProgress)
        
        updateViews()
    }
    
    private func updateViews() {
        containerProgressView.layer.cornerRadius = 10
        containerProgressView.clipsToBounds = true
    }
    
    func configure(metricBreakdown: MetricBreakdown, statisticMetric: StatsMetric) {
        self.statisticMetric = statisticMetric
        
        let metricBreakdownViewModel = MetricBreakdownViewModel(metricBreakdown: metricBreakdown)
        
        self.valueProgress.progress = 0
        
        self.titleLabel.text = metricBreakdown.label
        if metricBreakdown.currentValue != nil {
            self.firstValueLabel.text = "\(Int(metricBreakdown.currentValue!))"
        }
    
        var deltaPercentage = 0 as Float
        var percentageCurrentValue = 0 as Float
        var percentageDelta = 0 as Float
        
        if metricBreakdown.currentValueFormatted != "" {
            self.firstValueLabel.text = metricBreakdown.currentValueFormatted
        }
        
        deltaPercentage = metricBreakdownViewModel.getPercentage()
        
        
        percentageDelta = deltaPercentage
        
        self.secondValueLabel.text =  metricBreakdownViewModel.getPercentageText()
        
        self.secondValueLabel.textColor = metricBreakdownViewModel.getPercentage() < 0 ? PopmetricsColor.salmondColor : PopmetricsColor.calendarCompleteGreen
        
        let value = getValueProgress(value: metricBreakdown.currentValue, maxValue: statisticMetric.value)
        self.valueProgress.animateTo(progress: CGFloat(value))
        
    }
    
    public func getValueProgress(value: Float?, maxValue: Float)  -> Float{
        if maxValue == 0 { return 0 }
        guard let _ = value else { return 0}
        return (value! * 100 / maxValue) / 100

    }
    
    func getNumberByDeltaPercentage(currentValue: Float, delta: Float) -> Float {
        return currentValue + ( currentValue * (delta / 100) )
    }
    
    func configure(statisticMetric: StatsMetric) {
        self.statisticMetric = statisticMetric
        self.titleLabel.text = statisticMetric.label
        self.firstValueLabel.text = "\(Int(statisticMetric.value))"
        self.secondValueLabel.text = " +\(Int(statisticMetric.delta))"
        
    }
  
}


struct  MetricBreakdownViewModel {
    
    var metricBreakdown: MetricBreakdown
    
    internal func colorDelta() -> UIColor {
        return getPercentage() < 0 ? PopmetricsColor.salmondColor : PopmetricsColor.calendarCompleteGreen
    }
    
    internal func getPercentage() -> Float {
        guard let currentValue = metricBreakdown.currentValue else { return 0 }
        guard let _ = metricBreakdown.deltaValue else { return 0 }
        
        if currentValue == 0 {
            return 0
        }
        
        return (self.metricBreakdown.deltaValue! * 100 ) / (self.metricBreakdown.currentValue!)
    }
    
    internal func getPercentageText() -> String {
        let percentage = getPercentage()
        return percentage <= 0 ? "\(Int(percentage))%" : "+\(Int(percentage))%"
    }
}
