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
    
}

protocol HubCell {
    func configure( card: HubCard)
}

class BaseHubViewController: BaseViewController, HubControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!

    private var sectionToIndex: [String:Int] = [:]
    private var indexToSection: [Int:String] = [:]
    private var sectionToPageLimit: [String:Int] = [:]
    
    private var defaultIndexPath: IndexPath?
    
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
        tableView?.register(nib, forCellReuseIdentifier: nibIdentifier)
        self.cardTypeToNibIdentifier[cardType] = nibIdentifier
    }
    
    func registerDefaultNibs() {
        let sectionHeaderNib = UINib(nibName: "CardHeaderView", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "CardHeaderView")
        
        let HubSectionCellNib = UINib(nibName: "HubSectionCell", bundle: nil)
        tableView.register(HubSectionCellNib, forCellReuseIdentifier: "HubSectionCell")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = 80
        
        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionFooterHeight = 60
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 460
        
        registerDefaultNibs()

        
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

    func registerSection(_ section:String, atIndex:Int, pageLimit:Int = 0) {
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
        return self.sectionToPageLimit[section, default: 0]
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
        if self.tableView != nil {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
        if self.tableView != nil {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            setDefaultIndexPath(nil)
        }
        else{
            setDefaultIndexPath(indexPath)
        }
        
    }
    
    func catchUiRefreshRequiredNotification(notification:Notification) -> Void {
        //print(store.getFeedCards())
        self.tableView.reloadData()
        
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
    

}

extension BaseHubViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.getSectionsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionName = getSectionAtIndex(section)
        let items = getVisibleItems(inSection:sectionName)
        
        let pageLimit = self.getSectionPageLimit(sectionName)
        if pageLimit == 0 {
            return items.count
        }
        else {
            return min(pageLimit, items.count)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = getSectionAtIndex(indexPath.section)
        let pageLimit = self.getSectionPageLimit(section)
        
        let items = getVisibleItems(inSection:section)
        if items.count <= 0  {
            let cell = UITableViewCell()
            cell.translatesAutoresizingMaskIntoConstraints = false
            cell.heightAnchor.constraint(equalToConstant: 1).isActive = true
            cell.backgroundColor = .clear
            return cell
        }
        let item = items[indexPath.row]
        
        let itemCellId = self.cardTypeToNibIdentifier[item.getType(), default:"Unsupported"]
        if itemCellId == "Unsupported" {
            let cell = UITableViewCell()
            cell.translatesAutoresizingMaskIntoConstraints = false
            cell.heightAnchor.constraint(equalToConstant: 1).isActive = true
            cell.backgroundColor = .clear
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellId, for: indexPath) as! HubCell
        cell.configure(card:item as! HubCard)
        return cell as! UITableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
    
}
