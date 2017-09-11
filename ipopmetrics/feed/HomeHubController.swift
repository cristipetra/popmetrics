//
//  FeedTableViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import GoogleSignIn
import MGSwipeTableCell
import DGElasticPullToRefresh
import BubbleTransition
import EZAlertController

class HomeHubViewController: BaseTableViewController, GIDSignInUIDelegate {
    
    fileprivate var sharingInProgress = false
    
    let sectionToIndex = ["Required Actions": 0,
                           "Insights": 1]
    
    let indexToSection = [0:"Required Actions",
                          1:"Insights"]
        
    
    
    var requiredActionHandler = RequiredActionHandler()
    let store = FeedStore.getInstance()
    
    var shouldDisplayCell = true
    var isInfoCellType = false;
    var toDoCellHeight = 50 as CGFloat
    var isToDoCellType = false
    var isTrafficCard = false
    
    let transition = BubbleTransition();
    var transitionButton:UIButton = UIButton();
    let transitionView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    var isAnimatingHeader = false
    
    var currentBrandId = UsersStore.currentBrandId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
      
        // Style elements
        self.view.backgroundColor = UIColor.feedBackgroundColor()
        setUpNavigationBar()
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tabBarController?.delegate = self
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:NSNotification.Name(rawValue: "CardActionNotification"), object:nil, queue:nil, using:catchCardActionNotification)
      
        let requiredActionNib = UINib(nibName: "RequiredAction", bundle: nil)
        tableView.register(requiredActionNib, forCellReuseIdentifier: "requiredActionId")
        
        let sectionHeaderNib = UINib(nibName: "HeaderCardCell", bundle: nil)
        tableView.register(sectionHeaderNib, forCellReuseIdentifier: "headerCell")
        
        let lastCellNib = UINib(nibName: "LastCard", bundle: nil)
        tableView.register(lastCellNib, forCellReuseIdentifier: "LastCard")
        
        let toDoCardNib = UINib(nibName: "ToDoCell", bundle: nil)
        tableView.register(toDoCardNib, forCellReuseIdentifier: "ToDoCell")
        
        let recommendedNib = UINib(nibName: "RecommendedCell", bundle: nil)
        tableView.register(recommendedNib, forCellReuseIdentifier: "recommendedId")
        
        let trafficNib = UINib(nibName: "TrafficCard", bundle: nil)
        tableView.register(trafficNib, forCellReuseIdentifier: "TrafficCard")
        
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        
        loadingView.tintColor = PopmetricsColor.darkGrey
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.fetchItems(silent:false)
            self?.tableView.dg_stopLoading()
            self?.tableView.reloadData()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(PopmetricsColor.yellowBGColor)
        tableView.dg_setPullToRefreshBackgroundColor(PopmetricsColor.darkGrey)
        
        setupTopHeaderView()
        
        addImageOnLastCard()
        
        if(store.getFeedCards().count == 0) {
            tableView.isHidden = true
            self.fetchItems(silent:false)
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handlerDidChangeTwitterConnected(_:)), name: Notification.Name("didChangeTwitterConnected"), object: nil);
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tableView.contentOffset = CGPoint(x: 0, y: 50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.alpha = 1
        let tabInfo = MainTabInfo.getInstance()
        let xValue = tabInfo.currentItemIndex >= tabInfo.lastItemIndex ? CGFloat(20) : CGFloat(-20)
        UIView.transition(with: tableView,
                          duration: 0.22,
                          animations: {
                            self.tableView.alpha = 1
        })
    }

    
    
    func addImageOnLastCard() {
        let image = UIImage(named: "end_of_feed")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.frame = CGRect(x: 0, y: self.view.frame.height - 350, width: self.view.frame.width, height: 300)
    }
    
    func setupTopHeaderView() {
        if topHeaderView == nil {
            topHeaderView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0))
            self.view.addSubview(topHeaderView)
        }
    }

    
    func fetchItems(silent:Bool) {
//        let path = Bundle.main.path(forResource: "sampleFeed", ofType: "json")
//        let jsonData : NSData = NSData(contentsOfFile: path!)!
        FeedApi().getItems(currentBrandId) { responseWrapper, error in
            
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
                self.store.updateFeed((responseWrapper?.data)!)
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    internal func setUpNavigationBar() {
        let text = UIBarButtonItem(title: "Home Feed", style: .plain, target: self, action: nil)
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
    
    
    func handlerClickMenu() {
        let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MENU_VC") as! MenuViewController
        // customization:
        modalViewController.modalTransition.edge = .left
        modalViewController.modalTransition.radiusFactor = 0.3
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    func catchCardActionNotification(notification:Notification) -> Void {
        
        self.hideProgressIndicator()
        guard let userInfo = notification.userInfo,
            let success    = userInfo["success"] as? Bool
            else {
                self.presentAlertWithTitle("Error", message: "Unexpected error!. Incomplete error recovery data.")
                return
            }
        
        if !success {
            self.presentAlertWithTitle("Error", message: userInfo["message"] as! String ?? "Unknown error")
        }
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return self.store.getFeedCards().count + 1
        print("count \(sectionToIndex.count)");
        return sectionToIndex.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == sectionToIndex.count) {
            return 1
        }
        return store.getFeedCardsWithSection(indexToSection[section]!).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionIdx = (indexPath as NSIndexPath).section
        let rowIdx = (indexPath as NSIndexPath).row
        
        
        if(indexPath.section == sectionToIndex.count) {
            shouldDisplayCell = true
            isInfoCellType = true
            isTrafficCard = false
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
            cell.changeTitleWithSpacing(title: "You're all caught up.")
            cell.changeMessageWithSpacing(message: "Find more actions to improve your business tomorrow!")
            cell.selectionStyle = .none
            cell.goToButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
            return cell
        }
        
        let sectionCards = store.getFeedCardsWithSection(indexToSection[sectionIdx]!)
        let item = sectionCards[rowIdx]
        
        isToDoCellType = false
        isInfoCellType = false
        isTrafficCard = false
        switch(item.type) {    
            case "required_action":
                shouldDisplayCell = true
                let cell = tableView.dequeueReusableCell(withIdentifier: "requiredActionId", for: indexPath) as! RequiredAction
                cell.selectionStyle = .none
        
                cell.footerView.layer.backgroundColor = UIColor.clear.cgColor
                cell.footerView.approveLbl.textColor = UIColor.white
                cell.footerView.xButton.isHidden = true
                cell.configure(item, handler: self.requiredActionHandler)
                cell.infoDelegate = self
                if(sectionCards.count-1 == indexPath.row) {
                    cell.connectionLineView.isHidden = true;
                }
                return cell
            case "insight":
                shouldDisplayCell = true
                isTrafficCard = false
                let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedId", for: indexPath) as! RecommendedCell
                cell.setUpCell(type: "Popmetrics Insight")
                if(sectionCards.count-1 == indexPath.row) {
                    cell.connectionLine.isHidden = true;
                }
                cell.footerVIew.actionButton.addTarget(self, action: #selector(handlerInsightButton), for: .touchUpInside)
                cell.footerVIew.informationBtn.addTarget(self, action: #selector(showTooltip(_:)), for: .touchUpInside)
                return cell
            case "todo":
                shouldDisplayCell = true
                isToDoCellType = true
                let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as!
                ToDoCell
                cell.toDoCountView.numberOfRows = 2
                cell.toDoCountViewHeight.constant = CGFloat(cell.toDoCountView.numberOfRows * 60 + 122)
                toDoCellHeight = cell.toDoCountViewHeight.constant
                cell.selectionStyle = .none
                cell.setHeaderTitle(title: "Snapshot")
                
                cell.footerView.informationBtn.addTarget(self, action: #selector(showTooltip(_:)), for: .touchUpInside)
                return cell

            case "info":
                shouldDisplayCell = true
                isInfoCellType = true
                isTrafficCard = false
                let cell = tableView.dequeueReusableCell(withIdentifier: "LastCard", for: indexPath) as! LastCardCell
                cell.changeTitleWithSpacing(title: "You're all caught up.")
                cell.changeMessageWithSpacing(message: "Find more actions to improve your business tomorrow!")
                cell.selectionStyle = .none
                cell.goToButton.addTarget(self, action: #selector(goToNextTab), for: .touchUpInside)
                return cell
        case "traffic":
                isTrafficCard = true
                let cell = tableView.dequeueReusableCell(withIdentifier: "TrafficCard", for: indexPath) as! TrafficCardViewCell
                cell.selectionStyle = .none
                cell.connectionLine.isHidden = true
                cell.backgroundColor = UIColor.feedBackgroundColor()
                return cell

            default:
                shouldDisplayCell = false
                let cell = UITableViewCell()
                return cell
        }
        
    }
    
    func handlerInsightButton() {
        UsersStore.isInsightShowed = true
        goToNextTab()
    }
    
    @objc private func goToNextTab() {
        self.tabBarController?.selectedIndex += 1
    }
    
    var shouldDisplayHeaderCell = false
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == sectionToIndex.count) {
            let cell = UITableViewCell()
            return cell
        }
        let sectionCards = store.getFeedCardsWithSection(indexToSection[section]!)
        var itemType = "unknown"
        if sectionCards.count > 0 {
            itemType = sectionCards[0].type
        }
        
        
        switch itemType {
        case "required_action" :
            shouldDisplayHeaderCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(cardType: .required)
            cell.sectionTitleLabel.text = "Required Actions";
            return cell
            
        case "todo":
            shouldDisplayHeaderCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(cardType: .todo)
            cell.sectionTitleLabel.text = "To Do"
            return cell
            
        case "recommended":
            shouldDisplayHeaderCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(cardType: .recommended)
            cell.sectionTitleLabel.text = "Recommended For You";
            return cell
            
        case "traffic":
            shouldDisplayHeaderCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(cardType: .traffic)
            cell.sectionTitleLabel.text = "Traffic Intelligence";
            return cell
        case "insight":
            shouldDisplayHeaderCell = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCardCell
            cell.changeColor(cardType: .insight)
            cell.sectionTitleLabel.text = "Recommended For You";
            return cell
        default:
            shouldDisplayHeaderCell = false
            let cell = UITableViewCell()
            return cell
        }
    }

    
    /*
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCellHeight()
    }
     */
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print(shouldDisplayHeaderCell)
        var height: CGFloat = 0;
        if( section == indexToSection.count) {
            return 0
        }
        
        let sectionCards = store.getFeedCardsWithSection(indexToSection[section]!)
        if sectionCards.count > 0 {
            let item = sectionCards[0]
            
            
            if( item.type == "required_action") {
                height = (UsersStore.isTwitterConnected) ? 80 : 80
            }
            
            if( item.type == "todo") {
                height = 80;
            }
            if( item.type == "recommended") {
                height = 80
            }
            if (item.type == "traffic") {
                height = 80
            }
            if (item.type == "insight") {
                height = 80
            }
        }
        
        return height
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isToDoCellType {
            return toDoCellHeight
        } else if isTrafficCard {
            return 424
        }
        
        return shouldDisplayCell ? getCellHeight() : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if SID_DETAILS_NAV_VC == segue.identifier {
//            let dest = segue.destination as! PropertyDetailsNavigationController
//            dest.property = getPropertyForIndexPath(selectedIndexPath!)
//        }
    }

    
    fileprivate func getCellHeight() -> CGFloat {
        let a =  CGFloat(((tableView.frame.width * 9.0) / 16.0) + 16) // 16 is the padding
        var heightCell: CGFloat = 479
        if(isInfoCellType) {
            heightCell = 261
        }
        return heightCell
        // return a
    }
    
    
    fileprivate func createSwipeButtons() -> [MGSwipeButton] {
        let deleteBtn = MGSwipeButton(
            title: "Action",
            icon: UIImage(named: "ic_delete_white"),
            backgroundColor: PopmetricsColor.redMedium,
            callback: { (sender: MGSwipeTableCell!) -> Bool in
                
                let alert = UIAlertController(title: "Action 1?",
                                              message: "Are you sure ? ... ", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (alert: UIAlertAction!) -> Void in
                    
//                    let cell =  sender as! FeedTableViewCell
//                    cell.property.deletedAt = NSDate()
//                    PropertiesStore.getInstance().saveState()
                }
                let noAction = UIAlertAction(title: "No", style: .default) { (alert: UIAlertAction!) -> Void in
                    //print("You pressed Cancel")
                }
                
                alert.addAction(yesAction)
                alert.addAction(noAction)
                
                self.present(alert, animated: true, completion:nil)
                
                return true
        }
        )
        deleteBtn.centerIconOverText()
        deleteBtn.setPadding(8)
        
        let shareBtn = MGSwipeButton(
            title: "Action2",
            icon: UIImage(named: "ic_share_white"),
            backgroundColor: PopmetricsColor.blueMedium,
            callback: { (sender: MGSwipeTableCell!) -> Bool in
                print("Pressed Share")
                return true
                
        }
        )
        shareBtn.centerIconOverText()
        shareBtn.setPadding(8)
        
        //        let reviewBtn = MGSwipeButton(
        //            title: "Review",
        //            icon: UIImage(named: "ic_favorite_white"),
        //            backgroundColor: HomzenColor.grayMedium,
        //            callback: { (sender: MGSwipeTableCell!) -> Bool in
        //                print("Pressed Review")
        //                return true
        //        }
        //        )
        //        reviewBtn.centerIconOverText()
        //        reviewBtn.setPadding(8)
        
        return [deleteBtn, shareBtn]
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var fixedHeaderFrame = self.topHeaderView.frame
        fixedHeaderFrame.origin.y = 0 + scrollView.contentOffset.y
        topHeaderView.frame = fixedHeaderFrame
        
        if let indexes = tableView.indexPathsForVisibleRows {
            for index in indexes {
                let indexPath = IndexPath(row: 0, section: index.section)
                guard let lastRowInSection = indexes.last , indexes.first?.section == index.section else {
                    return
                }
                let headerFrame = tableView.rectForHeader(inSection: index.section)
                
                let frameOfLastCell = tableView.rectForRow(at: lastRowInSection)
                let cellFrame = tableView.rectForRow(at: indexPath)
                if headerFrame.origin.y + 50 < tableView.contentOffset.y {
                    topHeaderView.changeTitle(title: indexToSection[index.section]!)
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
    
    func animateHeader(colapse: Bool) {
        if (self.isAnimatingHeader) {
            return
        }
        self.isAnimatingHeader = true
        UIView.animate(withDuration: 0.3, animations: {
            if colapse {
                self.topHeaderView.frame.size.height = 0
                self.topHeaderView.circleView.isHidden = true
                self.topHeaderView.statusLbl.isHidden = true
            } else {
                self.topHeaderView.frame.size.height = 30
                self.topHeaderView.circleView.isHidden = false
                self.topHeaderView.statusLbl.isHidden = false
            }
            self.topHeaderView.layoutIfNeeded()
        }, completion: { (completed) in
            self.isAnimatingHeader = false
        })
    }
    
    ///
    
    @objc func handleRequiredAction(_ sender : UIButton){
        print("handling required action")
    }
    
    
    
}

// MARK: UIViewControllerTransitioningDelegate

extension HomeHubViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = PopmetricsColor.yellowBGColor
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = PopmetricsColor.yellowBGColor
        return transition
    }
    
}

extension HomeHubViewController: InfoButtonDelegate {
    
    //
    func sendInfo(_ sender: UIButton) {
        self.requiredActionHandler.showBanner(bannerType: .success)
        //showTooltip(sender)
    }
    
    func showTooltip(_ sender: UIButton) {
        let infoCardVC = AppStoryboard.Boarding.instance.instantiateViewController(withIdentifier: "InfoCardViewID") as! InfoCardViewController;
        
        infoCardVC.transitioningDelegate = self
        infoCardVC.modalPresentationStyle = .custom
        
        transitionButton = sender
        infoCardVC.modalPresentationStyle = .overCurrentContext
        
        self.present(infoCardVC, animated: true, completion: nil)
    }
}


// MARK: UITabBarControllerDelegate
extension HomeHubViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = tabBarController.selectedIndex
    }
}

enum CardType: String {
    case required = "required"
    case recommended = "recommended"
    case todo = "todo"
    case traffic = "traffic"
    case insight = "insight"
}
