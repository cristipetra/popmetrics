//
//  SlideSecondView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 28/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class SlideSecondView: UIView {

    lazy private var titleLbl: UILabel = {
       let lbl = UILabel()
        lbl.text = "Personalized Business Insights"
        lbl.font = UIFont(name: FontBook.bold, size: 17)
        lbl.textColor = PopmetricsColor.darkGrey
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy private var subtitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"
        lbl.font = UIFont(name: FontBook.regular, size: 15)
        lbl.textColor = PopmetricsColor.textLight
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy private var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = #imageLiteral(resourceName: "emptyCard")
        imgView.contentMode = .scaleAspectFit
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
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        //constraints title
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        //titleLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        titleLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        titleLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        
        //constraints subtitle
        subtitleLbl.translatesAutoresizingMaskIntoConstraints = false
        subtitleLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        subtitleLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        subtitleLbl.topAnchor.constraint(equalTo: self.titleLbl.bottomAnchor, constant: 10).isActive = true
    }
    
    private func setupView() {
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
