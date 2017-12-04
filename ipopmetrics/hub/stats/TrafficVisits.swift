//
//  TrafficVisits.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

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
    
    lazy var mainProgressView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var firstProgressView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var secondProgressView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    var statisticMetric: StatisticMetric!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpVisitsView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpVisitsView()
    }
    
    func configure(metricBreakdown: MetricBreakdown) {
        
        self.titleLabel.text = metricBreakdown.label
        self.firstValueLabel.text = "\(Int(metricBreakdown.currentValue!))"
        self.secondValueLabel.text = " +\(Int(metricBreakdown.deltaValue!))"
        
        setProgress(firstValue: CGFloat(metricBreakdown.currentValue!), secondValue: CGFloat(metricBreakdown.deltaValue! + metricBreakdown.currentValue!))
    }
    
    func configure(statisticMetric: StatisticMetric) {
        self.statisticMetric = statisticMetric
        self.titleLabel.text = statisticMetric.label
        self.firstValueLabel.text = "\(Int(statisticMetric.value))"
        self.secondValueLabel.text = " +\(Int(statisticMetric.delta))"
        
        setProgress(firstValue: CGFloat(statisticMetric.value), secondValue: CGFloat(statisticMetric.delta + statisticMetric.value))
    }
    
    func setUpVisitsView() {
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
        
        self.addSubview(mainProgressView)
        mainProgressView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        mainProgressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13).isActive = true
        mainProgressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -21).isActive = true
        mainProgressView.heightAnchor.constraint(equalToConstant: 19).isActive = true
        mainProgressView.backgroundColor = PopmetricsColor.statisticsTableBackground
        
        mainProgressView.addSubview(secondProgressView)
        mainProgressView.addSubview(firstProgressView)
        firstProgressView.leftAnchor.constraint(equalTo: mainProgressView.leftAnchor).isActive = true
        firstProgressView.topAnchor.constraint(equalTo: mainProgressView.topAnchor).isActive = true
        firstProgressView.bottomAnchor.constraint(equalTo: mainProgressView.bottomAnchor).isActive = true
        
        secondProgressView.leftAnchor.constraint(equalTo: mainProgressView.leftAnchor).isActive = true
        secondProgressView.topAnchor.constraint(equalTo: mainProgressView.topAnchor).isActive = true
        secondProgressView.bottomAnchor.constraint(equalTo: mainProgressView.bottomAnchor).isActive = true
        
        setDesign()
        
    }
    
    private func setDesign() {
        firstValueLabel.font = UIFont(name: FontBook.extraBold, size: 18)
        firstValueLabel.textColor = PopmetricsColor.visitFirstColor
        firstValueLabel.textAlignment = .left
        
        secondValueLabel.font = UIFont(name: FontBook.extraBold, size: 18)
        secondValueLabel.textColor = PopmetricsColor.visitSecondColor
        secondValueLabel.textAlignment = .left
        
        mainProgressView.layer.cornerRadius = 10
        mainProgressView.clipsToBounds = true
    }
    
    private func setProgress(firstValue: CGFloat, secondValue: CGFloat) {
        
        self.firstProgressView.widthAnchor.constraint(equalToConstant: firstValue).isActive = true

        self.secondProgressView.widthAnchor.constraint(equalToConstant: (secondValue + firstValue)).isActive = true
        
        self.firstProgressView.layer.masksToBounds = true
        self.secondProgressView.layer.masksToBounds = true
        
        firstProgressView.layoutSubviews()
        secondProgressView.layoutSubviews()
        
        firstProgressView.backgroundColor = PopmetricsColor.textGrey
        secondProgressView.backgroundColor = PopmetricsColor.secondGray
        
        DispatchQueue.main.async {
            self.firstProgressView.setNeedsLayout()
            self.secondProgressView.setNeedsLayout()
            
        }
        
        mainProgressView.layoutIfNeeded()
        
    }
    
    func setProgressValues(doubleValue: Bool, firstValue: Int,doubleFirst: Int? ,secondValue: Int, doubleSecond: Int?) {
        
        setProgress(firstValue: CGFloat(firstValue), secondValue: CGFloat(secondValue))
        
        if doubleValue == false {
            firstValueLabel.text = "\(firstValue)"
            secondValueLabel.text = "+\(secondValue)"
            
        } else {
            firstValueLabel.widthAnchor.constraint(equalToConstant: 68).isActive = true
            secondValueLabel.widthAnchor.constraint(equalToConstant: 68).isActive = true
            if let firstDouble = doubleFirst {
                firstValueLabel.text = "\(firstValue):\(firstDouble)"
            }
            
            if let secondDouble = doubleSecond {
                secondValueLabel.text = "\(secondValue):\(secondDouble)"
            }
            
        }
        
        setProgress(firstValue: CGFloat(firstValue), secondValue: CGFloat(secondValue))
        
        firstProgressView.backgroundColor = PopmetricsColor.visitFirstColor
        secondProgressView.backgroundColor = PopmetricsColor.visitSecondColor
        
        firstProgressView.layoutSubviews()
        secondProgressView.layoutSubviews()
        
    }
    
}
