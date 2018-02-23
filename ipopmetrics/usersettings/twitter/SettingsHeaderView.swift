//
//  SettingsHeaderView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 22/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class SettingsHeaderView: UIView {

    lazy private var title: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.font = UIFont(name: FontBook.regular, size: 13)
        lbl.textColor = PopmetricsColor.textGraySettings
        lbl.text = "HEADER"
        return lbl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func layoutSubviews() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
    
    private func setupView() {
        self.addSubview(title)
    }
    
    func changeTitle(_ title: String) {
        self.title.text = title
    }
}
