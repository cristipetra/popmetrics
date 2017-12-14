//
//  StatisticsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh
// import SwiftyJSON

class StatsHubController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topAnchorTableView: NSLayoutConstraint!
    @IBOutlet weak var leftAnchorTableView: NSLayoutConstraint!
    
    let transitionView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var statisticsNoteView: NoteView!
    
    let store = StatsStore.getInstance()
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var insightIsDisplayed = false
    var cellHeight = 0 as CGFloat
    
    var selectedCard: StatisticsCard?
    
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
        
        self.view.addSubview(transitionView)
        transitionView.addSubview(tableView)
        
        // NotificationCenter observers
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Popmetrics.UiRefreshRequired, object:nil, queue:nil, using:catchUiRefreshRequiredNotification)
        
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // old code: self?.fetchItems(silent:false)
            SyncService.getInstance().syncAll(silent: false)
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PopmetricsColor.yellowBGColor)
        tableView.dg_setPullToRefreshBackgroundColor(PopmetricsColor.darkGrey)
        
        
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
        let trafficNib = UINib(nibName: "StatsCard", bundle: nil)
        tableView.register(trafficNib, forCellReuseIdentifier: "StatsCard")
        
        let trafficUnconnectedNib = UINib(nibName: "StatsEmptyCard", bundle: nil)
        tableView.register(trafficUnconnectedNib, forCellReuseIdentifier: "StatsEmptyCard")
        
        let sectionHeaderNib = UINib(nibName: "CardHeaderView", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "CardHeaderView")
        
        let cardHeaderCellNib = UINib(nibName: "CardHeaderCell", bundle: nil)
        tableView.register(cardHeaderCellNib, forCellReuseIdentifier: "CardHeaderCell")
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")
        
        let emptyCard = UINib(nibName: "EmptyStateCard", bundle: nil)
        tableView.register(emptyCard, forCellReuseIdentifier: "EmptyStateCard")
        
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
    
    internal func createItemsLocally() {
        try! store.realm.write {
            /*
            let tmp = StatisticsCard()
            tmp.cardId = "asf23rsdf3r"
            tmp.section = ""
            store.realm.add(tmp, update: true)
            */
            let statsCard = StatisticsCard()
            statsCard.cardId = "dfas"
            statsCard.section = "Traffic"
            
            //store.realm.add(statsCard, update: true)
     
            let statsMet1 = StatisticMetric()
            statsMet1.statisticCard = store.getStatisticsCards()[0]
            statsMet1.statisticsCardId = store.getStatisticsCards()[0].cardId!
            statsMet1.statisticsMetricId = "sadfasfdsa"
            statsMet1.value = 1300
            statsMet1.label = "Overral visits"
            statsMet1.pageName = "Overral visits"
            statsMet1.delta = 250
            statsMet1.pageIndex = 1
            
            statsMet1.currentPeriodLabel = "Sep28-Aug27"
            statsMet1.currentPeriodValues = "20 23 12 14 1 1 1 1 1 1 6 27 3 4 3 3 7 3 6 7 5 34 4 3 5 3 7 3 6 7 35 34 34 33 35"
            statsMet1.prevPeriodValues = "0 12 12 14 16 17 1 1 1 1 1 1 1 13 14 13 13 17 13 16 17 15 34 14 15 13 14 13 13 17 13 16 17 15 34";
            
            statsMet1.breakDownsJson = "[{\"group\": \"Demographics\", \"breakdowns\": [{\"label\": \"Male\", \"current_value\": 1300, \"delta_value\": 250 }]}, {\"group\": \"Devices\", \"breakdowns\" :[{\"label\": \"Mobile\", \"current_value\": 1100, \"delta_value\": 20 }, {\"label\": \"Unknown\", \"current_value\": 200, \"delta_value\": 5 }  ]}]"
            
            store.realm.add(statsMet1, update: true)
            
            print("breakdown: \(statsMet1.getBreakDownGroups())")
           
            let statsMet11 = StatisticMetric()
            statsMet11.statisticCard = store.getStatisticsCards()[0]
            statsMet11.statisticsCardId = store.getStatisticsCards()[0].cardId!
            statsMet11.statisticsMetricId = "sadfasfdasdffdsa"
            statsMet11.value = 4000
            statsMet11.label = "Total visits"
            statsMet11.delta = 450
            statsMet11.pageName = "qqq visits"
            statsMet11.pageIndex = 2
            
            statsMet1.prevPeriodLabel = "fdsa"
            statsMet11.currentPeriodLabel = "Sep28-Aug27"
            statsMet11.currentPeriodValues = "0 12 12 16 14 13 13 17 13 16 17 15 34 14 15 13 6 27 3 4 3 3 7 3 6 7 5 4 5 6 4"
            statsMet11.prevPeriodValues = "0 23 12 14 6 27 3 4 3 3 7 3 6 7 5 34 4 3 5 14 16 17 13 14 13 13 17 14 15 16 17"
            
            statsMet11.breakDownsJson = "[ {\"group\": \"Demographics\", \"breakdowns\": [{\"label\": \"Male\", \"current_value\": 1500, \"delta_value\": 120 }, {\"label\": \"Female\", \"current_value\": 1100, \"delta_value\": 110 }, {\"label\": \"Unknown\", \"current_value\": 1400, \"delta_value\": 220 }]}, {\"group\": \"Devices\", \"breakdowns\" :[{\"label\": \"Mobile\", \"current_value\": 1100, \"delta_value\": 20 },{\"label\": \"Tablet\", \"current_value\": 1100, \"delta_value\": 20 },{\"label\": \"TV\", \"current_value\": 1100, \"delta_value\": 20 }] }  ]"
            
            store.realm.add(statsMet11, update: true)
            
            let statsMet12 = StatisticMetric()
            statsMet12.statisticCard = store.getStatisticsCards()[0]
            statsMet12.statisticsCardId = store.getStatisticsCards()[0].cardId!
            statsMet12.statisticsMetricId = "sadfasfdsasadga"
            statsMet12.value = 1100
            statsMet12.label = "qqq visits"
            statsMet12.delta = 250
            statsMet12.pageName = "qqq visits"
            statsMet12.pageIndex = 3
            
            statsMet12.currentPeriodLabel = "Sep28-Aug27"
            statsMet12.currentPeriodValues = "0 12 12 14 16 17 13 14 13 13 17 13 16 17 15 34 14 15 13 6 27 3 4 3 3 7 3 6 7 5 3"
            statsMet12.prevPeriodValues = "0 23 12 14 6 27 3 4 3 3 7 3 6 7 5 34 4 3 5 14 16 17 13 14 13 13 17 19 19 28 18 18"
            
            statsMet12.breakDownsJson = "[{\"group\": \"Demographics\", \"breakdowns\": [{\"label\": \"Male\", \"current_value\": 1100, \"delta_value\": 25 }] }]"
            
            store.realm.add(statsMet12, update: true)
            
        }
        print(store.getStatisticsCards())
        
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
    
    @objc func openTrafficReport(_ sender: AnyObject, eventInfo: AnyObject) {
        let actionButton = sender as! ActionButton
        
        self.selectedCard = actionButton.context["card"] as! StatisticsCard
        self.performSegue(withIdentifier: "showStatsReport", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showStatsReport" {
            guard let card = self.selectedCard else { return }
            let reportPVC = segue.destination as! StatsReportPageViewController
            reportPVC.statisticsCard = card
        }
    }
    
    func catchUiRefreshRequiredNotification(notification:Notification) -> Void {
            self.tableView.reloadData()
    }

}
    

extension StatsHubController: UITableViewDelegate, UITableViewDataSource {
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
            cellHeight = 0
            emptyCell.backgroundColor = .blue
            return emptyCell
        }
        
        let sectionIdx = (indexPath as NSIndexPath).section
        
        let card = store.getStatisticsCards()[sectionIdx]
        let metrics = store.getStatisticMetricsForCard(card)
        if metrics.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateCard", for: indexPath) as! EmptyStateCard
            cell.displayForStats()
            cellHeight = 506
            return cell
        }
        
        switch card.section {
        case "Traffic":
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCard", for: indexPath) as! StatsCardViewCell
            
            let results = store.getStatisticMetricsForCard(card)
            cell.statisticsCountView.setupViews(data: Array(results))
            let itemCellHeight: Int = 94
            cell.statisticsCountViewHeightCounstraint.constant = CGFloat(results.count * itemCellHeight)
            cellHeight = CGFloat((results.count * itemCellHeight) + (29 + 94 + 93 + 20 ))
            
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.footerView.actionButton.context = ["card":card]
            cell.footerView.actionButton.addTarget(self, action: #selector(openTrafficReport(_: eventInfo:)), for: .touchUpInside)
            
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
            cell.sectionTitleLabel.text = "TRAFFIC";
            return cell
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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
        return store.getStatisticsCards().count
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
