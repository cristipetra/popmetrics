//
//  OfflineBanner.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 05/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class OfflineBanner: UIView {
    
    lazy var messageLbl: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 150, height: 18))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "OpenSans-SemiBold", size: 12)
        label.textColor = UIColor.white
        return label
    }()
    lazy var iconView: UIImageView = {
        let iconImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 17))
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        return iconImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup();
    }
    
    func setup() {
        self.clipsToBounds = true
        self.addSubview(iconView)
        self.backgroundColor = PopmetricsColor.salmondColor
        iconView.image = UIImage(named: "iconAlertMessage")
        self.addSubview(messageLbl)
        NSLayoutConstraint.activate([
            iconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25),
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50),
            messageLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            messageLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            messageLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
            ]
        )
        messageLbl.text = "You are currently offline. Actions will be paused until connection is re-established."
        messageLbl.numberOfLines = 0
    }
}

