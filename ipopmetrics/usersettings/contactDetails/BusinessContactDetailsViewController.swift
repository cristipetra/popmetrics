//
//  BusinessContactDetailsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/01/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class BusinessContactDetailsViewController: SettingsBaseTableViewController {
    
    private var didDisplayAlert: Bool = false
    private var isChanges: Bool = false
    
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var faxText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var unitText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var zipText: UITextField!
    
    private var businessContact: BusinessContact!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = PopmetricsColor.tableBackground
        
        setupNavigationBar()
        self.titleWindow = "CONTACT DETAILS"
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contentView: UIView  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        let title: UILabel = UILabel()
        title.font = UIFont(name: FontBook.regular, size: 13)
        title.textColor = PopmetricsColor.textGraySettings
        title.text = "PRIMARY LOCATION"
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        if section == 0 {
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        } else {
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true
        }
        
        return contentView
    }
    
    internal func configure(businessContact: BusinessContact) {
        phoneText.text = businessContact.phone
        faxText.text = businessContact.fax
        emailText.text = businessContact.businessEmail
        addressText.text = businessContact.address
        unitText.text = businessContact.unit
        cityText.text = businessContact.city
        stateText.text = businessContact.state
        zipText.text = businessContact.zipCode
    }
    
    @objc override func cancelHandler() {
        if shouldDisplayAlert() {
            didDisplayAlert = true
            Alert.showAlertDialog(parent: self, action: { (action) -> (Void) in
                switch action {
                case .cancel:
                    //self.navigationController?.popViewController(animated: true)
                    break
                case .save:
                    self.createBusinessLocation()
                    break
                default:
                    break
                }
            })
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func shouldDisplayAlert() -> Bool {
        if !didDisplayAlert && isChanges {
            return true
        } else {
            return false
        }
        return true
    }
    
    @objc override func doneHandler() {
        createBusinessLocation()
    }
    
    private func createBusinessLocation() {
        self.navigationController?.popViewController(animated: true)
    }

}
