//
//  ToDoViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import EZAlertController
import SwiftyJSON

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toDoTopView: TodoTopView!
    
    fileprivate var sections: [TodoSection] = []
    var approveIndex = 3
    
    internal var shouldMaximize = false
    var isAllApproved : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        registerCellsForTable()

        setUpNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlerDidChangeTwitterConnected(_:)), name: Notification.Name("didChangeTwitterConnected"), object: nil);
        
        if (UsersStore.isTwitterConnected) {
            fetchItemsLocally()
        }
        
    }
    
    func handlerDidChangeTwitterConnected(_ sender: AnyObject) {
        fetchItemsLocally()
    }
    
    internal func registerCellsForTable() {
        let calendarCardNib = UINib(nibName: "CalendarCard", bundle: nil)
        tableView.register(calendarCardNib, forCellReuseIdentifier: "CalendarCard")
        
        let toDoCardCell = UINib(nibName: "ToDoCardCell", bundle: nil)
        tableView.register(toDoCardCell, forCellReuseIdentifier: "toDoCardCellId")
        
        let toDoHeaderCardNib = UINib(nibName: "HeaderCardCell", bundle: nil)
        tableView.register(toDoHeaderCardNib, forCellReuseIdentifier: "headerCardCell")
        
        let sectionHeaderNib = UINib(nibName: "CalendarHeader", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "headerCell")
        
        tableView.register(TableFooterView.self, forHeaderFooterViewReuseIdentifier: "footerId")
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")
        
        let maximizedCell = UINib(nibName: "CalendarCardMaximized", bundle: nil)
        tableView.register(maximizedCell, forCellReuseIdentifier: "maxCellId")
    }
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "To Do", style: .plain, target: self, action: nil)
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
    
    internal func setupTopViewItemCount() {
        for section in sections {
            if let status = StatusArticle(rawValue: section.status) {
                switch status {
                case .unapproved:
                    toDoTopView.setTextClockLabel(text: ("(\(section.items.count))"))
                    break
                case .failed:
                    toDoTopView.setTextNotificationLabel(text: ("(\(section.items.count))"))
                    break
                default:
                    break
                }
            }
        }
    }
    
    func checkApprovedAll() -> Bool {
        sections[0].items.forEach { (item) in
            if item.isApproved == true {
                isAllApproved = true
            } else {
                isAllApproved = false
            }
        }
        
        return isAllApproved
    }
    
    
    func handlerClickMenu() {
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MENU_VC") as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    internal func fetchItemsLocally() {
        let path = Bundle.main.path(forResource: "sampleFeedTodo", ofType: "json")
        let jsonData: NSData = NSData(contentsOfFile: path!)!
        let json = JSON(data: jsonData as Data)
        let todoStore = TodoStore.getInstance()
        for item in json["items"] {
            let todoItem = TodoItem()
            todoItem.status = item.1["status"].description
            todoItem.articleTitle = item.1["article_title"].description
            todoItem.statusDate = Date(timeIntervalSince1970: Double(item.1["status_date"].description)!)
            todoItem.articleImage = item.1["article_image"].description
            todoItem.articleText = item.1["article_text"].description
            todoItem.type = item.1["type"].description
            todoItem.articleUrl = item.1["article_url"].description
            todoItem.articleCategory = item.1["article_category"].description
            print(Double(item.1["status_date"].description));
            //calendarItem.articleCategory
            print(item.1["status"].description)
            //calendarFeedStore.app
            todoStore.storeItem(item: todoItem)
        }
        
        self.sections = todoStore.getFeed()
        self.setupTopViewItemCount()
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource, ApproveDenySinglePostProtocol {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        let section = sections[sectionIdx]
        let item = section.items[rowIdx]
        
        if item.type == "last_cell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
            cell.changeTitleWithSpacing(title: "Finished with the actions?");
            cell.changeMessageWithSpacing(message: "Check out the things you've schedulled in the caledar hub")
            cell.titleActionButton.text = "View Calendar"
            cell.selectionStyle = .none
            cell.goToButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
            return cell
        }
        
        if shouldMaximize {
            let cell = tableView.dequeueReusableCell(withIdentifier: "maxCellId", for: indexPath) as! CalendarCardMaximizedViewCell
            cell.configure(item)
            cell.articleDate.isHidden = true
            cell.setUpMaximizeToDo()
            cell.approveDenyDelegate = self
            cell.postIndex = indexPath.row
            cell.setUpApprovedConnectionView()
            
            if sections[indexPath.section].items.endIndex - 1 == indexPath.row {
                cell.connectionStackView.isHidden = true
                cell.isLastCell = true
            } else {
                cell.connectionStackView.isHidden = false
            }
            if sections[0].items[indexPath.row].isApproved == true {
                cell.setUpApprovedView(approved: true)
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCardCellId", for: indexPath) as! ToDoCardCell
        if sections[0].items[indexPath.row].isApproved == true {
             cell.setUpApprovedView(approved: true)
        }
        return cell
        
    }
    @objc private func goToNextTab() {
        self.tabBarController?.selectedIndex += 1
    }
    
    func approveSinglePostHandler(index: Int) {
        print("approved")
        sections[0].items[index].isApproved = true
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //last section doesn't have a header view
        if section == sections.endIndex - 1 {
            return UIView()
        }
        
        if shouldMaximize == false {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CalendarHeaderViewCell
            headerCell.changeColor(color: sections[section].items[0].getSectionColor)
            headerCell.changeTitle(title: sections[section].items[0].socialTextString)
            toDoTopView.setUpView(view: StatusArticle(rawValue: sections[section].status)!)
            return headerCell
        } else {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCardCell") as! HeaderCardCell
            headerCell.changeColor(section: section)
            headerCell.changeTitle(title: sections[section].items[0].socialTextString)
            return headerCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (section == sections.endIndex - 1) {
            return UIView()
        }
        let todoFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerId") as! TableFooterView
        todoFooter.changeTypeSection(typeSection: StatusArticle(rawValue: sections[section].status)!)
        todoFooter.actionButton.addTarget(self, action: #selector(approveCard), for: .touchUpInside)
        todoFooter.section = section
        todoFooter.buttonHandlerDelegate = self
        if isAllApproved {
            todoFooter.actionButton.changeToDisabled()
            todoFooter.setUpDisabledLabels()
            todoFooter.setUpLoadMoreDisabled()
        }
        DispatchQueue.main.async {
            todoFooter.setUpLoadMoreDisabled()
        }
        
        return todoFooter
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == sections.endIndex - 1 {
            return 60
        }
        if shouldMaximize {
            return 80
        }
        return 109
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == sections.endIndex - 1 {
            return 0
        }
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shouldMaximize = !shouldMaximize
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //height for last card
        if ( indexPath.section == (sections.count - 1) ) {
            return 261
        }
        if shouldMaximize {
            return 459
        }
        return 93
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let index = tableView.indexPathsForVisibleRows?.first {
            let headerFrame = tableView.rectForHeader(inSection: index.section)
            if headerFrame.origin.y <= tableView.contentOffset.y{
                if let status = StatusArticle(rawValue: sections[index.section].status) {
                    toDoTopView.setActive(section: status)
                }
            }
            if tableView.contentOffset.y == 0 {   //top of the tableView
                toDoTopView.setActive(section: .unapproved)
            }
        }
    }
}

extension ToDoViewController {
    func approveCard() {
        print("approve card")
        for item in sections[0].items {
            if sections[0].items.index(of: item)! < approveIndex {
                item.isApproved = true
            }
        }
        approveIndex += 3
        tableView.reloadData()
    }
}

extension ToDoViewController: FooterButtonHandlerProtocol {
    func loadMorePressed() {
        
    }
    
    func approvalButtonPressed(section : Int) {
        print("SSS section \(section)")
        if section == 0 {
            for item in sections[0].items {
                if sections[0].items.index(of: item)! < approveIndex {
                    item.isApproved = true
                }
            }
            isAllApproved = checkApprovedAll()
            approveIndex += 3
            tableView.reloadData()
        }
    }

    
    func closeButtonPressed() {
        
    }
    
    func informationButtonPressed() {
        
    }
}
