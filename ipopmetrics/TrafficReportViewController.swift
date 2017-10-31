//
//  TrafficReportViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TrafficReportViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var containerView: UIView!

    let statsPageVC: StatsPageViewController = StatsPageViewController()
    
    internal var statisticsCard: StatisticsCard! {
        didSet {
            self.statsPageVC.statisticsCard = statisticsCard
            self.statsPageVC.numberOfPages = StatisticsStore.getInstance().getNumberOfPages(statisticsCard)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()

        addPageView()
    }
    
    func configure(statisticsCard: StatisticsCard) {
        self.statisticsCard = statisticsCard;
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width:self.scrollView.contentSize.width, height: self.containerView.frame.height)
    }
    
    func addPageView() {
        addChildViewController(statsPageVC)
        self.containerView.addSubview(statsPageVC.view)
        statsPageVC.didMove(toParentViewController: self)
        
        
        statsPageVC.view.translatesAutoresizingMaskIntoConstraints = false
        statsPageVC.view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        statsPageVC.view.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        //statsPageVC.view.topAnchor.constraint(equalTo: chartVC.view.bottomAnchor,constant: 1).isActive = true
        statsPageVC.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        statsPageVC.view.heightAnchor.constraint(equalToConstant: 778).isActive = true
        
        statsPageVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
    }
    
    func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Traffic Report", style: .plain, target: self, action: nil)
        text.tintColor = PopmetricsColor.darkGrey

        let titleFont = UIFont(name: FontBook.bold, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false

        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "iconCalLeftBold"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black

        
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    

}
