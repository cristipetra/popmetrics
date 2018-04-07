//
//  BaseHubViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 03/04/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

protocol HubControllerProtocol {
    
    func getHubName() -> String
    func getHubTitle() -> String
    func scrollToSection(_ section:String)
    func scrollToCard(_ cardName:String)
    func setDefaultIndexPath(_ indexPath:IndexPath?)
    func getDefaultIndexPath() -> IndexPath?
    
    func getVisibleItems(inSection: String) -> [HubCardProtocol]
    
    func getSectionIndex(_ section: String) -> Int
    func getSectionAtIndex(_ index: Int) -> String
    func getSectionsCount() -> Int
    func registerSection(_ section:String, atIndex:Int, pageLimit:Int)
    func getSectionPageLimit(_ section: String) -> Int
    func setSectionPageLimit(_ section:String, pageLimit:Int)
    
    func registerNibForCardType(_ cardType:String, nibName:String, nibIdentifier:String)
    
    func handleCardAction(card: HubCard, actionType:String) -> Bool
}

protocol HubCell {
    func updateHubCell( card: HubCard, hubController: HubControllerProtocol, options:[String:Any])
}

class BaseHubViewController: BaseViewController, HubControllerProtocol {
    
    @IBOutlet weak var myTableView: UITableView!
    var topHeaderView: HeaderView!
    
    private var sectionToIndex: [String:Int] = [:]
    private var indexToSection: [Int:String] = [:]
    private var sectionToPageLimit: [String:Int] = [:]
    
    private var defaultIndexPath: IndexPath?
    internal var isAnimatingHeader: Bool = false
    
    private var store: HubStoreProtocol?
    
    private var cardTypeToNibIdentifier:[String:String] = [:]
    
    func getHubName() -> String {
        return "Base"
    }
    
    func getHubTitle() -> String {
        return getHubName()
    }
    
    func setStore(_ store:HubStoreProtocol) {
        self.store = store
    }
    
    
    func registerNibForCardType(_ cardType: String, nibName:String, nibIdentifier: String) {
        let nib = UINib(nibName:nibName, bundle:nil)
        myTableView?.register(nib, forCellReuseIdentifier: nibIdentifier)
        self.cardTypeToNibIdentifier[cardType] = nibIdentifier
    }
    
    func registerDefaultNibs() {
        let sectionHeaderNib = UINib(nibName: "CardHeaderView", bundle: nil)
        myTableView.register(sectionHeaderNib, forCellReuseIdentifier: "CardHeaderView")
        
        let HubSectionCellNib = UINib(nibName: "HubSectionCell", bundle: nil)
        myTableView.register(HubSectionCellNib, forCellReuseIdentifier: "HubSectionCell")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.myTableView.separatorStyle = .none
        self.myTableView.allowsSelection = false
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        self.myTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.myTableView.estimatedSectionHeaderHeight = 80
        
        self.myTableView.sectionFooterHeight = UITableViewAutomaticDimension
        self.myTableView.estimatedSectionFooterHeight = 60
        
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        
        self.myTableView.estimatedRowHeight = 460
        
        registerDefaultNibs()
        setupTopHeaderView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Popmetrics.UiRefreshRequired, object:nil, queue:nil, using:catchUiRefreshRequiredNotification)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupTopHeaderView() {
        if topHeaderView == nil {
            topHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
            self.myTableView.addSubview(topHeaderView)
            topHeaderView.layer.zPosition = 1
            topHeaderView.displayElements(isHidden: true)
        }
    }
    

    func registerSection(_ section:String, atIndex:Int, pageLimit:Int = Int.max - 100) {
        self.sectionToIndex[section] = atIndex
        self.indexToSection[atIndex] = section
        self.sectionToPageLimit[section] = pageLimit
    }
    
    func getSectionsCount() -> Int {
        return sectionToIndex.count
    }
    func getSectionIndex(_ section: String) -> Int {
        return self.sectionToIndex[section, default: 0]
    }
    func getSectionAtIndex(_ index: Int) -> String {
        return self.indexToSection[index, default: "Error"]
    }
    func setSectionPageLimit(_ section:String, pageLimit:Int) {
        self.sectionToPageLimit[section] = pageLimit
    }
    func getSectionPageLimit(_ section: String) -> Int {
        return self.sectionToPageLimit[section, default: Int.max - 100]
    }
    
    func getDefaultIndexPath() -> IndexPath? {
        return self.defaultIndexPath
    }
    
    func setDefaultIndexPath(_ indexPath: IndexPath?) {
        self.defaultIndexPath = indexPath
    }
    
    func getVisibleItems(inSection: String) -> [HubCardProtocol] {
        
        guard let nonEmptyCards = store?.getNonEmptyHubCardsWithSection(hubs: [getHubName()], section: inSection) else { return [] }
        if nonEmptyCards.count > 0 {
            return Array(nonEmptyCards)
        }
        else{
            guard let emptyStateCards = store?.getEmptyHubCardsWithSection(hubs: [getHubName()], section: inSection) else {return [] }
            return Array(emptyStateCards)
        }
    }
    
    func scrollToSection(_ section: String) {
        let sectionIndex = getSectionIndex(section)
        let row = 0
        
        let indexPath = IndexPath(row: row, section: sectionIndex)
        if self.myTableView != nil {
            myTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            setDefaultIndexPath(nil)
        }
        else{
            setDefaultIndexPath(indexPath)
        }
        
    }
    
    func scrollToCard(_ cardName: String) {
        
        guard let item = store?.getHubCardWithName(cardName) else { return }
        let sectionIndex = getSectionIndex(item.getSection())
        
        let items = self.getVisibleItems(inSection:item.getSection())
        var row = 0
        var found = false
        for item in items {
            if cardName == item.getName() {
                found = true
                break
                }
            row = row + 1
            }
        if !found { row = 0 }
        
        let indexPath = IndexPath(row: row, section: sectionIndex)
        if self.myTableView != nil {
            myTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            setDefaultIndexPath(nil)
        }
        else{
            setDefaultIndexPath(indexPath)
        }
        
    }
    
    func catchUiRefreshRequiredNotification(notification:Notification) -> Void {
        //print(store.getFeedCards())
        self.myTableView.reloadData()
        
    }
    
    private func setUpNavigationBar() {
        
        let text = getHubTitle()
        
//        text.tintColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1.0)
//        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
//        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
//        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .selected)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "Icon_Menu"), style: .plain, target: self, action: #selector(handlerClickMenu))
        
        self.navigationItem.leftBarButtonItems = [leftButtonItem]
        self.navigationItem.title = text
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func handlerClickMenu() {
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MENU_VC") as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
        
    }
    func handleCardAction(card: HubCard, actionType:String) -> Bool {
        let actionUri = actionType=="primary" ? card.primaryAction : card.secondaryAction
        
        // first we try to open, otherwise we push
        return navigator.open(actionUri) || (navigator.push(actionUri) != nil)
        
    }
    

}

extension BaseHubViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.getSectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionName = getSectionAtIndex(section)
        let items = getVisibleItems(inSection:sectionName)
        
        let pageLimit = self.getSectionPageLimit(sectionName) + 1 // one for the LoadMore card
        return min(pageLimit, items.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = getSectionAtIndex(indexPath.section)
        let rowsInSection = self.tableView(tableView, numberOfRowsInSection: indexPath.section)
        
        let items = getVisibleItems(inSection:section)
        if items.count <= 0  {
            let cell = UITableViewCell()
            cell.translatesAutoresizingMaskIntoConstraints = false
            cell.heightAnchor.constraint(equalToConstant: 1).isActive = true
            cell.backgroundColor = .clear
            return cell
        }
        let item = items[indexPath.row]
        let isLastCard = indexPath.row == rowsInSection - 1
        
        let itemCellId = self.cardTypeToNibIdentifier[item.getType(), default:"Unsupported"]
        if itemCellId == "Unsupported" {
            let cell = UITableViewCell()
            cell.translatesAutoresizingMaskIntoConstraints = false
            cell.heightAnchor.constraint(equalToConstant: 1).isActive = true
            cell.backgroundColor = .clear
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! HubCell
        cell.updateHubCell(card:item as! HubCard, hubController:self,
                           options: ["isLastCard":isLastCard])
        return cell as! UITableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let count = self.tableView(tableView, numberOfRowsInSection: section)
        if count == 0 { return nil }
        let sectionName = self.getSectionAtIndex(section)
        let cell = tableView.dequeueReusableCell(withIdentifier: "HubSectionCell") as! HubSectionCell
        cell.sectionTitleLabel.text = sectionName
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let loadMoreView: LoadMoreView = LoadMoreView()
//        loadMoreView.btnLoadMore.addTarget(self, action: #selector(loadNextPage(_:)), for: .touchUpInside)
//        return loadMoreView
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.topHeaderView != nil {
            var fixedHeaderFrame = self.topHeaderView.frame
            fixedHeaderFrame.origin.y = 0 + scrollView.contentOffset.y
            topHeaderView.frame = fixedHeaderFrame
        }
        
        
        if let indexes = myTableView.indexPathsForVisibleRows {
            for index in indexes {
                let indexPath = IndexPath(row: 0, section: index.section)
                guard let lastRowInSection = indexes.last , indexes.first?.section == index.section else {
                    return
                }
                let headerFrame = myTableView.rectForHeader(inSection: index.section)
                
                let frameOfLastCell = myTableView.rectForRow(at: lastRowInSection)
                let cellFrame = myTableView.rectForRow(at: indexPath)
                if headerFrame.origin.y + 50 < myTableView.contentOffset.y {
                    self.changeTopHeaderTitle(section: index.section)
                    self.sectionChanged(section: index.section)
                    
                    animateHeader(colapse: false)
                } else if frameOfLastCell.origin.y < myTableView.contentOffset.y  {
                    animateHeader(colapse: false)
                } else {
                    animateHeader(colapse: true)
                }
            }
            if myTableView.contentOffset.y == 0 {   //top of the tableView
                animateHeader(colapse: true)
            }
        }
    }
    
    func changeTopHeaderTitle(section: Int) {
        let sectionName = self.getSectionAtIndex(section)
        topHeaderView?.changeTitle(title: sectionName)
    }
    
    func animateHeader(colapse: Bool) {
        if (self.isAnimatingHeader) {
            return
        }
        self.isAnimatingHeader = true
        UIView.animate(withDuration: 0.3, animations: {
            if colapse {
                self.topHeaderView.frame.size.height = 0
                self.topHeaderView.displayElements(isHidden: true)
            } else {
                self.topHeaderView.frame.size.height = 30
                self.topHeaderView.displayElements(isHidden: false)
            }
            self.topHeaderView.layoutIfNeeded()
        }, completion: { (completed) in
            self.isAnimatingHeader = false
        })
    }
    
    func sectionChanged(section:Int) {
        // toDoTopView.changeSection(section: index.section)
    }
    
}
