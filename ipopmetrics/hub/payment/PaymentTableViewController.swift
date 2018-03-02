//
//  PaymentTableViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 01/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class PaymentTableViewController: UITableViewController {

    @IBOutlet weak var textViewTerms: UITextView!
    @IBOutlet weak var lblTerms: UILabel!
    var muutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        
        changeTextColor()
    }
    
    func changeTextColor() {
        muutableString = NSMutableAttributedString(string: textViewTerms.text!, attributes: [NSAttributedStringKey.font:UIFont(name: FontBook.regular, size: 17.0)!])
        muutableString.addAttribute(.link, value: "https://www.popmetrics.io", range: NSRange(location: 108, length: 20))
        muutableString.addAttribute(.link, value: "https://www.popmetrics.io", range: NSRange(location: 132, length: 16))
        textViewTerms.attributedText = muutableString
    }
    
    private func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "Payment Confirmation", style: .plain, target: self, action: #selector(handlerClickBack))
        text.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
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
extension PaymentTableViewController: UITextFieldDelegate {
    
}
