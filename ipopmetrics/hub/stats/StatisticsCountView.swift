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
    
    func setupViews(data: [StatsMetric]) {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
 
        let labelY = 35 as CGFloat
        var wrapperViewY = 0 as CGFloat
        let messageLabelWidth = UIScreen.main.bounds.width / 2
        let rightLabelsWidth = 75 as CGFloat
        let deltaLabelX = UIScreen.main.bounds.width - 20 - rightLabelsWidth
        for row in 0 ..< data.count  {
            let wrapperView = UIView(frame: CGRect(x: 0, y: wrapperViewY, width: UIScreen.main.bounds.width, height: 94))
            let messageLabel = UILabel(frame: CGRect(x: 13, y: labelY, width: messageLabelWidth, height: 20))
            let valueLabel = UILabel(frame: CGRect(x: deltaLabelX - rightLabelsWidth - 20, y: labelY - 5, width: rightLabelsWidth, height: 30))
            let deltaLabel = UILabel(frame: CGRect(x: deltaLabelX - 20, y: labelY - 5, width: rightLabelsWidth, height: 30))
            valueLabel.textAlignment = .left
            deltaLabel.textAlignment = .left
            let messageLabelText = "\(data[row].label)"
            messageLabel.text = messageLabelText
            messageLabel.font = UIFont(name: "OpenSans", size: 15)
            messageLabel.textColor = PopmetricsColor.darkGrey
            
            var valueLabelText = (data[row].valueFormatted != "") ? data[row].valueFormatted : "\(Int(data[row].value))"
            valueLabel.text = valueLabelText
            valueLabel.textAlignment = .center
            valueLabel.font = UIFont(name: "OpenSans-Extrabold", size: 22)
            valueLabel.textColor = PopmetricsColor.darkGrey

            deltaLabel.font = UIFont(name: "OpenSans-Extrabold", size: 22)
            deltaLabel.textColor = data[row].delta < 0 ? PopmetricsColor.salmondColor : PopmetricsColor.calendarCompleteGreen
            
            deltaLabel.textAlignment = .right
            let deltalabelText = "+\(Int(data[row].delta))"
            var deltaPercentage = 0 as Float
            
            deltaPercentage =  (data[row].delta * 100) / ( data[row].value )            
            
            deltaLabel.text =  deltaPercentage < 0 ? "\(Int(deltaPercentage))%" : "+\(Int(deltaPercentage))%"
    
            
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


