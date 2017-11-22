//
//  BrandTableViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class BrandTableViewCell: UITableViewCell {
    
    lazy var brandName: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontBook.regular, size: 15)
        label.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        label.text = "Brand Name"
        return label
    }()
    
    lazy var checkedBtn: UIButton = {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "brandNameCheck"), for: .normal)
        button.isHidden = true
        return button
        
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setBrandConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBrandConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupSelectedCell() {
        
        brandName.font = UIFont(name: FontBook.bold, size: 15)
        brandName.textColor = PopmetricsColor.darkGrey
        checkedBtn.isHidden = false
    }
    
    func setDefault() {
        brandName.font = UIFont(name: FontBook.regular, size: 15)
        brandName.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        checkedBtn.isHidden = true
    }
    
    private func setBrandConstraints() {
        
        self.addSubview(brandName)
        brandName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        brandName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        brandName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60).isActive = true
        
        self.addSubview(checkedBtn)
        checkedBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        checkedBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkedBtn.widthAnchor.constraint(equalToConstant: 28).isActive = true
        checkedBtn.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
}

