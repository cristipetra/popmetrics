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
    
    let transitionView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var topHeaderView: HeaderView!
    var toDoNoteView: NoteView!
    let approvedView = ToDoApprovedView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
    
    @IBOutlet weak var topAnchorTableView: NSLayoutConstraint!
    
    
    let store = TodoStore.getInstance()

    var approveIndex = 3
    var noItemsLoaded: [Int] = []
    let noItemsLoadeInitial = 3
    
    let indexToSection = [0: "Unapproved",
                          1: "Insights"]
    
    internal var shouldMaximize = false
    var scrollToRow: IndexPath = IndexPath(row: 0, section: 0)
    
    internal var isAnimatingHeader: Bool = false
    
    var isAllApproved : Bool = false
    var currentBrandId = UsersStore.currentBrandId

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        tableView.separatorStyle = .none
        
        registerCellsForTable()

        setUpNavigationBar()
        
        self.toDoTopView.setActive(section: .unapproved)
        
        // NotificationCenter observers
        let nc = NotificationCenter.default
        NotificationCenter.default.addObserver(self, selector: #selector(handlerDidChangeTwitterConnected(_:)), name: Notification.Name("didChangeTwitterConnected"), object: nil);
        
        nc.addObserver(forName:Notification.Popmetrics.UiRefreshRequired, object:nil, queue:nil, using:catchUiRefreshRequiredNotification)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = PopmetricsColor.darkGrey
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            SyncService.getInstance().syncTodoItems(silent: false)
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PopmetricsColor.yellowBGColor)
        tableView.dg_setPullToRefreshBackgroundColor(PopmetricsColor.darkGrey)
        
        setupTopHeaderView()
        setupTopViewItemCount()
        
        
        self.view.addSubview(transitionView)
        transitionView.addSubview(tableView)
        
        createItemsLocally()
        addApprovedView()
        
        topHeaderView.changeVisibilityExpandView(visible: false)
    }
    
    func createItemsLocally() {
        try! store.realm.write {
            store.realm.delete(store.getTodoCards())
            
            let todoCard = TodoCard()
            todoCard.cardId = "12523fa5"
            todoCard.type = "todo_unapproved"
            todoCard.section = "Unapproved"
            todoCard.headerTitle = "Unapproved Posts"
            store.realm.add(todoCard, update: true)
            
            
            let manualCard = TodoCard()
            manualCard.cardId = "223344"
            manualCard.type = "todo_manual"
            manualCard.section = "Manual"
            manualCard.headerTitle = "Doing Yourself"
            store.realm.add(manualCard, update: true)
            
            let failedCard = TodoCard()
            failedCard.cardId = "223355"
            failedCard.type = "todo_failed"
            failedCard.section = "Failed"
            failedCard.headerTitle = "Failed Actions"
            store.realm.add(failedCard, update: true)
            
            let todoPost1 = TodoSocialPost()
            todoPost1.isApproved = false
            todoPost1.postId = "2342134"
            todoPost1.todoCard = todoCard
            todoPost1.status = "Unapproved"
            todoPost1.articleText = "Popmetrics recommends highly customized marketing insights to help your business grow. #Popmetrics #GrowYourBusiness"
            store.realm.add(todoPost1, update: true)
            
            let todoPost2 = TodoSocialPost()
            todoPost2.isApproved = false
            todoPost2.postId = "1234424"
            todoPost2.todoCard = todoCard
            todoPost2.status = "Unapproved"
            todoPost2.articleText = "OG tags it knows what photo is your logo, what photo is of your business and what yourbusiness. #Popmetrics #GrowYourBusiness"
            store.realm.add(todoPost2, update: true)
            
            let todoPost3 = TodoSocialPost()
            todoPost3.isApproved = false
            todoPost3.postId = "5152525"
            todoPost3.todoCard = todoCard
            todoPost3.status = "Unapproved"
            todoPost3.articleText = "Popmetrics recommends highly customized marketing insights to help your business grow. #Popmetrics #GrowYourBusiness"
            store.realm.add(todoPost3, update: true)
        }
        print(store.getTodoCards())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        transitionView.alpha = 0.7
        let tabInfo = MainTabInfo.getInstance()
        let xValue = tabInfo.currentItemIndex >= tabInfo.lastItemIndex ? CGFloat(20) : CGFloat(-20)
        transitionView.frame.origin.x = xValue
        
        UIView.transition(with: tableView,
                          duration: 0.22,
                          animations: {
                            self.transitionView.frame.origin.x = 0
                            self.transitionView.alpha = 1
                        })
    }
    
    func handlerDidChangeTwitterConnected(_ sender: AnyObject) {
        
    }
    
    internal func setupNoteView() {
        if toDoNoteView == nil {
            toDoNoteView = NoteView(frame: CGRect(x: 0, y: toDoTopView.height(), width: self.view.frame.width, height: 93))
            self.view.addSubview(toDoNoteView)
            topAnchorTableView.constant = toDoNoteView.height()
            self.view.updateConstraints()
            toDoNoteView.setDescriptionText(type: .todo)
            toDoNoteView.performActionButton.addTarget(self, action: #selector(goToHomeTab), for: .touchUpInside)
        }
    }
    
    internal func goToHomeTab() {
        self.tabBarController?.selectedIndex = 0
    }
    
    func setupTopHeaderView() {
        if topHeaderView == nil {
            topHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
            self.tableView.addSubview(topHeaderView)
            topHeaderView.displayElements(isHidden: true)
            topHeaderView.btn.addTarget(self, action: #selector(handlerExpand), for: .touchUpInside)
        }
    }
    
    func handlerExpand() {
        maximizeCell()
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
        
        let emptyCard = UINib(nibName: "EmptyCard", bundle: nil)
        tableView.register(emptyCard, forCellReuseIdentifier: "EmptyCard")
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
        let todoCards = store.getTodoCards()
        for  todoCard in todoCards {
            if let status = StatusArticle(rawValue: todoCard.section.lowercased()) {
                switch status {
                case .unapproved:
                    toDoTopView.setTextClockLabel(text: ("(\(store.getTodoSocialPostsForCard(todoCard).count))"))
                    break
                case .failed:
                    //toDoTopView.setTextNotificationLabel(text: ("(\(section.items.count))"))
                    break
                default:
                    break
                }
            }
        }
        
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
    
}

extension ToDoViewController: ChangeCellProtocol {
    func maximizeCell() {
        shouldMaximize = !shouldMaximize
        
        tableView.reloadData()
        
        let type = shouldMaximize ? HeaderViewType.expand : HeaderViewType.minimize
        topHeaderView.changeStatus(type: type)
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource, ApproveDenySinglePostProtocol {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        if( isLastSection(section: sectionIdx)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
            cell.changeTitleWithSpacing(title: "Finished with the actions?");
            cell.changeMessageWithSpacing(message: "Check out the things you've scheduled in the calendar hub")
            cell.titleActionButton.text = "View Calendar"
            cell.selectionStyle = .none
            cell.goToButton.imageButtonType = .lastCardTodo
            cell.goToButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
            return cell
        }
        
        let sectionCards = store.getTodoSocialPostsForCard(store.getTodoCards()[sectionIdx])
        
        let card = store.getTodoCards()[sectionIdx]
        if sectionCards.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCard", for: indexPath) as! EmptyCardView
            cell.setupView(type: .todo, toDoStatus: ToDoStatus(rawValue: (card.section))!)
            cell.selectionStyle = .none
            return cell
        }
        
        let item = sectionCards[rowIdx]

        if shouldMaximize {
            let cell = tableView.dequeueReusableCell(withIdentifier: "maxCellId", for: indexPath) as! TodoCardMaximizedViewCell
            cell.configure(item)
            cell.articleDate.isHidden = true
            cell.approveDenyDelegate = self
            cell.postIndex = indexPath.row
            
            cell.connectionStackView.isHidden = true
            if (noItemsLoaded(indexPath.section) - 1 ==  indexPath.row) {
                cell.connectionStackView.isHidden = true
                cell.isLastCell = true
            } else {
                cell.connectionStackView.isHidden = false
            }
 
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCardCellId", for: indexPath) as! ToDoCardCell
        
        cell.aproveButton.indexPath = indexPath
        cell.aproveButton.addTarget(self, action: #selector(handlerApproveCard(_:)), for: .touchUpInside)
        cell.configure(item: item)
        DispatchQueue.main.async {
            self.sideShadow(view: cell.containerView)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func addApprovedView() {
        self.approvedView.isHidden = true
        self.view.insertSubview(approvedView, aboveSubview: tableView)
        approvedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
        approvedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        
    }
    
    func handlerApproveCard(_ button : TwoColorButton) {
        print("approve card")
        
        let indexPath = button.indexPath
        
        removeCell(indexPath: indexPath!)
        
        self.approvedView.isHidden = false
        self.approvedView.transform = CGAffineTransform(translationX: 0, y: 0)
        
        if approvedView.transform == .identity {
            UIView.animate(withDuration: 0.5, animations: {
                self.approvedView.transform = CGAffineTransform(translationX: 0, y: -120)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                    self.hideView()
                    
                })
                
            })
        } else {
            UIView.animate(withDuration: 1, animations: {
                self.approvedView.transform = .identity
            })
            
        }
    }
    
    func removeCellWithAnimation(indexPath: IndexPath) {
        //remove social post card from store
        try! store.realm.write {
            store.realm.delete( store.getTodoSocialPostsForCard(store.getTodoCards()[indexPath.section])[indexPath.row] )
        }
        tableView.deleteRows(at: [indexPath], with: .middle)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            self.tableView.reloadData()
        }
    }
    
    func removeCell(indexPath: IndexPath) {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
            DispatchQueue.main.async {
                self.removeCellWithAnimation(indexPath: indexPath)
            }
            
        }
    }
    
    func hideView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.approvedView.transform = CGAffineTransform(translationX: 0, y: 50)
        })
    }
    
    func sideShadow(view: UIView) {
        view.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)

        let shadowRect : CGRect = view.bounds.insetBy(dx: 0, dy: 0)
        view.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        
    }
    
    @objc private func goToNextTab() {
        self.tabBarController?.selectedIndex += 1
    }
    
    func approveSinglePostHandler(index: Int) {
        //sections[0].items[index].isApproved = true
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func isLastSection(section: Int) -> Bool {
        if section == store.getTodoCards().count {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //last section doesn't have a header view
        if( isLastSection(section: section)) {
            return UIView()
        }

        let card = store.getTodoCards()[section]
        
        if store.getTodoSocialPostsForCard(store.getTodoCards()[section]).count == 0 {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCardCell") as! HeaderCardCell
            headerCell.changeColor(color: card.getSectionColor)
            headerCell.changeTitle(title: card.getCardSectionTitle)
            return headerCell
        }
        
        if shouldMaximize == false {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CalendarHeaderViewCell
            headerCell.changeColor(color: card.getSectionColor)
            headerCell.toolbarView.backgroundColor = .white
            headerCell.changeTitleSection(title: card.getCardSectionTitle)
            headerCell.setUpHeaderShadowView()
            return headerCell
        } else {
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCardCell") as! HeaderCardCell
            headerCell.changeColor(cardType: .todo)
            headerCell.changeTitle(title: card.getCardSectionTitle)
            return headerCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if( isLastSection(section: section) || store.getTodoSocialPostsForCard(store.getTodoCards()[section]).count == 0) {
            return UIView()
        }
        let todoFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerId") as! TableFooterView
        todoFooter.setUpFooterShadowView()
        todoFooter.xButton.isHidden = true
        //todoFooter.changeTypeSection(typeSection: StatusArticle(rawValue: sections[section].status)!)
        //todoFooter.actionButton.addTarget(self, action: #selector(approveCard(_:section:)), for: .touchUpInside)
        
        todoFooter.section = section
        todoFooter.buttonHandlerDelegate = self
        todoFooter.changeTypeSection(typeSection: .unapproved)
        
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
        // height for header for last card
        //if section == store.getTodoCards().count  {
        if isLastSection(section: section) {
            return 60
        }
        let posts = store.getTodoSocialPostsForCard(store.getTodoCards()[section])
        if(posts.count == 0) {
            return 80
        }
        if shouldMaximize {
            return 80
        }
        return 109
    }
    
    func getCountSection() -> Int {
        //check if we receive card that has empty social post
        return store.getTodoCards().count + 1  // adding the last card
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //height for footer for last card
        if isLastSection(section: section) {
            return 0
        }
        if store.getTodoSocialPostsForCard(store.getTodoCards()[section]).isEmpty {
            return 0
        }
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return getCountSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( isLastSection(section: section)) {
            return 1
        } else if store.getTodoSocialPostsForCard(store.getTodoCards()[section]).isEmpty {
            return 1
        }
    
        return itemsToLoad(section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        shouldMaximize = !shouldMaximize
        scrollToRow = indexPath
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: self.scrollToRow, at: .none, animated: false)
        }
        tableView.reloadData()
        
        let type = shouldMaximize ? HeaderViewType.expand : HeaderViewType.minimize
        topHeaderView.changeStatus(type: type)
    }
    
    func reloadDataTable() {
        UIView.transition(with: tableView,
            duration: 0.35,
            options: .transitionCrossDissolve,
            animations: { self.tableView.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //height for last card
        if(isLastSection(section: indexPath.section)) {
            return 261
        }
        if store.getTodoSocialPostsForCard(store.getTodoCards()[indexPath.section]).isEmpty {
            return 216
        }
        
        if shouldMaximize {
            return 459
        }
        return 148
        
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
        
        var fixedHeaderFrame = self.topHeaderView.frame
        fixedHeaderFrame.origin.y = 0 + scrollView.contentOffset.y
        topHeaderView.frame = fixedHeaderFrame
        
        
        if let indexes = tableView.indexPathsForVisibleRows {
            for index in indexes {
                if(store.countSections() == 0) {
                    return
                }
                let indexPath = IndexPath(row: 0, section: index.section)
                guard let lastRowInSection = indexes.last , indexes.first?.section == index.section else {
                    return
                }
                let headerFrame = tableView.rectForHeader(inSection: index.section)
                
                let frameOfLastCell = tableView.rectForRow(at: lastRowInSection)
                let cellFrame = tableView.rectForRow(at: indexPath)
                if headerFrame.origin.y + 50 < tableView.contentOffset.y {
                    self.changeTopHeaderTitle(section: index.section)
                    animateHeader(colapse: false)
                } else if frameOfLastCell.origin.y < tableView.contentOffset.y  {
                    animateHeader(colapse: false)
                } else {
                    animateHeader(colapse: true)
                }
            }
            if tableView.contentOffset.y == 0 {   //top of the tableView
                animateHeader(colapse: true)
            }
        }
    }
    
    func changeTopHeaderTitle(section: Int) {
        if section < store.countSections() {
            if store.getTodoSocialPostsForCard(store.getTodoCards()[section]).count != 0 {
                let item = store.getTodoSocialPostsForCard(store.getTodoCards()[section])[0]
                //print(item.socialTextString)
                topHeaderView.changeTitle(title: item.socialTextString)
                topHeaderView.changeColorCircle(color: item.getSectionColor)
                if (item.status == "unapproved") {
                    topHeaderView.changeColorCircle(color: item.getSectionColor)
                    topHeaderView.changeTitle(title: (item.status?.capitalized)!)
                }
            } else {
                let card = store.getTodoCards()[section]
                topHeaderView.changeTitle(title: card.getCardSectionTitle)
                topHeaderView.changeColorCircle(color: card.getSectionColor)
            }
        }
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
            if action == "approve_one" || action == "deny_one" {
                var approvedPost: TodoSocialPost
                approvedPost = params["social_post"] as! TodoSocialPost
                    try! store.realm.write {
                        if action == "approve_one" {
                            approvedPost.status = "approved"
                        }
                        else {
                            approvedPost.status = "denied"
                        }
                    }//realm write
                let apiParams = ["action":action,
                                 "todo_social_post_id":approvedPost.postId]
                TodoApi().postAction(todoCard.cardId!, params:apiParams) { result, error in
                    if error != nil {
                        self.presentAlertWithTitle("Communication error", message: "An error occurred while communicating with the Cloud")
                        return
                    }
                    else {
                        print("action occurred")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didPostAction"), object: nil)
                    }
                    
            }
            if action == "deny_one" {
                var socialPost: TodoSocialPost
                socialPost = params["social_post"]  as! TodoSocialPost
                try! store.realm.write {
                    socialPost.status = "denied"
                    self.shouldMaximize = false
                    self.tableView.reloadData()
                    DispatchQueue.main.async {
                        self.tableView.scrollToRow(at: self.scrollToRow, at: .none, animated: false)
                    }
                }
                self.shouldMaximize = false
                self.tableView.reloadData()
                DispatchQueue.main.async {
                    self.tableView.scrollToRow(at: self.scrollToRow, at: .none, animated: false)
                }
            }// if action is approve_one or deny_one        
        }
        default:
            print("Unknown type")
        }//switch
        
    }
    
}

// MARK: Notification Handlers
extension ToDoViewController {
    
    func catchUiRefreshRequiredNotification(notification:Notification) -> Void {
        self.tableView.reloadData()
    }
}

