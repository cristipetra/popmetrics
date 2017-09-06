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

import MGSwipeTableCell
import DGElasticPullToRefresh
import BubbleTransition
import EZAlertController

class ToDoViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toDoTopView: TodoTopView!
    
    let store = TodoStore.getInstance()

    var approveIndex = 3
    var noItemsLoaded: [Int] = []
    let noItemsLoadeInitial = 3
    
    let indexToSection = [0: "Unapproved",
                          1: "Insights"]
    
    internal var shouldMaximize = false
    var scrollToRow: IndexPath = IndexPath(row: 0, section: 0)
    
    var isAllApproved : Bool = false
    var currentBrandId = UsersStore.currentBrandId

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        registerCellsForTable()

        setUpNavigationBar()
        
        self.toDoTopView.setActive(section: .unapproved)
        NotificationCenter.default.addObserver(self, selector: #selector(handlerDidChangeTwitterConnected(_:)), name: Notification.Name("didChangeTwitterConnected"), object: nil);
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        
        
        loadingView.tintColor = PopmetricsColor.darkGrey
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.fetchItems(silent:false)
            self?.tableView.dg_stopLoading()
            self?.tableView.reloadData()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PopmetricsColor.yellowBGColor)
        tableView.dg_setPullToRefreshBackgroundColor(PopmetricsColor.darkGrey)
        
        
    }
    
    func handlerDidChangeTwitterConnected(_ sender: AnyObject) {
        
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
        
        let maximizedCell = UINib(nibName: "TodoCardMaximized", bundle: nil)
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
        /*
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
        */
    }
    
    func checkApprovedAll() -> Bool {
        /*
        sections[0].items.forEach { (item) in
            if item.isApproved == true {
                isAllApproved = true
            } else {
                isAllApproved = false
            }
        }*/
        isAllApproved = false
        return isAllApproved
    }
    
    
    func handlerClickMenu() {
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MENU_VC") as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    func fetchItems(silent:Bool) {
        //        let path = Bundle.main.path(forResource: "sampleFeed", ofType: "json")
        //        let jsonData : NSData = NSData(contentsOfFile: path!)!
        TodoApi().getItems(currentBrandId) { responseWrapper, error in
            
            if error != nil {
                let message = "An error has occurred. Please try again later."
                self.presentAlertWithTitle("Error", message: message)
                return
            }
            if "success" != responseWrapper?.code {
                self.presentAlertWithTitle("Error", message: (responseWrapper?.message)!)
                return
            }
            else {
                self.store.updateTodos((responseWrapper?.data)!)
                self.tableView.reloadData()
            }
            
        }
        
        
    }

    
    internal func createItemsLocally() {
        
        try! store.realm.write {

            let todoCard = TodoCard()
            todoCard.cardId = "1234"
            store.realm.add(todoCard, update:true)
        
            let post1 = TodoSocialPost()
            post1.todoCard = todoCard
            post1.postId = "098tq098gr"
            post1.status = "unapproved"
            post1.articleTitle = "Optimizing Your Website"
            post1.statusDate = Date()
            post1.articleImage = "image_optimize"
            post1.articleText = "Why is SEO such a challenging yet integral part of a building a successful website?"
            post1.type = "twitter_article"
            post1.articleUrl = "alchm.my/agga"
            post1.articleCategory = "Local News"
            store.realm.add(post1, update:true)
            
            let post2 = TodoSocialPost()
            post2.todoCard = todoCard
            post2.postId = "fspodighjpsdfoi"
            post2.status = "unapproved"
            post2.articleTitle = "Optimizing Your Website 2"
            post2.statusDate = Date()
            post2.articleImage = "image_optimize"
            post2.articleText = "Why is SEO such a challenging yet integral part of a building a successful website? (2)"
            post2.type = "twitter_article"
            post2.articleUrl = "alchm.my/agga"
            post2.articleCategory = "Local News"
            store.realm.add(post2, update:true)
            
            let post3 = TodoSocialPost()
            post3.todoCard = todoCard
            post3.postId = "fspsodighjpsdfoi"
            post3.status = "unapproved"
            post3.articleTitle = "Optimizing Your Website 3"
            post3.statusDate = Date()
            post3.articleImage = "image_optimize"
            post3.articleText = "Why is SEO such a challenging yet integral part of a building a successful website? (3)"
            post3.type = "twitter_article"
            post3.articleUrl = "alchm.my/agga"
            post3.articleCategory = "Local News"
            store.realm.add(post3, update:true)
        }
        
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource, ApproveDenySinglePostProtocol {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        let sectionCards = store.getTodoSocialPostsForCard(store.getTodoCards()[sectionIdx])
        let item = sectionCards[rowIdx]
        

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "maxCellId", for: indexPath) as! TodoCardMaximizedViewCell
            cell.configure(item)
            cell.articleDate.isHidden = true
            cell.setUpMaximizeToDo()
            cell.approveDenyDelegate = self
            cell.postIndex = indexPath.row
            cell.setUpApprovedConnectionView()
            
            /*
            if sections[indexPath.section].items.endIndex - 1 == indexPath.row {
                cell.connectionStackView.isHidden = true
                cell.isLastCell = true
            } else {
                cell.connectionStackView.isHidden = false
            }
 
            if sections[0].items[indexPath.row].isApproved == true {
                cell.setUpApprovedView(approved: true)
            }
             */
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCardCellId", for: indexPath) as! ToDoCardCell
        cell.configure(item: item)
        
        return cell
        
    }
    @objc private func goToNextTab() {
        self.tabBarController?.selectedIndex += 1
    }
    
    func approveSinglePostHandler(index: Int) {
        //sections[0].items[index].isApproved = true
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //last section doesn't have a header view
        /*
        if section == store.getTodoCards().endIndex - 1 {
            //if section == sections.endIndex - 1 {
            return UIView()
        }*/
        
        let item: TodoSocialPost = store.getTodoSocialPostsForCard(store.getTodoCards()[0])[0]
        
        
        if shouldMaximize == false {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CalendarHeaderViewCell
            headerCell.changeColor(color: item.getSectionColor)
            headerCell.changeTitle(title: item.socialTextString)
            //toDoTopView.setUpView(view: StatusArticle(rawValue: sections[section].status)!)
            return headerCell
        } else {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCardCell") as! HeaderCardCell
            //headerCell.changeColor(section: section)
            headerCell.changeTitle(title: item.socialTextString)
            return headerCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        /*
        if section == store.getTodoCards().endIndex - 1 {
            return UIView()
        }*/
        let todoFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerId") as! TableFooterView
        
        todoFooter.xButton.isHidden = true
        //todoFooter.changeTypeSection(typeSection: StatusArticle(rawValue: sections[section].status)!)
        //todoFooter.actionButton.addTarget(self, action: #selector(approveCard(_:section:)), for: .touchUpInside)
        
        todoFooter.section = section
        todoFooter.buttonHandlerDelegate = self
        
        /*
        if(sections[section].allApproved) {
            todoFooter.actionButton.changeToDisabled()
            todoFooter.setUpDisabledLabels()
            todoFooter.setUpLoadMoreDisabled()
        }
         */
        if(noItemsLoaded(section) ==  store.getTodoSocialPostsForCard(store.getTodoCards()[section]).count) {
            DispatchQueue.main.async {
                todoFooter.setUpLoadMoreDisabled()
            }
            
        }
        
        return todoFooter
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /*
        if section == store.getTodoCards().endIndex - 1 {
            return 60
        }*/
        if shouldMaximize {
            return 80
        }
        return 109
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        /*
        if section == store.getTodoCards().endIndex - 1 {
            return 0
        }*/
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return store.countSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToLoad(section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shouldMaximize = !shouldMaximize
        scrollToRow = indexPath
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: self.scrollToRow, at: .none, animated: false)
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //height for last card
        /*
        if indexPath.section == store.getTodoCards().endIndex - 1 {
            return 261
        }*/
        
        if shouldMaximize {
            return 459
        }
        return 93
    }
    
    
    func noItemsLoaded(_ section: Int) -> Int {
        if( noItemsLoaded.isEmpty || noItemsLoaded.count <= section) {
            noItemsLoaded.append(noItemsLoadeInitial)
        }
        return noItemsLoaded[section]
    }
    
    func changeNoItemsLoaded(_ section: Int, value: Int) {
        if( noItemsLoaded.isEmpty ) {
            noItemsLoaded[section] = noItemsLoadeInitial
        }
        noItemsLoaded[section] += value
    }
    
    
    func itemsToLoad(section: Int) -> Int {
        if (store.getTodoSocialPostsForCard(store.getTodoCards()[section]).count > noItemsLoaded(section)) {
            return noItemsLoaded(section)
        } else {
            return store.getTodoSocialPostsForCard(store.getTodoCards()[section]).count
        }
        return noItemsLoadeInitial
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let index = tableView.indexPathsForVisibleRows?.first {
            let headerFrame = tableView.rectForHeader(inSection: index.section)
            if headerFrame.origin.y < tableView.contentOffset.y{
                /*
                if let status = StatusArticle(rawValue: sections[index.section].status) {
                    toDoTopView.setActive(section: status)
                }*/
            }
            if tableView.contentOffset.y == 0 {   //top of the tableView
                toDoTopView.setActive(section: .unapproved)
            }
        }
    }
    
}

extension ToDoViewController: FooterButtonHandlerProtocol {
    func loadMorePressed(section: Int) {
        var addItem = noItemsLoadeInitial
        let posts = store.getTodoSocialPostsForCard(store.getTodoCards()[section])
        if (posts.count > noItemsLoaded(section) + noItemsLoadeInitial) {
            addItem = noItemsLoadeInitial
        } else {
            addItem = posts.count - noItemsLoaded(section)
        }
    
        changeNoItemsLoaded(section, value: addItem)
        tableView.reloadData()
    }
    
    func approvalButtonPressed(section : Int) {
        print("section \(section)")
        /*
        for item in sections[section].items {
            if sections[section].items.index(of: item)! < approveIndex {
                item.isApproved = true
            }
        }
        */
        approveIndex += 3
        //sections[section].allApproved = true
        tableView.reloadData()
    }
    
    func closeButtonPressed() {
        
    }
    
    func informationButtonPressed() {
        
    }
}


extension ToDoViewController:  TodoCardActionHandler {
    
    func handleCardAction(_ action:String, todoCard: TodoCard, params:[String:Any]) {
        
        switch (todoCard.type) {
        case "articles_posting":
            if action == "approve_one" {
                var approvedPost: TodoSocialPost
                approvedPost = params["social_post"] as! TodoSocialPost
                    try! store.realm.write {
                        approvedPost.status = "approved"
                        self.shouldMaximize = false
                        self.tableView.reloadData()
                    }
                    
            }
        
        default:
            print("Unknown type")
        }//switch
        
        
        
        
    }
    
}

