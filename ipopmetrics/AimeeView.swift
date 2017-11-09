//
//  AimeeView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 29/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class AimeeView: UIView {
    var numberOfRows: Int = 2 {
        didSet {
            self.setupViews(numberOfRows: self.numberOfRows)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews(numberOfRows: numberOfRows)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews(numberOfRows: numberOfRows)
    }
    
    func setupViews(numberOfRows: Int) {
        self.backgroundColor = UIColor.white
        let labelY = 17 as CGFloat
        var wrapperViewY = 7 as CGFloat
        let divider = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5))
        divider.backgroundColor = PopmetricsColor.weekDaysGrey
        self.addSubview(divider)
        for _ in 0 ..< numberOfRows  {
            let wrapperView = UIView(frame: CGRect(x: 0, y: wrapperViewY, width: self.frame.width, height: 60))
            let listItem = UIView(frame: CGRect(x: 10, y: labelY, width: 15, height: 15))
            listItem.layer.cornerRadius = listItem.frame.height / 2
            
            let label = UILabel(frame: CGRect(x: listItem.frame.origin.x + 30, y: labelY - 5, width: self.frame.width - 45, height: 40))
            label.textAlignment = .right
            listItem.backgroundColor = PopmetricsColor.yellowBGColor
            let rightLabelText = "Aimee’s view is this point to support the data presented above."
            label.text = rightLabelText
            label.adjustLabelSpacing(spacing: 0, lineHeight: 20, letterSpacing: 0.3)
            label.font = UIFont(name: "OpenSans", size: 15)
            label.textColor = PopmetricsColor.darkGrey
            wrapperView.addSubview(listItem)
            wrapperView.addSubview(label)
            wrapperViewY += wrapperView.frame.height
            self.addSubview(wrapperView)
        }
    }
    
}
