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
    
    var selectedBrand: String = ""
    var didChangedOverlay: Bool = false
    var firstTimeSetOverlay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        registerCell()
        setupNavigationBar()
        titleWindow = "Overlay Action"
        
    }
    
    override func cancelHandler() {
        self.navigationController?.popViewController(animated: true)
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
        if indexPath == UsersStore.overlayIndex {
            cell.setupSelectedCell()
            selectedBrand = cell.brandName.text!
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didChangedOverlay = true
        if firstTimeSetOverlay {
            guard let cell = tableView.cellForRow(at: UsersStore.overlayIndex) as? BrandTableViewCell else {
                return
            }
            cell.setDefault()
            firstTimeSetOverlay = false
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? BrandTableViewCell else {
            return
        }
        UsersStore.overlayIndex = indexPath
        selectedBrand = cell.brandName.text!
        cell.setupSelectedCell()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let prevCell = tableView.cellForRow(at: indexPath) as! BrandTableViewCell
        prevCell.setDefault()
    }
    
}
