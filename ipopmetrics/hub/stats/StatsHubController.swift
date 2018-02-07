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

enum StatsSection: String {
    
    case Traffic = "Traffic"
    case MoreOnTheWay = "More On The Way"
    
    static let sectionTitles = [
        Traffic: "Traffic",
        MoreOnTheWay: "More On The Way"
    ]
    
    // position in table
    static let sectionPosition = [
        Traffic: 0,
        MoreOnTheWay: 1
    ]
    
    func sectionTitle() -> String {
        if let sectionTitle = StatsSection.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }
    
    func getSectionPosition() -> Int {
        return StatsSection.sectionPosition[self]!
    }
}



enum StatsSectionType: String {
    case traffic = "Traffic"
    case moreOnTheWay = "More On The Way"
}

enum StatsCardType: String {
    case metricsCard = "metrics_card"
    case emptyState = "empty_state"
}

class StatsHubController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topAnchorTableView: NSLayoutConstraint!
    @IBOutlet weak var leftAnchorTableView: NSLayoutConstraint!
    
    let indexToSection = [0: StatsSectionType.traffic.rawValue,
                         1: StatsSectionType.moreOnTheWay.rawValue]
    
    let transitionView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var statisticsNoteView: NoteView!
    
    let store = StatsStore.getInstance()
    
    let loadingView = DGElasticPullToRefreshLoadingViewCircle()
    var insightIsDisplayed = false
    var cellHeight = 0 as CGFloat
    
    var selectedCard: StatsCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        //setUpNavigationBar()
        
        registerCellsForTable()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = PopmetricsColor.statisticsTableBackground
        
        self.view.addSubview(transitionView)
        transitionView.addSubview(tableView)
        
        // NotificationCenter observers
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Popmetrics.UiRefreshRequired, object:nil, queue:nil, using:catchUiRefreshRequiredNotification)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = PopmetricsColor.yellowBGColor
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // old code: self?.fetchItems(silent:false)
            SyncService.getInstance().syncAll(silent: false)
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PopmetricsColor.borderButton)
        tableView.dg_setPullToRefreshBackgroundColor(PopmetricsColor.loadingBackground)
        
        //createItemsLocally()
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
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavigationBar()
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
            let statsCard = StatsCard()
            statsCard.cardId = "dfas"
            statsCard.section = "Traffic"
            statsCard.status = "live"
            statsCard.type = "metrics_card"
            store.realm.add(statsCard, update: true)
     
            let statsMet1 = StatsMetric()
            statsMet1.statsCard = store.getStatsCards()[1]
            statsMet1.statsCardId = store.getStatsCards()[1].cardId!
            statsMet1.statsMetricId = "sadfasfdsa"
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
           
            let statsMet11 = StatsMetric()
            statsMet11.statsCard = store.getStatsCards()[1]
            statsMet11.statsCardId = store.getStatsCards()[1].cardId!
            statsMet11.statsMetricId = "sadfasfdasdffdsa"
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
            
            let statsMet12 = StatsMetric()
            statsMet12.statsCard = store.getStatsCards()[1]
            statsMet12.statsCardId = store.getStatsCards()[1].cardId!
            statsMet12.statsMetricId = "sadfasfdsasadga"
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
        print(store.getStatsCards())
        
    }

    internal var leftButtonItem: BadgeBarButtonItem!

    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Statistics", style: .plain, target: self, action: #selector(handlerClickMenu))
        text.tintColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1.0)
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .selected)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        leftButtonItem = BadgeBarButtonItem.init(image: UIImage(named: "Icon_Menu"), style: .plain, target: self, action: #selector(handlerClickMenu))
        
        leftButtonItem.addBadgeObservers()
        leftButtonItem.updateBadge()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (tim) in
            self.leftButtonItem.updateBadge()
        }
        
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
        
        self.selectedCard = actionButton.context["card"] as! StatsCard
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
    
    func getCardInSection( _ section: String, atIndex:Int) -> StatsCard {
        let nonEmptyCards = store.getNonEmptyStatsCardsWithSection(section)
        if nonEmptyCards.count == 0 {
            let emptyCards = store.getEmptyStatsCardsWithSection(section)
            return emptyCards[atIndex]
        }
        else {
            return nonEmptyCards[atIndex]
        }
    }
    
    func countCardsInSection( _ section: String) -> Int {
        let cards = store.getNonEmptyStatsCardsWithSection(section)
        //let cards = nonEmptyCards
        if cards.count == 0 {
            let emptyCards = store.getEmptyStatsCardsWithSection(section)
            return emptyCards.count
        }
        else {
            return cards.count
        }
    }

}
    

extension StatsHubController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionIdx = indexPath.section
        let rowIdx = indexPath.row
        
        guard let statsSection = StatsSection.init(rawValue: self.indexToSection[sectionIdx]!)
            else {
                return UITableViewCell()
        }
        
        let items = getVisibleItemsInSection(sectionIdx)
        
        if items.count == 0 {
            return UITableViewCell()
        }
        
        let item = items[rowIdx] as! StatsCard
        
        switch(item.type) {
            case StatsCardType.emptyState.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateCard", for: indexPath) as! EmptyStateCard
                cell.configure(statsCard: item)
                return cell
            case StatsCardType.metricsCard.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCard", for: indexPath) as! StatsCardViewCell
                
                let results = store.getStatsMetricsForCard(item)

                cell.statisticsCountView.setupViews(data: Array(results))
                let itemCellHeight: Int = 94
                cell.statisticsCountViewHeightCounstraint.constant = CGFloat(results.count * itemCellHeight)
                cellHeight = CGFloat((results.count * itemCellHeight) + (29 + 109 + 93 + 20 ))
                
                cell.footerView.actionButton.context = ["card": item]
                cell.footerView.actionButton.addTarget(self, action: #selector(openTrafficReport(_: eventInfo:)), for: .touchUpInside)
                
                cell.footerView.displayOnlyActionButton()
                cell.connectionLine.isHidden = true
                cell.labelUrl.text = UserStore.currentBrand?.domainURL
                
                return cell
            default:
                let cell = UITableViewCell()
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.heightAnchor.constraint(equalToConstant: 1).isActive = true
                cell.backgroundColor = .clear
                return cell
            }//switch
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.indexToSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getVisibleItemsInSection(section).count
    }
    
    func getVisibleItemsInSection(_ section: Int) -> [Any] {
        
        guard let statsSection = StatsSection.init(rawValue: self.indexToSection[section]!) else { return [] }
        
        let emptyStateCards = store.getEmptyStatsCardsWithSection(statsSection.rawValue)
        let nonEmptyCards = store.getNonEmptyStatsCardsWithSection(statsSection.rawValue)
        
        var items : [Any] = []
        if nonEmptyCards.count > 0 {
            for card in nonEmptyCards {
                let statsMetrics = store.getStatsMetricsForCard(card)
                if statsMetrics.count > 0 {
                    items.append(card)
                }
            }
            if items.count == 0 {
                return Array(emptyStateCards)
            } else {
                return items
            }
            return Array(nonEmptyCards)
        }
        else {
            return Array(emptyStateCards)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
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
    
}
