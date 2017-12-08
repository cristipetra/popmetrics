//
//  ToolbarViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class ToolbarViewCell: UIView {
    
    // VIEW
    lazy var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var leftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontBook.bold, size: 15)
        return label
    }()
    
    lazy var gradientLayer: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = PopmetricsColor.statisticsGradientStartColor
        view.endColor = PopmetricsColor.statisticsGradientEndColor
        return view
    }()
    
    lazy var circleTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
        
    }()
    
    lazy var circleBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
        
    }()
    // End View
    
    var isLeftImageHidden: Bool = true {
        didSet {
            didSetImageVisibility()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCorners()
        gradientLayer.frame = self.bounds
    }
    
    func setupView() {
        
        self.backgroundColor = UIColor.white
        
        setupCircleView()
        setupLeftImageView()
        
        //title
        self.addSubview(title)
        title.text = "Schedule"
        title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        title.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        title.textColor = UIColor.white
        setupCorners()
        
        didSetImageVisibility()
        
    }
    
    internal func setupCircleView() {
        self.addSubview(circleView)
        circleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17).isActive = true
        circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        circleView.layer.cornerRadius = 6
        circleView.backgroundColor = PopmetricsColor.myActionCircle
        
    }
    
    func setUpCircleBackground(topColor: UIColor , bottomColor: UIColor) {
        
        circleView.addSubview(circleTopView)
        circleView.addSubview(circleBottomView)
        circleView.clipsToBounds = true
        
        circleTopView.topAnchor.constraint(equalTo: circleView.topAnchor).isActive = true
        circleTopView.leftAnchor.constraint(equalTo: circleView.leftAnchor).isActive = true
        circleTopView.rightAnchor.constraint(equalTo: circleView.rightAnchor).isActive = true
        circleTopView.bottomAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true
        circleTopView.backgroundColor = topColor
        
        circleBottomView.topAnchor.constraint(equalTo: circleView.centerYAnchor).isActive = true
        circleBottomView.leftAnchor.constraint(equalTo: circleView.leftAnchor).isActive = true
        circleBottomView.rightAnchor.constraint(equalTo: circleView.rightAnchor).isActive = true
        circleBottomView.bottomAnchor.constraint(equalTo: circleView.bottomAnchor).isActive = true
        circleBottomView.backgroundColor = bottomColor
        
    }
    
    internal func setupLeftImageView() {
        self.addSubview(leftImage)
        leftImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 22).isActive = true
        leftImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        leftImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        leftImage.heightAnchor.constraint(equalToConstant: 15).isActive = true
        leftImage.image = UIImage(named: "iconCtaTodo")
        
    }
    
    internal func didSetImageVisibility() {
        circleView.isHidden = !isLeftImageHidden
        leftImage.isHidden = isLeftImageHidden
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.roundCorners(corners: [.topRight, .topLeft] , radius: 12)
        }
    }
    
    func changeColorCircle(color: UIColor) {
        circleView.backgroundColor = color
    }
    
}

extension ToolbarViewCell {
    func setupGradient() {
        self.insertSubview(gradientLayer, belowSubview: circleView)
        gradientLayer.frame = self.bounds
        gradientLayer.leftAnchor.constraint(equalTo: self.leftAnchor)
        gradientLayer.rightAnchor.constraint(equalTo: self.rightAnchor)
        gradientLayer.topAnchor.constraint(equalTo: self.topAnchor)
        gradientLayer.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    }
}

