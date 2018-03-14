//
//  SlideFirstView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 08/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class SlideFirstView: UIView {
    
    lazy private var logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "logoPop")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    lazy private var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = UIFont(name: FontBook.bold, size: 18)
        lbl.textColor = PopmetricsColor.borderButton
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy private var subtitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = UIFont(name: FontBook.regular, size: 18)
        lbl.textColor = PopmetricsColor.borderButton
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy private var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "emptyCard")
        imgView.contentMode = Utils.isIphoneX ? .scaleAspectFit : .scaleAspectFill
        imgView.clipsToBounds = false
        return imgView
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
        
        //setup constraints image view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        //logo image view
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 55).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 43).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 196).isActive = true
        
        //constraints title
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        //titleLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        titleLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        titleLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 125).isActive = true
        
        //constraints subtitle
        subtitleLbl.translatesAutoresizingMaskIntoConstraints = false
        subtitleLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        subtitleLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        subtitleLbl.topAnchor.constraint(equalTo: self.titleLbl.bottomAnchor, constant: 10).isActive = true
    }
    
    private func setupView() {
        self.addSubview(logoImageView)
        self.addSubview(imageView)
        self.addSubview(titleLbl)
        self.addSubview(subtitleLbl)
    }
    
    internal func setTitle(_ title: String) {
        self.titleLbl.text = title
    }
    
    internal func setSubtitle(_ subtitle: String) {
        self.subtitleLbl.text = subtitle
    }
    
    internal func setImage(imageName: String) {
        self.imageView.image = UIImage(named: imageName)
    }
    
}

