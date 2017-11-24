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

//    types = ['social_posts', 'my_action', 'paid_action', 'empty_state'];
//    sections = ['Unapproved Posts', 'My Actions', 'Paid Actions', 'More On The Way'];


enum TodoSection: String {
    
    case UnapprovedPosts = "Unapproved Posts"
    case MyActions = "My Actions"
    case PaidActions = "Paid Actions"
    case MoreOnTheWay = "More On The Way"
    
    static let sectionTitles = [
        UnapprovedPosts: "Unapproved Posts",
        MyActions: "My Actions",
        PaidActions: "Paid Actions",
        MoreOnTheWay: "More On The Way"
    ]
    
    // position in table
    static let sectionPosition = [
        UnapprovedPosts: 0,
        MyActions: 1,
        PaidActions: 2,
        MoreOnTheWay: 3
    ]
    
    func sectionTitle() -> String {
        if let sectionTitle = TodoSection.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }
    
    func getSectionHeaderHeight() -> CGFloat {
        return CGFloat(80)
    }
    
    func getSectionPosition() -> Int {
        return TodoSection.sectionPosition[self]!
    }
}

enum TodoSectionType: String {
    case unapprovedPosts = "Unapproved Posts"
    case myActions = "MyActions"
    case paidActions = "Paid Actions"
    case moreOnTheWay = "More On The Way"
}

enum TodoCardType: String {
    case socialPosts = "social_post"
    case myAction = "my_action"
    case paidAction = "paid_action"
    case emptyState = "empty_state"
    
    static let cardHeight = [
        socialPosts: 505,
        myAction: 479,
        paidAction: 261,
        emptyState: 261,
        ]
    
    func getCardHeight() -> CGFloat {
        if let cardHeight = TodoCardType.cardHeight[self] {
            return CGFloat(cardHeight)
        } else {
            return 0
        }
    }
}



class TodoHubController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toDoTopView: TodoTopView!
    
    let transitionView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var topHeaderView: HeaderView!
    var toDoNoteView: NoteView!
    let bannerMessageView = ToDoApprovedView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
    
    @IBOutlet weak var topAnchorTableView: NSLayoutConstraint!
    
    
    let store = TodoStore.getInstance()

    var approveIndex = 3
    var noItemsLoaded: [Int] = []
    let noItemsLoadeInitial = 3
    
    let indexToSection = [0: "Unapproved",
                          1: "MyActions"]
    
    var scrollToRow: IndexPath = IndexPath(row: 0, section: 0)
    
    internal var isAnimatingHeader: Bool = false
    
    var isAllApproved : Bool = false
    var currentBrandId = UsersStore.currentBrandId
    
    internal var didAnimateOpeningCells = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        tableView.separatorStyle = .none
        
        registerCellsForTable()

        setUpNavigationBar()
        
        self.toDoTopView.setActive(section: .unapproved)
        
        // NotificationCenter observers
        let nc = NotificationCenter.default
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
        
        //createItemsLocally()
        addApprovedView()
        
        topHeaderView.changeVisibilityExpandView(visible: false)
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
    
    @objc internal func goToHomeTab() {
        self.tabBarController?.selectedIndex = 0
    }
    
    func setupTopHeaderView() {
        if topHeaderView == nil {
            topHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
            self.tableView.addSubview(topHeaderView)
            topHeaderView.layer.zPosition = 1
            topHeaderView.displayElements(isHidden: true)
        }
    }
    
    internal func registerCellsForTable() {
        let toDoCardCell = UINib(nibName: "ToDoCardCell", bundle: nil)
        tableView.register(toDoCardCell, forCellReuseIdentifier: "toDoCardCellId")
        
        let toDoHeaderCardNib = UINib(nibName: "CardHeaderCell", bundle: nil)
        tableView.register(toDoHeaderCardNib, forCellReuseIdentifier: "CardHeaderCell")
        
        let sectionHeaderNib = UINib(nibName: "CalendarHeader", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "CalendarHeader")
        
        tableView.register(TableFooterView.self, forHeaderFooterViewReuseIdentifier: "footerId")
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")
        
        let maximizedCell = UINib(nibName: "TodoCardMaximized", bundle: nil)
        tableView.register(maximizedCell, forCellReuseIdentifier: "maxCellId")
        
        let todoHeader = UINib(nibName: "CardHeaderView", bundle: nil)
        tableView.register(todoHeader, forHeaderFooterViewReuseIdentifier: "CardHeaderView")
        
        let emptyCard = UINib(nibName: "EmptyCard", bundle: nil)
        tableView.register(emptyCard, forCellReuseIdentifier: "EmptyCard")
    }
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "To Do", style: .plain, target: self, action: nil)
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
        isAllApproved = false
        return isAllApproved
    }
    
    
    @objc func handlerClickMenu() {
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MENU_VC") as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
    }
    
}

extension TodoHubController: UITableViewDelegate, UITableViewDataSource, ApproveDenySinglePostProtocol {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        if( isLastSection(section: sectionIdx)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! EmptyStateCardCell
            cell.changeTitleWithSpacing(title: "Finished with the actions?");
            cell.changeMessageWithSpacing(message: "Check out the things you've scheduled in the calendar hub")
            cell.goToButton.changeTitle("View Calendar")
            
            cell.selectionStyle = .none
            
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCardCellId", for: indexPath) as! ToDoCardCell
        cell.indexPath = indexPath
        cell.actionSocialDelegate = self
        cell.configure(item: item)
        
        DispatchQueue.main.async {
            self.sideShadow(view: cell.containerView)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if store.getTodoCards().count <= 1 {
            return
        }
        let duration = 0.3
        
        if !UsersStore.didShowedTransitionAddToTask {
            if indexPath.section == 0 {
                
                let transform = CATransform3DMakeScale(1, 0.2, 1)
                cell.layer.transform = transform
                UIView.animate(withDuration: 0.5) {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }
                didAnimateOpeningCells = true
                UsersStore.didShowedTransitionAddToTask = true
            }
        } else if didAnimateOpeningCells == false {
            
            let delay = 0.1 + Double(indexPath.row) * 0.1
            
            let transformTop = CATransform3DTranslate(CATransform3DIdentity, 0, -148, 10)
            cell.layer.transform = transformTop
            cell.alpha = 0
            
            UIView.animate(withDuration: duration, delay: delay, options: .beginFromCurrentState, animations: {
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        
        
        if store.getTodoCards().count - 1 == indexPath.row  {
            didAnimateOpeningCells = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewController = UIStoryboard(name: "TodoPostDetails", bundle: nil).instantiateViewController(withIdentifier: "postDetailsId") as! SocialPostDetailsViewController
        detailsViewController.hidesBottomBarWhenPushed = true
        
        let socialPost = store.getTodoSocialPostsForCard(store.getTodoCards()[indexPath.section])[indexPath.row] //store.getTodoCards()[indexPath.section]
        
        detailsViewController.socialDelegate = self
        detailsViewController.configure(todoItem: socialPost,indexPath: indexPath)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        
    }
    
    func addApprovedView() {
        self.view.insertSubview(bannerMessageView, aboveSubview: tableView)
        
        bannerMessageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
        bannerMessageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        bannerMessageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bannerMessageView.widthAnchor.constraint(equalToConstant: 234).isActive = true
    }

    func removeCellWithAnimation(indexPath: IndexPath) {
        //remove social post card from store
        try! store.realm.write {
            store.realm.delete( store.getTodoSocialPostsForCard(store.getTodoCards()[indexPath.section])[indexPath.row] )
        }
        
        if !self.store.getTodoSocialPostsForCard(self.store.getTodoCards()[indexPath.section]).isEmpty {
            tableView.deleteRows(at: [indexPath], with: .middle)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            self.tableView.reloadData()
            
            if !UsersStore.didShowedTransitionFromTodo {
                self.tabBarController?.selectedIndex += 1
                UsersStore.didShowedTransitionFromTodo = true
            }
        }
    }
    
    func removeCell(indexPath: IndexPath) {
        /*
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            DispatchQueue.main.async {
                self.removeCellWithAnimation(indexPath: indexPath)
            }
        }
         */
        self.removeCellWithAnimation(indexPath: indexPath)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            self.displayBannerInfo()
        }
    }
    
    func hideApprovedView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bannerMessageView.transform = .identity //CGAffineTransform(translationX: 0, y: 50)
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
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "CardHeaderCell") as! CardHeaderCell
//            headerCell.changeColor(color: card.getSectionColor)
//            headerCell.changeTitle(title: card.getCardSectionTitle)
            return headerCell.containerView
        }
        
        let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CardHeaderView") as! CardHeaderView
//        headerCell.changeColor(color: card.getSectionColor)
        headerCell.toolbarView.backgroundColor = .white
//        headerCell.changeTitleSection(title: card.getCardSectionTitle)
//        headerCell.setUpHeaderShadowView()
        return headerCell
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
        if isLastSection(section: section) {
            return 60
        }
        let posts = store.getTodoSocialPostsForCard(store.getTodoCards()[section])
        if(posts.count == 0) {
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
                
                topHeaderView.changeTitle(title: item.socialTextString)
                topHeaderView.changeColorCircle(color: item.getSectionColor)
                if (item.status == "unapproved") {
                    topHeaderView.changeColorCircle(color: item.getSectionColor)
                    topHeaderView.changeTitle(title: (item.status?.capitalized)!)
                }
            } else {
                let card = store.getTodoCards()[section]
//                topHeaderView.changeTitle(title: card.getCardSectionTitle)
//                topHeaderView.changeColorCircle(color: card.getSectionColor)
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

extension TodoHubController:  TodoCardActionProtocol {
    
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
                    self.tableView.reloadData()
                    DispatchQueue.main.async {
                        self.tableView.scrollToRow(at: self.scrollToRow, at: .none, animated: false)
                    }
                }
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
extension TodoHubController {
    
    func catchUiRefreshRequiredNotification(notification:Notification) -> Void {
        self.tableView.reloadData()
    }
}

extension TodoHubController: ActionSocialPostProtocol {
    
    func displayBannerInfo() {
        if bannerMessageView.transform == .identity {
            UIView.animate(withDuration: 0.5, animations: {
                self.bannerMessageView.transform = CGAffineTransform(translationX: 0, y: -120)
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                    self.hideApprovedView()
                })
                
            })
        }
    }
    
    func denyPostFromSocial(post: TodoSocialPost, indexPath: IndexPath) {
        removeCell(indexPath: indexPath)
        bannerMessageView.displayDeny()
       
        //displayBannerInfo()
    }
    
    func approvePostFromSocial(post: TodoSocialPost, indexPath: IndexPath) {
        print("approve social post")
        
        removeCell(indexPath: indexPath)
        bannerMessageView.displayApproved()
        
        //displayBannerInfo()
        
    }
    
}


