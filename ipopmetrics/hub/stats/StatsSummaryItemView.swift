//
//  StatsSummaryItemView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/01/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class StatsSummaryItemView: UIView {
    
    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: FontBook.regular, size: 15)
        label.textAlignment = .left
        label.textColor = PopmetricsColor.darkGrey
        return label
        
    }()
    
    private lazy var valueLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: FontBook.extraBold, size: 22)
        label.textAlignment = .center
        label.textColor = PopmetricsColor.darkGrey
        return label
        
    }()
    
    private lazy var deltaLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont(name: FontBook.extraBold, size: 22)
        label.textAlignment = .right
        label.textColor = PopmetricsColor.darkGrey
        return label
        
    }()
    
    private lazy var dividerLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PopmetricsColor.weekDaysGrey
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        self.heightAnchor.constraint(equalToConstant: 94).isActive = true
        
        messageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        messageLabel.numberOfLines = 2
        
        if UIScreen.main.bounds.size.width < 375 {
            messageLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        } else {
            messageLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        }
        
        deltaLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        deltaLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        deltaLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        valueLabel.rightAnchor.constraint(equalTo: self.deltaLabel.leftAnchor, constant: 10).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        valueLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true

        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLineView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        dividerLineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        dividerLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupView() {
        self.addSubview(messageLabel)
        self.addSubview(valueLabel)
        self.addSubview(deltaLabel)
        self.addSubview(dividerLineView)
    }

    internal func setValue(statsMetric: StatsMetric) {
        messageLabel.text = statsMetric.label
    
        let valueLabelText = (statsMetric.valueFormatted != "") ? statsMetric.valueFormatted : "\(Int(statsMetric.value))"
        valueLabel.text = valueLabelText
        
        if statsMetric.valueFormatted != "" {
            if statsMetric.valueFormatted.count == 8 {
                setValueTime(statsMetric)
                return
            }
        }
        
        var deltaPercentage = 0 as Float
        if statsMetric.value != 0 {
            deltaPercentage =  (statsMetric.delta * 100) / ( statsMetric.value )
        }
        
        deltaLabel.text =  deltaPercentage < 0 ? "\(Int(deltaPercentage))%" : "+\(Int(deltaPercentage))%"
        
        deltaLabel.textColor = statsMetric.delta < 0 ? PopmetricsColor.salmondColor : PopmetricsColor.calendarCompleteGreen
        
    }
    
    private func setValueTime(_ statsMetric: StatsMetric) {
        let valueLabelText = (statsMetric.valueFormatted != "") ? statsMetric.valueFormatted : "\(Int(statsMetric.value))"
        valueLabel.text = parseTime(time: statsMetric.valueFormatted)
        
        var deltaPercentage = 0 as Float
       
        deltaPercentage =  (statsMetric.delta)
       
        deltaLabel.text =  deltaPercentage < 0 ? "\(Int(deltaPercentage))%" : "+\(Int(deltaPercentage))%"
        deltaLabel.textColor = statsMetric.delta < 0 ? PopmetricsColor.salmondColor : PopmetricsColor.calendarCompleteGreen
    }
    
    private func parseTime(time: String) -> String {
        if time.count == 8 { //format 00:00:00
            return time.subString(startIndex: 3, endIndex: time.count-1)
        }
        return time
    }
    
}

extension String {
    func subString(startIndex: Int, endIndex: Int) -> String {
        let end = (endIndex - self.count) + 1
        let indexStartOfText = self.index(self.startIndex, offsetBy: startIndex)
        let indexEndOfText = self.index(self.endIndex, offsetBy: end)
        let substring = self[indexStartOfText..<indexEndOfText]
        return String(substring)
    }
}
