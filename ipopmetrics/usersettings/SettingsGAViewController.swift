//
//  SettingsGAViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsGAViewController: UITableViewController {

    var currentBrand: Brand?
    
    @IBOutlet weak var trackingNumber: UILabel!
    @IBOutlet weak var websiteUrl: UILabel!
    
    @IBOutlet weak var cellConnect: UITableViewCell!
    @IBOutlet weak var btnConnect: ConnectSettingsButton!
    @IBOutlet weak var constraintHeightBtnConnect: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        tableView.allowsSelection = false
        tableView.separatorColor = self.tableView.backgroundColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    private func updateView() {
        updateTextsColor()
        self.trackingNumber.text = currentBrand?.googleAnalytics?.tracker ?? "Not Connected"
        self.websiteUrl.text = currentBrand?.googleAnalytics?.name ?? "Not Connected"
        
        if let date = currentBrand?.googleAnalytics?.connectionDate {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            //self.connectionDateLabel.text = df.string(from: date)
        }
        
        self.tableView.beginUpdates()
        if isGoogleConnected() {
            constraintHeightBtnConnect.constant = 0
            btnConnect.typeButton = .disconnect
        } else {
            constraintHeightBtnConnect.constant = 44
            btnConnect.typeButton = .connect
        }
        self.tableView.endUpdates()
    }
    
    func updateTextsColor() {
        if isGoogleConnected() {
            self.trackingNumber.textColor = PopmetricsColor.visitSecondColor
            self.websiteUrl.textColor = PopmetricsColor.visitSecondColor
        } else {
            self.trackingNumber.textColor = PopmetricsColor.lightGray
            self.websiteUrl.textColor = PopmetricsColor.lightGray
        }
    }
    
    private func isGoogleConnected() -> Bool {
        if currentBrand?.googleAnalytics != nil {
            return true
        }
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView: UIView  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        var title: UILabel = UILabel()
        title.font = UIFont(name: FontBook.regular, size: 13)
        title.textColor = PopmetricsColor.textGraySettings
        
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        if section == 0 {
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
            title.text = "ACCOUNT DETAILS"
        } else {
            title.text = "CONNECTION"
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
        }
        
        return contentView
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.section == 1 && indexPath.row == 3) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.width, bottom: 0, right: 0)
        }
    }
    
    func setupNavigationBar() {
        
        let text = UIBarButtonItem(title: "GOOGLE ANALYTICS ACCOUNT", style: .plain, target: self, action: #selector(handlerClickBack))
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
