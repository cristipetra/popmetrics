//
//  StatsSlideViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatsSlideViewController: UIViewController {

    var statusView: TrafficStatusView = TrafficStatusView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    var indexOfPage = 0 {
        didSet {
            self.statusView.pageControl.currentPage = indexOfPage
            configure()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(statusView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configure() {
        setUpStats()
    }
    
    func setUpStats() {
        
        switch indexOfPage {
        case 0:
            self.statusView.statusLabel.text = "Stats 1 of 3"
            self.statusView.popmetricVisitsView.titleLabel.text = "Popmetrics Visits"
            self.statusView.newVisitsView.titleLabel.text = "New Visits"
            self.statusView.uniqueVisitorsView.titleLabel.text = "Unique Visits"
            self.statusView.uniqueVisitorsView.setProgressValues(doubleValue: false, firstValue: 89, doubleFirst: nil, secondValue: 17, doubleSecond: nil)
            self.statusView.newVisitsView.setProgressValues(doubleValue: false, firstValue: 31, doubleFirst: nil, secondValue: 12, doubleSecond: nil)
            self.statusView.popmetricVisitsView.setProgressValues(doubleValue: false, firstValue: 17, doubleFirst: nil, secondValue: 42, doubleSecond: nil)
            self.statusView.pageControl.currentPage = indexOfPage
            self.statusView.topPageControl.currentPage = indexOfPage
            break
        case 1:
            self.statusView.statusLabel.text = "Stats 2 of 3"
            self.statusView.uniqueVisitorsView.titleLabel.text = "Second on site"
            self.statusView.newVisitsView.titleLabel.text = "Bounce Rate"
            let disquiseView = UIView(frame: CGRect(x: 0, y: 0, width: self.statusView.popmetricVisitsView.frame.width, height: self.statusView.popmetricVisitsView.frame.height + 1))
            disquiseView.backgroundColor = UIColor.white
            self.statusView.popmetricVisitsView.addSubview(disquiseView)
            self.statusView.uniqueVisitorsView.setProgressValues(doubleValue: false, firstValue: 89, doubleFirst: nil, secondValue: 17, doubleSecond: nil)
            self.statusView.newVisitsView.setProgressValues(doubleValue: false, firstValue: 31, doubleFirst: nil, secondValue: 12, doubleSecond: nil)
            
            //self.statusView.popmetricVisitsView.isHidden = true
            self.statusView.pageControl.currentPage = indexOfPage
            self.statusView.topPageControl.currentPage = indexOfPage
            self.statusView.bottomLabel.text = "Engagement"
            break
        case 2:
            self.statusView.statusLabel.text = "Stats 3 of 3"
            self.statusView.uniqueVisitorsView.titleLabel.text = "Male : Female"
            self.statusView.newVisitsView.titleLabel.text = "Mobile : Desktop"
            let disquiseView = UIView(frame: CGRect(x: 0, y: 0, width: self.statusView.popmetricVisitsView.frame.width, height: self.statusView.popmetricVisitsView.frame.height + 1))
            disquiseView.backgroundColor = UIColor.white
            self.statusView.popmetricVisitsView.addSubview(disquiseView)
            self.statusView.uniqueVisitorsView.setProgressValues(doubleValue: true, firstValue: 50, doubleFirst: 50, secondValue: 51, doubleSecond: 49)
            self.statusView.newVisitsView.setProgressValues(doubleValue: true, firstValue: 50, doubleFirst: 50, secondValue: 51, doubleSecond: 49)
            self.statusView.pageControl.currentPage = indexOfPage
            self.statusView.topPageControl.currentPage = indexOfPage
            self.statusView.bottomLabel.text = "Types"
            break
        default:
            break
        }
        
    }
    
}
