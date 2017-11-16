//
//  SettingsBaseViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsBaseViewController: UIViewController {

    private var titleButton: UIBarButtonItem!
    private let titleLabel: UILabel = UILabel()
    internal var cancelButton: UIBarButtonItem!
    internal var doneButton: UIBarButtonItem!
    
    internal var titleWindow: String = "" {
        didSet {
            updateTitle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateTitle() {
        titleLabel.text = titleWindow
        if titleButton != nil {
            titleButton.title = titleWindow
        }
    }
    
    private func addTitleView() {
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        
        setTitleFont(titleView: titleView)
        self.navigationItem.titleView = titleView
    }
    
    private func setTitleFont(titleView: UIView) {
        titleLabel.textColor = UIColor.black
        if UIScreen.main.bounds.width < 375 {
            titleLabel.font = UIFont(name: FontBook.semibold, size: 14)
            titleView.frame = CGRect(x: 0, y: 0, width: 130, height: 20)
            titleLabel.frame = CGRect(x: 0, y: 0, width: 130, height: 20)
        } else {
            titleLabel.font = UIFont(name: FontBook.semibold, size: 17)
            titleLabel.frame = CGRect(x: 0, y: 0, width: 170, height: 20)
            titleView.frame = CGRect(x: 0, y: 0, width: 170, height: 20)
        }
        
    }
    
    internal func setupNavigationBar() {
        titleLabel.textAlignment = .center
        let sideBtnFont: UIFont!
        
       addTitleView()
        
        if UIScreen.main.bounds.width < 375 {
            sideBtnFont = UIFont(name: FontBook.semibold, size: 14)
        } else {
            sideBtnFont = UIFont(name: FontBook.semibold, size: 17)
        }
        
        cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelHandler))
        cancelButton.tintColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: sideBtnFont], for: .normal)
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneHandler))
        doneButton.tintColor = UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1)
        doneButton.setTitleTextAttributes([NSAttributedStringKey.font: sideBtnFont], for: .normal)
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func setupNavigationWithBackButton() {
        titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: nil)
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, titleButton]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneHandler() {
        
    }
    
    @objc func cancelHandler() {
        
    }

}
