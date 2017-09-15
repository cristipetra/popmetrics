//
//  RecommendedActionGoogleCitationView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class RecommendedActionGoogleCitationView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var backgroundImageVIew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var infoBtn: RoundButton!
    
    lazy var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontBook.bold, size: 15)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        Bundle.main.loadNibNamed("RecommendedActionGoogleCitationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight , .flexibleWidth ]
        setUpToolBar()
        
    }
    
    private func setUpTitle() {
        toolbarView.addSubview(title)
        title.leftAnchor.constraint(equalTo: self.toolbarView.leftAnchor, constant: 50).isActive = true
        title.centerYAnchor.constraint(equalTo: self.toolbarView.centerYAnchor, constant: 0).isActive = true
        title.textColor = UIColor.white
        
    }
    
    func changeColorCircle(color: UIColor) {
        circleView.backgroundColor = color
    }
    
    
    private func setupCircleView() {
        toolbarView.addSubview(circleView)
        circleView.leftAnchor.constraint(equalTo: self.toolbarView.leftAnchor, constant: 22).isActive = true
        circleView.centerYAnchor.constraint(equalTo: self.toolbarView.centerYAnchor, constant: 0).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        circleView.layer.cornerRadius = 7.5
        circleView.backgroundColor = UIColor.red
    }
    
    
    
    private func setUpToolBar() {
        
        setUpTitle()
        setupCircleView()
        toolbarView.backgroundColor = PopmetricsColor.darkGrey
        title.text = "Recommended Action"
        changeColorCircle(color: UIColor(red: 255/255, green: 189/255, blue: 80/255, alpha: 1))
        
    }
    
}

