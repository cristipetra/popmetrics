//
//  SettingsOverlayActionViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsOverlayActionViewController: SettingsBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: [String] = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
    
    var previousIndex: IndexPath?
    var selectedBrand: String = ""
    var didChangedBrand: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
        setupNavigationBar()
        titleWindow = "Overlay Action"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func registerCell() {
        tableView.register(BrandTableViewCell.self, forCellReuseIdentifier: "brandId")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brandId", for: indexPath) as! BrandTableViewCell
        cell.brandName.text = dataSource[indexPath.row]
        if indexPath.row == UsersStore.overlayIndex {
            cell.setupSelectedCell()
            previousIndex = indexPath
            selectedBrand = cell.brandName.text!
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    override func cancelHandler() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

