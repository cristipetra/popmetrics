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
    
    let store = StatisticsStore.getInstance()
    
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
        
        
        createItemsLocally()
        
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
        
        let sectionHeaderNib = UINib(nibName: "HeaderCardCell", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "headerCell")
        
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
        text.setTitleTextAttributes([NSFontAttributeName: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "Icon_Menu"), style: .plain, target: self, action: #selector(handlerClickMenu))
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    internal func createItemsLocally() {
        try! store.realm.write {
            
            let statsCard = StatisticsCard()
            statsCard.cardId = "dfas"
            statsCard.section = "Traffic"
            statsCard.index = 0
            store.realm.add(statsCard, update: true)
            
            let statsMet1 = StatisticMetric()
            statsMet1.statisticCard = statsCard
            statsMet1.statisticsCardId = "sfdsaf"
            statsMet1.value = 54
            statsMet1.label = "Overral visits"
            statsMet1.pageName = "Overral visits"
            statsMet1.delta = 25
            statsMet1.pageIndex = 1
            statsMet1.indexInPage = 0
            statsMet1.currentPeriodLabel = "Sep28-Aug27"
            statsMet1.currentPeriodValues = "20 23 12 14 1 1 1 1 1 1 6 27 3 4 3 3 7 3 6 7 5 34 4 3 5 3 7 3 6 7 35 34 34 33 35"
            statsMet1.prevPeriodValues = "0 12 12 14 16 17 1 1 1 1 1 1 1 13 14 13 13 17 13 16 17 15 34 14 15 13 14 13 13 17 13 16 17 15 34";
            store.realm.add(statsMet1, update: true)
            
            let statsMet11 = StatisticMetric()
            statsMet11.statisticCard = statsCard
            statsMet11.statisticsCardId = "s3fsadsaf"
            statsMet11.value = 54
            statsMet11.label = "ooo visits"
            statsMet11.delta = 15
            statsMet11.pageName = "qqq visits"
            statsMet11.pageIndex = 1
            statsMet11.indexInPage = 1
            statsMet1.prevPeriodLabel = "fdsa"
            statsMet11.currentPeriodLabel = "Sep28-Aug27"
            statsMet11.currentPeriodValues = "0 12 12 16 14 13 13 17 13 16 17 15 34 14 15 13 6 27 3 4 3 3 7 3 6 7 5"
            statsMet11.prevPeriodValues = "0 23 12 14 6 27 3 4 3 3 7 3 6 7 5 34 4 3 5 14 16 17 13 14 13 13 17"
            store.realm.add(statsMet11, update: true)
            
            let statsMet12 = StatisticMetric()
            statsMet12.statisticCard = statsCard
            statsMet12.statisticsCardId = "s3fsa234dsaf"
            statsMet12.value = 24
            statsMet12.label = "qqq visits"
            statsMet12.delta = 25
            statsMet12.pageName = "qqq visits"
            statsMet12.pageIndex = 1
            statsMet12.indexInPage = 1
            statsMet12.currentPeriodLabel = "Sep28-Aug27"
            statsMet12.currentPeriodValues = "0 12 12 14 16 17 13 14 13 13 17 13 16 17 15 34 14 15 13 6 27 3 4 3 3 7 3 6 7 5"
            statsMet12.prevPeriodValues = "0 23 12 14 6 27 3 4 3 3 7 3 6 7 5 34 4 3 5 14 16 17 13 14 13 13 17"
            store.realm.add(statsMet12, update: true)
            
            let statsMet2 = StatisticMetric()
            statsMet2.statisticCard = statsCard
            statsMet2.statisticsCardId = "s3efdsaf"
            statsMet2.value = 44
            statsMet2.label = "New visits"
            statsMet2.delta = 15
            statsMet2.pageIndex = 2
            statsMet2.pageName = "Unique visits"
            statsMet2.indexInPage = 0
            statsMet2.currentPeriodLabel = "Sep28-Aug27"
            statsMet2.currentPeriodValues = "2 22 12 14 6 27 3 4 3 3 7 3 6 7 5 34 4 3 5 17 13 14 13 13 17 13 6 27 3 4"
            statsMet2.prevPeriodValues = "0 12 12 14 16 17 13 14 13 13 17 13 16 17 15 34 14 15 13 14 16 17 13 14 13 13 17"
            store.realm.add(statsMet2, update: true)
            
            let statsMet21 = StatisticMetric()
            statsMet21.statisticCard = statsCard
            statsMet21.statisticsCardId = "safsfdhgs3efdsaf"
            statsMet21.value = 44
            statsMet21.label = "New old visits"
            statsMet21.delta = 15
            statsMet21.pageIndex = 2
            statsMet21.pageName = "Unique visits"
            statsMet21.indexInPage = 0
            statsMet21.currentPeriodLabel = "Sep28-Aug27"
            statsMet21.currentPeriodValues = "2 22 12 14 6 27 3 4 3 3 7 3 6 7 5 34 4 3 5 17 13 14 13 13 17 13 6 27 3 4"
            statsMet21.prevPeriodValues = "0 12 12 14 16 17 13 14 13 13 17 13 16 17 15 34 14 15 13 14 16 17 13 14 13 13 17"
            store.realm.add(statsMet21, update: true)
        }
        
        
    }
    
    func handlerClickMenu() {
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewNames.SBID_MENU_VC) as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    @objc internal func goToNextTab() {
        self.tabBarController?.selectedIndex = 0
    }
    
    func openTrafficReport(_ sender: AnyObject, card: StatisticsCard) {
        let cardTmp  = StatisticsStore.getInstance().getStatisticsCards()[0]
        let trafficReportVC: TrafficReportViewController = AppStoryboard.Statistics.instance.instantiateViewController(withIdentifier: ViewNames.SBID_TRAFFIC_REPORT) as! TrafficReportViewController
        trafficReportVC.configure(statisticsCard: cardTmp)
        self.navigationController?.pushViewController(trafficReportVC, animated: true)
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //empty card
        if isLastSection(section: indexPath.section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
            cellHeight = 261
            cell.changeTitleWithSpacing(title: "You're all caught up.")
            cell.changeMessageWithSpacing(message: "Find more actions to improve your business tomorrow!")
            cell.selectionStyle = .none
            cell.goToButton.changeTitle("View Home Feed")
            cell.goToButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
            return cell
        }
        
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        let sectionCards = store.getStatisticMetricsForCard(store.getStatisticsCards()[sectionIdx])
        
        if sectionCards.isEmpty {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrafficEmptyCard", for: indexPath) as! TrafficEmptyView
            cellHeight = 216
            cell.selectionStyle = .none
            //cell.footerView.actionButton.addTarget(self, action: #selector(openTrafficReport(_:)), for: .touchUpInside)
            return cell
        }
        
        let card = store.getStatisticsCards()[indexPath.section]
        
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
            cell.footerView.hideButton(button: cell.footerView.xButton)
            cell.connectionLine.isHidden = true
            return cell
        case "insight" :
            if insightIsDisplayed {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedCell", for: indexPath) as! RecommendedCell
                cellHeight = 469
                cell.selectionStyle = .none
                cell.setUpCell(type: "Popmetrics Insight")
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
        return store.getStatisticsCards().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if( isLastSection(section: section)) {
                return nil
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
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
