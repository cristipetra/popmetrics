//
//  StatisticsCountView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 29/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatisticsCountView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews(data: [StatisticMetric]) {
        let labelY = 35 as CGFloat
        var wrapperViewY = 0 as CGFloat
        let messageLabelWidth = UIScreen.main.bounds.width / 2
        let rightLabelsWidth = 75 as CGFloat
        let deltaLabelX = UIScreen.main.bounds.width - 20 - rightLabelsWidth
        for row in 0 ..< data.count  {
            let wrapperView = UIView(frame: CGRect(x: 0, y: wrapperViewY, width: UIScreen.main.bounds.width, height: 94))
            let messageLabel = UILabel(frame: CGRect(x: 13, y: labelY, width: messageLabelWidth, height: 20))
            let valueLabel = UILabel(frame: CGRect(x: deltaLabelX - rightLabelsWidth - 30, y: labelY - 5, width: rightLabelsWidth, height: 30))
            let deltaLabel = UILabel(frame: CGRect(x: deltaLabelX - 20, y: labelY - 5, width: rightLabelsWidth, height: 30))
            valueLabel.textAlignment = .left
            deltaLabel.textAlignment = .left
            let messageLabelText = "\(data[row].label)"
            messageLabel.text = messageLabelText
            messageLabel.font = UIFont(name: "OpenSans-Semibold", size: 15)
            messageLabel.textColor = PopmetricsColor.darkGrey
            let valueLabelText = "\(Int(data[row].value))"
            valueLabel.text = valueLabelText
            valueLabel.font = UIFont(name: "AlfaSlabOne-Regular", size: 25)
            valueLabel.textColor = PopmetricsColor.darkGrey
            deltaLabel.font = UIFont(name: "AlfaSlabOne-Regular", size: 25)
            deltaLabel.textColor = PopmetricsColor.visitSecondColor
            deltaLabel.textAlignment = .right
            let deltalabelText = "+\(Int(data[row].delta))"
            
            let deltaPercentage =  (data[row].delta * 100) / ( data[row].value + data[row].delta )
            
            deltaLabel.text = "\(Int(deltaPercentage))%"
            
            let divider = UIView(frame: CGRect(x: 0, y: wrapperView.frame.height-1, width: wrapperView.frame.width, height: 1))
            divider.backgroundColor = PopmetricsColor.weekDaysGrey
            wrapperView.addSubview(messageLabel)
            wrapperView.addSubview(valueLabel)
            wrapperView.addSubview(deltaLabel)
            wrapperView.addSubview(divider)
            wrapperViewY += wrapperView.frame.height
            self.addSubview(wrapperView)

        }
    }
}


