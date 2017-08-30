//
//  TrafficStatusView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TrafficStatusView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var uniqueVisitorsView: TrafficVisits!
    @IBOutlet weak var newVisitsView: TrafficVisits!
    @IBOutlet weak var popmetricVisitsView: TrafficVisits!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var leftArrowBtn: UIButton!
    @IBOutlet weak var rightArrowBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topPageControl: UIPageControl!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        Bundle.main.loadNibNamed("TrafficStatusView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //contentView.backgroundColor = UIColor.darkGray
        
        topPageControl.tintColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        topPageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)
        
        pageControl.tintColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)
        
    }
    
}
