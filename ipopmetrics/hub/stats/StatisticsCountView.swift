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
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {

    }

    func setupViews(data: [StatsMetric]) {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        for row in 0 ..< data.count  {
            let view: StatsSummaryItemView = StatsSummaryItemView()
            self.addSubview(view)

            view.translatesAutoresizingMaskIntoConstraints = false
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: (CGFloat(94 * row))).isActive = true
            view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            
            view.setValue(statsMetric: data[row])
        }
    }
    
}
