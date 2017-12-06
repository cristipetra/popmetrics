//
//  StatisticsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
import SwiftyJSON

class StatisticsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topAnchorTableView: NSLayoutConstraint!
    @IBOutlet weak var leftAnchorTableView: NSLayoutConstraint!
    
    let transitionView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var statisticsNoteView: NoteView!
    
    let store = StatsStore.getInstance()
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var insightIsDisplayed = false
    var cellHeight = 0 as CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        setUpNavigationBar()
        
        registerCellsForTable()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = PopmetricsColor.statisticsTableBackground
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 57/255.0, green: 67/255.0, blue: 89/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
        
//        createItemsLocally()
        
        self.view.addSubview(transitionView)
        transitionView.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        transitionView.alpha = 0.7
        transitionView.frame.origin.x = 20
    
        UIView.transition(with: tableView, duration: 0.22,
            animations: {
                self.transitionView.frame.origin.x = 0
                self.transitionView.alpha = 1
            }
        )
    }
    
    internal func registerCellsForTable() {
        let trafficNib = UINib(nibName: "TrafficCard", bundle: nil)
        tableView.register(trafficNib, forCellReuseIdentifier: "TrafficCard")
        
        let trafficUnconnectedNib = UINib(nibName: "TrafficEmptyCard", bundle: nil)
        tableView.register(trafficUnconnectedNib, forCellReuseIdentifier: "TrafficEmptyCard")
        
        let sectionHeaderNib = UINib(nibName: "CardHeaderView", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "CardHeaderView")
        
        let cardHeaderCellNib = UINib(nibName: "CardHeaderCell", bundle: nil)
        tableView.register(cardHeaderCellNib, forCellReuseIdentifier: "CardHeaderCell")
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")
        
        let recommendedNib = UINib(nibName: "RecommendedCell", bundle: nil)
        tableView.register(recommendedNib, forCellReuseIdentifier: "RecommendedCell")
    }
    
    func setNoteView() {
        if statisticsNoteView == nil {
            statisticsNoteView = NoteView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 93))
            self.view.addSubview(statisticsNoteView)
            topAnchorTableView.constant = statisticsNoteView.height()
            self.view.updateConstraints()
            statisticsNoteView.setDescriptionText(type: .statistics)
            statisticsNoteView.performActionButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
            
        }
    }
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Statistics", style: .plain, target: self, action: nil)
        text.tintColor = UIColor(red: 67/255, green: 78/255, blue: 84/255, alpha: 1.0)
        let titleFont = UIFont(name: FontBook.regular, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "Icon_Menu"), style: .plain, target: self, action: #selector(handlerClickMenu))
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc func handlerClickMenu() {
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewNames.SBID_MENU_VC) as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    @objc internal func goToNextTab() {
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc func openTrafficReport(_ sender: AnyObject, card: StatisticsCard) {
        let cardTmp  = StatsStore.getInstance().getStatisticsCards()[0]
        let trafficReportVC: TrafficReportViewController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewNames.SBID_TRAFFIC_REPORT) as! TrafficReportViewController
        
        trafficReportVC.configure(statisticsCard: cardTmp)
        self.navigationController?.pushViewController(trafficReportVC, animated: true)
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //empty card
        if isLastSection(section: indexPath.section) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! EmptyStateCardCell
//            cellHeight = 261
//            cell.changeTitleWithSpacing(title: "You're all caught up.")
//            cell.changeMessageWithSpacing(message: "Find more actions to improve your business tomorrow!")
//            cell.selectionStyle = .none
//            cell.goToButton.changeTitle("View Home Feed")
//            cell.goToButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
//            return cell
            let emptyCell = UITableViewCell()
            emptyCell.backgroundColor = .clear
            return emptyCell
        }
        
        let sectionIdx = (indexPath as NSIndexPath).section
        
        let card = store.getStatisticsCards()[sectionIdx]
        let metrics = store.getStatisticMetricsForCard(card)
        if metrics.isEmpty {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrafficEmptyCard", for: indexPath) as! TrafficEmptyView
            cellHeight = 216
            cell.selectionStyle = .none
            //cell.footerView.actionButton.addTarget(self, action: #selector(openTrafficReport(_:)), for: .touchUpInside)
            return cell
        }
        
        switch card.section {
        case "Traffic":
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrafficCard", for: indexPath) as! TrafficCardViewCell
            let results = store.getStatisticMetricsForCard(card)
            cell.statisticsCountView.setupViews(data: Array(results))
            let itemCellHeight: Int = 94
            cell.statisticsCountViewHeightCounstraint.constant = CGFloat(results.count * itemCellHeight)
            cellHeight = CGFloat((results.count * itemCellHeight) + (29 + 93 + 20))
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.feedBackgroundColor()
            cell.footerView.actionButton.addTarget(self, action: #selector(openTrafficReport(_: card:)), for: .touchUpInside)
            //cell.footerView.hideButton(button: cell.footerView.xButton)
            cell.footerView.displayOnlyActionButton()
            cell.connectionLine.isHidden = true
            return cell
        case "insight" :
            if insightIsDisplayed {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedCell", for: indexPath) as! InsightCard
                cellHeight = 469
                cell.selectionStyle = .none
                return cell
            } else {
                let cell = UITableViewCell()
                cellHeight = 0
                cell.isHidden = true
                return cell
            }
        default:
            let cell = UITableViewCell()
            cellHeight = 0
            cell.isHidden = true
            return cell
        }
 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let a = store.getStatisticsCards().count
        return a
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if( isLastSection(section: section)) {
                return nil
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardHeaderCell") as! CardHeaderCell
            cell.changeColor(cardType: .traffic)
            cell.sectionTitleLabel.text = "Traffic";
            return cell
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 80
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func isLastSection(section: Int) -> Bool {
        if section == store.countSections() {
            return true
        }
        return false
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return store.getStatisticsCards().count + 1
    }
    /*
    private func setTrafficCard(cell: TrafficCardViewCell, item: StatisticsItem) {
        if item.status == StatusArticle.unapproved.rawValue {
            insightIsDisplayed = true
            cell.connectionLine.isHidden = false
        } else {
            cellHeight = 404
            cell.connectionLine.isHidden = true
        }
    }
    */
}
