//
//  SettingsTwitterViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class SettingsTwitterViewController: UITableViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tracker: UILabel!
    
    internal var currentBrand: Brand?
    @IBOutlet weak var btnConnect: ConnectSettingsButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        updateView()
        btnConnect.typeButton = .disconnect
        
    }
    
    internal func updateView() {
        name.text = currentBrand?.twitterDetails?.screenName ?? "N/A"
        tracker.text = currentBrand?.twitterDetails?.name ?? "N/A"
    }
    
    func setupNavigationBar() {
        
        let text = UIBarButtonItem(title: "TWITTER DETAILS", style: .plain, target: self, action: #selector(handlerClickBack))
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
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    

}
