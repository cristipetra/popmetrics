//
//  StatsSlideViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatsSlideViewController: UIViewController {

    //var statusView: TrafficStatusView = TrafficStatusView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    var statusView: TrafficStatus = TrafficStatus(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    var statistiscCard: StatisticsCard!
    
    var indexOfPage = 0 {
        didSet {
            self.statusView.pageControl.currentPage = indexOfPage
            if(statistiscCard != nil) {
                configure(card: statistiscCard)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(statusView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configure(card: StatisticsCard) {
        self.statistiscCard = card
        
        statusView.configure(card: statistiscCard)
        setUpStats()
    }
    
    func setUpStats() {
        self.statusView.statusLabel.text = "Stats 1 of 3"
        
        /*
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
        */
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpProgressGradient()
    }
    
    private func setUpProgressGradient() {
    
        let firstProgressViewGradient : [UIColor] = [UIColor(red: 196/255, green: 13/255, blue: 72/255, alpha: 1), UIColor(red: 192/255, green: 21/255, blue: 46/255, alpha: 1) ]
        let secondProgressViewGradient : [UIColor] = [UIColor(red: 255/255, green: 34/255, blue: 105/255, alpha: 1), UIColor(red: 255/255, green: 27/255, blue: 192/255, alpha: 1) ]
        /*
        if indexOfPage == 0 {
            setGradiendForProgressView(view: self.statusView.popmetricVisitsView.firstProgressView, leftColor: firstProgressViewGradient[0], rightColor: firstProgressViewGradient[1])
            setGradiendForProgressView(view: self.statusView.popmetricVisitsView.secondProgressView, leftColor: secondProgressViewGradient[0], rightColor: secondProgressViewGradient[1])
        }
        
        setGradiendForProgressView(view: self.statusView.newVisitsView.firstProgressView, leftColor: firstProgressViewGradient[0], rightColor: firstProgressViewGradient[1])
        setGradiendForProgressView(view: self.statusView.newVisitsView.secondProgressView, leftColor: secondProgressViewGradient[0], rightColor: secondProgressViewGradient[1])
        
        setGradiendForProgressView(view: self.statusView.uniqueVisitorsView.firstProgressView, leftColor: firstProgressViewGradient[0], rightColor: firstProgressViewGradient[1])
        setGradiendForProgressView(view: self.statusView.uniqueVisitorsView.secondProgressView, leftColor: secondProgressViewGradient[0], rightColor: secondProgressViewGradient[1])
        */
        //setGradiendForProgressView(view: self.statusView, leftColor: firstProgressViewGradient[0], rightColor: firstProgressViewGradient[1])
        
    }
    
    func setGradiendForProgressView(view: UIView,leftColor : UIColor , rightColor: UIColor) {
        let gradientLayer  = CAGradientLayer()
    
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        DispatchQueue.main.async {
            view.layer.addSublayer(gradientLayer)
        }
        
        // MARK: starting the animation
        
        let newBounds = view.bounds.width
        animateLayer(view: view, newBounds: newBounds)
        
    }
    
    func animateLayer(view: UIView, newBounds: CGFloat) {
        
        view.layer.position = CGPoint(x: 0.0, y: 0.0)
        view.layer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        let animation = CABasicAnimation(keyPath: "bounds.size.width")
        
        animation.fromValue = 0
        animation.toValue = newBounds
        animation.fillMode = kCAFillModeForwards
        animation.duration = 1
        
        view.layer.add(animation, forKey: "anim")
    }

    
}

protocol ReloadGraphProtocol {
    func reloadGraph(statisticMetric: StatisticMetric)
}
