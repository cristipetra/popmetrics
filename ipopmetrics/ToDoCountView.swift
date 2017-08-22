//
//  ToDoCountView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//


import UIKit

class ToDoCountView: UIView {
    private var _numberOfRows: Int = 2
    var numberOfRows: Int {
        set
        {
            _numberOfRows = newValue
            DispatchQueue.main.async {
                self.setupViews(numberOfRows: newValue)
            }
        }
        get {
            return _numberOfRows
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.setupViews(numberOfRows: numberOfRows)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.setupViews(numberOfRows: numberOfRows)
    }
    
    func setupViews(numberOfRows: Int) {
        let labelY = 17 as CGFloat
        var wrapperViewY = 0 as CGFloat
        let labelWidth = 80 as CGFloat
        for row in 0 ..< numberOfRows  {
            let wrapperView = UIView(frame: CGRect(x: 0, y: wrapperViewY, width: self.frame.width, height: 60))
            let leftLabel = UILabel(frame: CGRect(x: 23, y: labelY, width: labelWidth, height: 20))
            let rightLabel = UILabel(frame: CGRect(x: wrapperView.frame.width - 18 - labelWidth, y: labelY, width: labelWidth, height: 20))
            rightLabel.textAlignment = .right
            let leftLabelText = "\(row) left"
            leftLabel.text = leftLabelText
            leftLabel.font = UIFont(name: "OpenSans-Semibold", size: 16)
            leftLabel.textColor = PopmetricsColor.darkGrey
            let rightLabelText = "\(row) right"
            rightLabel.text = rightLabelText
            rightLabel.font = UIFont(name: "OpenSans-Semibold", size: 12)
            rightLabel.textColor = PopmetricsColor.darkGrey
            let divider = UIView(frame: CGRect(x: 0, y: wrapperView.frame.height, width: wrapperView.frame.width, height: 1))
            divider.backgroundColor = PopmetricsColor.dividerBorder
            wrapperView.addSubview(leftLabel)
            wrapperView.addSubview(rightLabel)
            wrapperView.addSubview(divider)
            wrapperViewY += wrapperView.frame.height
            self.addSubview(wrapperView)
        }
    }
}

