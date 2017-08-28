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
    //
    
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
    
    func setupView() {
        
        self.backgroundColor = UIColor.darkGray
        
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
        circleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 22).isActive = true
        circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        circleView.layer.cornerRadius = 7.5
        circleView.backgroundColor = UIColor.red
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
    func addGradient() {
        let gradientView = GradientView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        gradientView.startColor = PopmetricsColor.statisticsGradientStartColor
        gradientView.endColor = PopmetricsColor.statisticsGradientEndColor
        insertSubview(gradientView, belowSubview: circleView)
    }
}
