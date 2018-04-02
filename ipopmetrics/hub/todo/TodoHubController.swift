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
import ObjectMapper
import EZLoadingActivity

enum TodoSection: String {
    
    case SocialPosts = "Social Posts"
    case MyActions = "My Actions"
    case PaidActions = "Paid Actions"
    
    static let sectionTitles = [
        SocialPosts: "Social Posts",
        MyActions: "My Actions",
        PaidActions: "Paid Actions"
    ]
    
    // position in table
    static let sectionPosition = [
        SocialPosts: 0,
        MyActions: 1,
        PaidActions: 2
    ]
    
    func sectionTitle() -> String {
        if let sectionTitle = TodoSection.sectionTitles[self] {
            return sectionTitle
        } else {
            return ""
        }
    }

    func getSectionPosition() -> Int {
        return TodoSection.sectionPosition[self]!
    }
}

enum TodoSectionType: String {
    case socialPosts = "Social Posts"
    case myActions = "My Actions"
    case paidActions = "Paid Actions"
}

enum TodoCardType: String {
    case socialPosts = "social_posts"
    case myAction = "my_action"
    case paidAction = "paid_action"
    case emptyState = "empty_state"
}



class TodoHubController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toDoTopView: TodoTopView!
    
    let transitionView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var topHeaderView: HeaderView!
    var toDoNoteView: NoteView!
    let bannerMessageView = ToDoApprovedView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
    
    @IBOutlet weak var topAnchorTableView: NSLayoutConstraint!
    
    
    let indexToSection = [0: TodoSectionType.socialPosts.rawValue,
                          1: TodoSectionType.myActions.rawValue,
                          2: TodoSectionType.paidActions.rawValue]
    
    let store = TodoStore.getInstance()
    
    var noItemsLoaded: [Int] = []
    let noItemsLoadedInitial = 6
    
    var pageIndex: Int = 1
    
    var scrollToRow: IndexPath = IndexPath(row: 0, section: 0)
    
    internal var isAnimatingHeader: Bool = false
    
    var isAllApproved : Bool = false
    var currentBrandId = UserStore.currentBrandId
    
    var segueTodoCard: TodoCard?
    
    internal var didAnimateOpeningCells = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        tableView.separatorStyle = .none
        
        registerCellsForTable()

        //setUpNavigationBar()
        
        self.toDoTopView.setActive(section: .unapproved)
        
        
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = 60
        
        self.tableView.sectionFooterHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionFooterHeight = 0
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.estimatedRowHeight = 450
        
        // NotificationCenter observers
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Popmetrics.UiRefreshRequired, object:nil, queue:nil, using:catchUiRefreshRequiredNotification)
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = PopmetricsColor.yellowBGColor
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            SyncService.getInstance().syncAll(silent: false)
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PopmetricsColor.borderButton)
        tableView.dg_setPullToRefreshBackgroundColor(PopmetricsColor.loadingBackground)
        
        setupTopHeaderView()
        //setupTopViewItemCount()
        
        
        self.view.addSubview(transitionView)
        transitionView.addSubview(tableView)
        
        addApprovedView()
        
        topHeaderView.changeVisibilityExpandView(visible: false)
        updateCountsTopView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavigationBar()
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
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
        let toDoCardCell = UINib(nibName: "SocialPostInCardCell", bundle: nil)
        tableView.register(toDoCardCell, forCellReuseIdentifier: "SocialPostInCardCell")
        
        let toDoHeaderCardNib = UINib(nibName: "HubSectionCell", bundle: nil)
        tableView.register(toDoHeaderCardNib, forCellReuseIdentifier: "HubSectionCell")
        
        let emptyCard = UINib(nibName: "EmptyStateCard", bundle: nil)
        tableView.register(emptyCard, forCellReuseIdentifier: "EmptyStateCard")
        
        let todoMyActionCardNib = UINib(nibName: "MyActionCard", bundle: nil)
        tableView.register(todoMyActionCardNib, forCellReuseIdentifier: "MyActionCard")
        
        let paidActionCardNib = UINib(nibName: "PaidActionCard", bundle: nil)
        tableView.register(paidActionCardNib, forCellReuseIdentifier: "PaidActionCard")
    }
    
    internal var leftButtonItem: UIBarButtonItem!
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Tasks", style: .plain, target: self, action: #selector(handlerClickMenu))
        text.tintColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1.0)
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .selected)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "Icon_Menu"), style: .plain, target: self, action: #selector(handlerClickMenu))
        
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    func updateCountsTopView() {
        updateCountSocialPost()
    }
    
    private func updateCountSocialPost() {
        var count = 0
        let items = getVisibleItemsInSection(0)
        count = items.count
        if items.count == 1 {
            var item: TodoCard
            if items[0] is TodoCard {
                item = items[0] as! TodoCard
            } else {
                toDoTopView.changeValueSection(value: 1, section: 0)
                return
            }
                
            if item.type != "empty_state" {
                let socialItems = items as! [TodoSocialPost]
                count = socialItems.filter{ $0.isApproved != true }.count
            } else {
                count = 0
            }
            
        } else {
            if items.count > 0 {
                if items[0] is TodoSocialPost{
                    let socialItems = items as! [TodoSocialPost]
                    count = socialItems.filter{ $0.isApproved != true }.count
                }
            }
        }
        
        toDoTopView.changeValueSection(value: count, section: 0)
    }
    
    
    
    func getVisibleItemsInSection(_ section: Int) -> [Any] {
        
        guard let todoSection = TodoSection.init(rawValue: self.indexToSection[section]!)
            else { return [] }
        
        let emptyStateCards = store.getEmptyTodoCardsWithSection(todoSection.rawValue)
        if section == 0 {
            guard let card = store.getTodoCardWithName("social.control_articles") else {
                return Array(emptyStateCards)
            }
            let items = store.getTodoSocialPostsForCard(card)
            if items.count > 0 {
                return Array(items)
            }
            else {
                return Array(emptyStateCards)
            }
        }
        let nonEmptyCards = store.getNonEmptyTodoCardsWithSection(todoSection.rawValue)
        if nonEmptyCards.count > 0 {
            return Array(nonEmptyCards)
        } else {
            return Array(emptyStateCards)
        }
        
    }
    

    @objc func handlerClickMenu() {
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MENU_VC") as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    func openActionStatus(_ actionCard: TodoCard) {
        self.segueTodoCard = actionCard
        self.performSegue(withIdentifier:"showAction", sender:self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! ActionStatusViewController
        if (self.segueTodoCard != nil) {
            vc.configure(self.segueTodoCard!)
        }
    }
    
    
}

//MARK: load more functionality
extension TodoHubController {
    /*
     * Returns items that loads on a page
     */
    func getItemsToLoad(_ section: Int, items: [Any]) -> Int {
        if section == 0 {
            if pageIndex * noItemsLoadedInitial > items.count {
                if pageIndex == 1 {
                    return items.count
                } else {
                    return items.count - ((pageIndex - 1) * noItemsLoadedInitial)
                }
            }
            return noItemsLoadedInitial
        }
        return 0
    }
    
    /*
     * return the item at a specific index
     */
    func getPaginationItem(indexPath: IndexPath, items: [Any]) -> Any {
        let rowIdx = indexPath.row
        
        let positionInItems = pageIndex == 1 ? rowIdx : (pageIndex - 1) * noItemsLoadedInitial + rowIdx
        
        return items[positionInItems]
    }
    
    /*
     * Increase page index or reset
     */
    func updateCurrentPageIndex() {
        let items = getVisibleItemsInSection(0)
        if pageIndex * noItemsLoadedInitial >= items.count {
            pageIndex = 1
        } else {
            pageIndex += 1
        }
    }
    
    @objc func loadNextPage(_ btn: Any) {
        updateCurrentPageIndex()
        
        EZLoadingActivity.showLoadingSpinner(disableUI: true)
        self.tableView.beginUpdates()
        self.tableView.reloadSections([0], with: .automatic)
        self.tableView.endUpdates()
        self.tableView.layoutIfNeeded()
        
        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { (timer) in
            self.animateHeader(colapse: true)
            EZLoadingActivity.hide()
        }
        
    }
    
}

extension TodoHubController: UITableViewDelegate, UITableViewDataSource, ApproveDenySinglePostProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.indexToSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let items = getVisibleItemsInSection(section)
        
        // section 0 has load more functionality
        if section == 0 {
            return getItemsToLoad(section, items: items)
        }
        
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionIdx = indexPath.section
        let rowIdx = indexPath.row
        guard let todoSection = TodoSection.init(rawValue: self.indexToSection[sectionIdx]!)
            else {
                return UITableViewCell()
        }
        let items = getVisibleItemsInSection(sectionIdx)
        
        if items.count == 0 {
            return UITableViewCell()    
        }
        
        var item = items[rowIdx]
        
        if sectionIdx == 0 {
            item = getPaginationItem(indexPath: indexPath, items: items)
        }
        
        if item is TodoSocialPost {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SocialPostInCardCell", for: indexPath) as! SocialPostInCardCell
            cell.setIndexPath(indexPath: indexPath, numberOfCellsInSection: items.count)
            cell.actionSocialDelegate = self
        
            cell.configure(item: item as! TodoSocialPost)
            return cell
            }

        let cardItem = item as! TodoCard
        
        switch(cardItem.type) {
        
            case TodoCardType.myAction.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyActionCard", for: indexPath) as! MyActionCardCell
                cell.configure(cardItem)
                return cell
            
            case TodoCardType.paidAction.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "PaidActionCard", for: indexPath) as! PaidActionCardCell
                cell.configure(cardItem)
                return cell
            case TodoCardType.emptyState.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateCard", for: indexPath) as! EmptyStateCard
                cell.configure(todoCard: cardItem)
                
                return cell
            default:
                let cell = UITableViewCell()
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.heightAnchor.constraint(equalToConstant: 1).isActive = true
                cell.backgroundColor = .clear
                return cell
        }
        
    }
    

// no visual effects yet
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if store.getTodoCards().count <= 1 {
//            return
//        }
//        let duration = 0.3
//
//        if !UsersStore.didShowedTransitionAddToTask {
//            if indexPath.section == 0 {
//
//                let transform = CATransform3DMakeScale(1, 0.2, 1)
//                cell.layer.transform = transform
//                UIView.animate(withDuration: 0.5) {
//                    cell.alpha = 1
//                    cell.layer.transform = CATransform3DIdentity
//                }
//                didAnimateOpeningCells = true
//                UsersStore.didShowedTransitionAddToTask = true
//            }
//        } else if didAnimateOpeningCells == false {
//
//            let delay = 0.1 + Double(indexPath.row) * 0.1
//
//            let transformTop = CATransform3DTranslate(CATransform3DIdentity, 0, -148, 10)
//            cell.layer.transform = transformTop
//            cell.alpha = 0
//
//            UIView.animate(withDuration: duration, delay: delay, options: .beginFromCurrentState, animations: {
//                cell.alpha = 1
//                cell.layer.transform = CATransform3DIdentity
//            }, completion: nil)
//        }
//
//
//        if store.getTodoCards().count - 1 == indexPath.row  {
//            didAnimateOpeningCells = true
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if (indexPath.section != 0) { return }
//
//        let cards = store.getNonEmptyTodoCardsWithSection("Social Posts")
//        if cards.count == 0 { return }
//        let rowIdx = indexPath.row
//
//        let card = cards[0]
//
//        let socialPosts = store.getTodoSocialPostsForCard(card)
//        if socialPosts.count == 0 { return }
//        let item = socialPosts[rowIdx]
        
        if (indexPath.section != 0) { return }
        let currentCell = tableView.cellForRow(at: indexPath)
        var item: TodoSocialPost!
        
        if currentCell is SocialPostInCardCell {
            let todoCell = currentCell as! SocialPostInCardCell
            item = todoCell.todoItem
            openDetailsPage(todoSocialPost: item, indexPath: indexPath)
        }
        
    }
    
    func openDetailsPage(todoSocialPost: TodoSocialPost, indexPath: IndexPath) {
        var detailsVC: SocialPostDetailsViewController!
        
        if todoSocialPost.type == "facebook" {
            detailsVC = SocialPostDetailsViewController(nibName: "FacebookSocialPostDetails", bundle: nil)
        } else {
            detailsVC = SocialPostDetailsViewController(nibName: "SocialPostDetails", bundle: nil)
        }
        detailsVC.configure(todoSocialPost: todoSocialPost)
        detailsVC.actionSocialDelegate = self
        detailsVC.setIndexPath(indexPath)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func addApprovedView() {
        self.view.insertSubview(bannerMessageView, aboveSubview: tableView)
        
        bannerMessageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 50).isActive = true
        bannerMessageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        bannerMessageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bannerMessageView.widthAnchor.constraint(equalToConstant: 234).isActive = true
    }

    func removeSocialPost(_ todoSocialPost: TodoSocialPost, indexPath : IndexPath) {
        //remove social post card from store
        store.removeTodoSocialPost(todoSocialPost)

        self.tableView.reloadSections([indexPath.section], with: .none)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (timer) in
            self.tableView.reloadData()
            self.updateCountsTopView()
        })
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let todoSection = TodoSection.init(rawValue: self.indexToSection[section]!)
        let cell = tableView.dequeueReusableCell(withIdentifier: "HubSectionCell") as! HubSectionCell
        cell.sectionTitleLabel.text = todoSection?.rawValue.uppercased()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let loadMoreView: LoadMoreView = LoadMoreView()
        loadMoreView.btnLoadMore.addTarget(self, action: #selector(loadNextPage(_:)), for: .touchUpInside)
        return loadMoreView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {let items = getVisibleItemsInSection(0)
            if items.count == 1 {
                if items[0] is TodoCard {
                    return 0.1
                } else {
                    return 49
                }
            }
            return 49
        }
        return 0.1
    }
    
    func reloadDataTable() {
        UIView.transition(with: tableView,
            duration: 0.35,
            options: .transitionCrossDissolve,
            animations: { self.tableView.reloadData()
        })
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
                    toDoTopView.changeSection(section: index.section)
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
            topHeaderView.changeTitle(title: (TodoSection(rawValue: self.indexToSection[section]!)?.sectionTitle())!)
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
        //print(store.getTodoCards())
        pageIndex = 1
        self.tableView.reloadData()
        updateCountsTopView()
    }
}

extension TodoHubController: ActionSocialPostProtocol {
    
    func displayFacebookDetails(post: TodoSocialPost, indexPath: IndexPath) {
        openDetailsPage(todoSocialPost: post, indexPath: indexPath)
    }
    
    func displayBannerInfo() {
        if bannerMessageView.transform == .identity {
            UIView.animate(withDuration: 0.5, animations: {
                self.bannerMessageView.transform = CGAffineTransform(translationX: 0, y: -120)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                    self.hideApprovedView()
                })
                
            })
        }
    }
    
    func denyPostFromSocial(post: TodoSocialPost, indexPath: IndexPath) {
        TodoApi().denyPost(post.postId!, callback: {
            () -> Void in
            let notificationObj = ["alert":"Post denied",
                                   "subtitle":"The article will be ignored in future recommendations.",
                                   "type": "info",
                                   "sound":"default"
            ]
            let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
            
            //self.showBannerForNotification(pnotification)
            self.removeSocialPost(post, indexPath: indexPath)
        })
        
    }
    
    
    
    func approvePostFromSocialWithMessage(post: TodoSocialPost, indexPath: IndexPath, message: String) {
        TodoApi().approvePostWithMessage(post.postId!, message: message, callback: {
            () -> Void in
            let notificationObj = ["title":"Post approved",
                                   "subtitle":"The article has been scheduled for posting.",
                                   "type": "info",
                                   "sound":"default"
            ]
            let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
            
            //self.showBannerForNotification(pnotification)
            self.bannerMessageView.displayApproved()
            self.updateCountsTopView()
            self.reloadSocialPostCell(indexPath)
        })
            
        
    }
    
    func approvePostFromSocial(post: TodoSocialPost, indexPath: IndexPath) {
        let message = post.message ?? ""
        TodoApi().approvePostWithMessage(post.postId!, message: message, callback: {
            () -> Void in
            let notificationObj = ["title":"Post approved",
                                   "subtitle":"The article has been scheduled for posting.",
                                   "type": "info",
                                   "sound":"default"
            ]
            let pnotification = Mapper<PNotification>().map(JSONObject: notificationObj)!
            
            //self.showBannerForNotification(pnotification)
            self.bannerMessageView.displayApproved()
            self.updateCountsTopView()
            self.reloadSocialPostCell(indexPath)
        })
    }
    
    func reloadSocialPostCell(_ indexPath: IndexPath) {
        if indexPath.count < 2 { return }
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell is SocialPostInCardCell {
            let socialCell: SocialPostInCardCell = cell as! SocialPostInCardCell
            socialCell.setupStatusCardView()
        }
        
        
    }
    
}
