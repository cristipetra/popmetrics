//
//  TrafficStatsTableViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController

class TrafficStatsTableViewController: UITableViewController {
    
    var statisticsStore = StatisticsStore.getInstance()
    
    var reloadGraphDelegate: ReloadGraphProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func configure(card: StatisticsCard) {

    }
    
    internal func registerCellForTable() {
        tableView.register(TrafficVisits.self, forHeaderFooterViewReuseIdentifier: "trafficVisits")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statisticsStore.getStatisticMetricsForCard(statisticsStore.getStatisticsCards()[0]).count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "trafficVisits", for: indexPath)
        let cell = UITableViewCell()
        let traffic = TrafficVisits()
        
        let rowIdx = indexPath.row
        
        traffic.configure(statisticMetric: statisticsStore.getStatisticMetricsForCard(statisticsStore.getStatisticsCards()[0])[rowIdx])
        
        cell.addSubview(traffic)
        
        traffic.translatesAutoresizingMaskIntoConstraints = false
        traffic.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
        traffic.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
        traffic.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: 0).isActive = true
        
        cell.selectionStyle = .none

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        
        NotificationCenter.default.post(name: Notification.Popmetrics.ReloadGraph, object: [indexPath.row])
        
        
        if reloadGraphDelegate != nil {
            reloadGraphDelegate.reloadGraph(statisticMetric: statisticsStore.getStatisticMetricsForCard(statisticsStore.getStatisticsCards()[0])[indexPath.row])
        }
    }
    
    
    private func setUpProgressGradient(toView: UIView) {
        let firstProgressViewGradient : [UIColor] = [UIColor(red: 196/255, green: 13/255, blue: 72/255, alpha: 1), UIColor(red: 192/255, green: 21/255, blue: 46/255, alpha: 1) ]
        let secondProgressViewGradient : [UIColor] = [UIColor(red: 255/255, green: 34/255, blue: 105/255, alpha: 1), UIColor(red: 255/255, green: 27/255, blue: 192/255, alpha: 1) ]

        setGradiendForProgressView(view: toView, leftColor: firstProgressViewGradient[0], rightColor: firstProgressViewGradient[1])
    }
    
    
    func setGradiendForProgressView(view: UIView, leftColor : UIColor , rightColor: UIColor) {
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }

   
}
