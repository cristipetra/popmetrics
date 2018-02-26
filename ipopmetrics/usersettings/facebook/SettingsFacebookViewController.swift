//
//  SettingsFacebookViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class SettingsFacebookViewController: UITableViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tracker: UILabel!
    @IBOutlet weak var constraintHeightBtnConnect: NSLayoutConstraint!
    
    internal var currentBrand: Brand?
    private var requiredActionHandler: RequiredActionHandler = RequiredActionHandler()
    
    @IBOutlet weak var btnConnect: ConnectSettingsButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        self.tableView.separatorColor = UIColor.feedBackgroundColor()
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(handlerFacebookConnected), name: Notification.Popmetrics.RemoteMessage, object: nil)
    }
    
    internal func updateView() {
        name.text = currentBrand?.facebookDetails?.screenName ?? "N/A"
        tracker.text = currentBrand?.facebookDetails?.name ?? "N/A"
        
        if isFacebookConnected() {
            btnConnect.typeButton = .disconnect
            constraintHeightBtnConnect.constant = 0
        } else {
            btnConnect.typeButton = .connect
            constraintHeightBtnConnect.constant = 44
        }
    
    }
    
    func setupNavigationBar() {
        
        let text = UIBarButtonItem(title: "FACEBOOK DETAILS", style: .plain, target: self, action: #selector(handlerClickBack))
        text.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 17)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .selected)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: SettingsHeaderView = SettingsHeaderView()
        headerView.changeTitle("ACCOUNT DETAILS")
        return headerView
    }
    
    private func isFacebookConnected() -> Bool {
        if currentBrand?.facebookDetails != nil {
            return true
        }
        return false
    }
    
    private func connectSocial() {
        requiredActionHandler.connectFacebook(viewController: self, item: nil)
    }
    
    private func disconnectSocial() {
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handlerFacebookConnected() {
        fetchBrandDetails()
    }
    
    func fetchBrandDetails() {
        let currentBrandId = UserStore.currentBrandId
        UsersApi().getBrandDetails(currentBrandId) { brand in
            UserStore.currentBrand = brand!
            
            self.currentBrand = brand!
            self.updateView()
        }
    }
    
    @IBAction func handlerChangeConnectOrDisconnect(_ sender: Any) {
        if isFacebookConnected() {
            disconnectSocial()
        } else {
            connectSocial()
        }
    }
    
    
}

