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
    internal var isValuesChanged: Bool = false
    
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
        
        phoneText.delegate = self
        faxText.delegate = self
        emailText.delegate = self
        addressText.delegate = self
        unitText.delegate = self
        cityText.delegate = self
        stateText.delegate = self
        zipText.delegate = self
        
        setupNavigationBar()
        self.titleWindow = "CONTACT DETAILS"
        
        businessContact = BusinessContact()
        
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
                    self.navigationController?.popViewController(animated: true)
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
        if !didDisplayAlert && isValuesChanged {
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
        SettingsApi().postBusinessContact(businessContact, brandId: (UserStore.currentBrand?.id)!) { (brand) in
            
        }
        
        self.navigationController?.popViewController(animated: true)
    }

}

extension BusinessContactDetailsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneText {
            if textField.text != businessContact.phone {
                businessContact.phone = textField.text!
                isValuesChanged = true
            }
        }
        if textField == faxText {
            if textField.text != businessContact.fax {
                businessContact.fax = textField.text!
                isValuesChanged = true
            }
        }
        if textField == emailText {
            if textField.text != businessContact.businessEmail {
                businessContact.businessEmail = textField.text!
                isValuesChanged = true
            }
        }
        if textField == addressText {
            if textField.text != businessContact.address {
                businessContact.address = textField.text!
                isValuesChanged = true
            }
        }
        if textField == unitText {
            if textField.text != businessContact.unit {
                businessContact.unit = textField.text!
                isValuesChanged = true
            }
        }
        if textField == cityText {
            if textField.text != businessContact.city {
                businessContact.city = textField.text!
                isValuesChanged = true
            }
        }
        if textField == stateText {
            if textField.text != businessContact.state {
                businessContact.state = textField.text!
                isValuesChanged = true
            }
        }
        if textField == zipText {
            if textField.text != businessContact.zipCode {
                businessContact.zipCode = textField.text!
                isValuesChanged = true
            }
        }

    }
}
