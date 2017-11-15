//
//  ChangeBrandViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

protocol Brand: class {
    func changeBrandName(name: String)
}

class ChangeBrandViewController: UITableViewController {
    
    var previousIndex: IndexPath?
    var brandDelegate: Brand?
    var selectedBrand: String = ""
    var didChangedBrand: Bool = false
    
    let tmpBrands = ["Brand Name 1", "Brand Name 2", "Brand Name 3", "Brand Name 4", "Brand Name 5",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        setUpNavigationBar()
        
        registerCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func registerCell() {
        tableView.register(BrandTableViewCell.self, forCellReuseIdentifier: "brandId")
    }
    
    func setUpNavigationBar() {
        
        let text = UIBarButtonItem(title: "Change Brand", style: .plain, target: self, action: nil)
        text.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        text.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, text]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func handlerClickBack() {
        if didChangedBrand {
            UsersStore.brandIndex = (previousIndex?.row)!
            brandDelegate?.changeBrandName(name: selectedBrand)
        }
        self.navigationController?.dismissToDirection(direction: .left)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpBrands.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brandId", for: indexPath) as! BrandTableViewCell
        cell.brandName.text = tmpBrands[indexPath.row]
        if indexPath.row == UsersStore.brandIndex {
            cell.setupSelectedCell()
            previousIndex = indexPath
            selectedBrand = cell.brandName.text!
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if previousIndex != nil {
            let prevCell = tableView.cellForRow(at: previousIndex!) as! BrandTableViewCell
            prevCell.setDefault()
        }
        didChangedBrand = true
        previousIndex = indexPath
        guard let cell = tableView.cellForRow(at: indexPath) as? BrandTableViewCell else {
            return
        }
        selectedBrand = cell.brandName.text!
        cell.setupSelectedCell()
    }
    
}

