//
//  BaseHubViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 03/04/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

protocol HubControllerProtocol {
    
    func scrollToSection(_ section:String)
    func scrollToCard(_ cardName:String)
    func setDefaultIndexPath(_ indexPath:IndexPath?)
    func getDefaultIndexPath() -> IndexPath?
    
    func getVisibleItems(inSection: String) -> [HubCard]
    
    func getSectionIndex(_ section: String) -> Int
    
    
}

class BaseHubViewController: BaseViewController, HubControllerProtocol {

    @IBOutlet weak var tableView: UITableView!

    private var defaultIndexPath: IndexPath?
    private var store: HubStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Popmetrics.UiRefreshRequired, object:nil, queue:nil, using:catchUiRefreshRequiredNotification)
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func getDefaultIndexPath() -> IndexPath? {
        return self.defaultIndexPath
    }
    
    func setDefaultIndexPath(_ indexPath: IndexPath?) {
        self.defaultIndexPath = indexPath
    }
    
    func getSectionIndex(_ section: String) -> Int {
        return 0
    }
    
    func getVisibleItems(inSection: String) -> [HubCard] {
        return []
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
        let sectionIndex = getSectionIndex(item.section)
        
        let items = self.getVisibleItems(inSection:item.section)
        var row = 0
        var found = false
        for item in items {
            if cardName == item.name {
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
    

}
