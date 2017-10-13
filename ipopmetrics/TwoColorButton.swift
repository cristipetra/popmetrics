//
//  TwoColorButton.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 11/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class TwoColorButton: UIButton {
    
    var indexPath: IndexPath!
    
    @IBInspectable var topColor : UIColor = UIColor.white{
        didSet {
            setupTwoColorView(colors: [topColor, bottomColor])
        }
    }
    
    @IBInspectable var bottomColor : UIColor = UIColor.white{
        didSet {
            setupTwoColorView(colors: [topColor, bottomColor])
        }
    }
    
    @IBInspectable var labelText : String? {
        didSet {
            self.changeLabelText()
        }
    }
    
    @IBInspectable var image : UIImage? {
        didSet {
            image = image?.withRenderingMode(.alwaysTemplate)
            self.changeImage()
        }
    }
    
    var topView: UIView = UIView()
    var bottomView: UIView =  UIView()
    var imgView: UIImageView = UIImageView()
    var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        topView.isUserInteractionEnabled = false
        bottomView.isUserInteractionEnabled = false
        imgView.isUserInteractionEnabled = false
        label.isUserInteractionEnabled = false
        self.layer.masksToBounds = false
        DispatchQueue.main.async {
            self.addShadowForRoundedButton()
        }
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topView)
        self.addSubview(bottomView)
        self.addSubview(label)
        self.addSubview(imgView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.leftAnchor.constraint(equalTo: self.leftAnchor),
            topView.rightAnchor.constraint(equalTo: self.rightAnchor),
            topView.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            bottomView.topAnchor.constraint(equalTo: self.centerYAnchor),
            bottomView.leftAnchor.constraint(equalTo: self.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 17),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 9),
            label.heightAnchor.constraint(equalToConstant: 14),
            imgView.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 8),
            imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            imgView.heightAnchor.constraint(equalToConstant: 23)
            ]
        )
        
        self.addTarget(self, action: #selector(animationHandler), for: .touchUpInside)
    }
    
    internal func animationHandler() {
       
    }
    
    func addShadowForRoundedButton() {
        let shadowView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = UIColor.black
        shadowView.layer.opacity = 0.5
        shadowView.layer.cornerRadius = self.bounds.size.width / 2
        print(self.subviews)
        shadowView.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + 10), size: CGSize(width: self.bounds.width, height: self.bounds.height))
        self.addSubview(shadowView)
        print(self.subviews)
    }
    
    func changeLabelText() {
        print("change text")
        let attribute = [
            NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 14),
            NSForegroundColorAttributeName: PopmetricsColor.todoBrown
        ]
        let attrString = NSAttributedString(string: labelText!, attributes: attribute)
        label.attributedText = attrString
        self.bringSubview(toFront: label)
    }
    
    func changeImage() {
        imgView.image = self.image
        self.bringSubview(toFront: imgView)
        imgView.contentMode = .scaleAspectFill
        imgView.tintColor = PopmetricsColor.todoBrown
    }
    
    func changeImgConstrain(value: Int) {
        label.removeFromSuperview()
        
        imgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(value)).isActive = true
    }
}

extension UIView {
    func setupTwoColorView(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        var colorsArray: [CGColor] = []
        var locationsArray: [NSNumber] = []
        for (index, color) in colors.enumerated() {
            // append same color twice
            colorsArray.append(color.cgColor)
            colorsArray.append(color.cgColor)
            locationsArray.append(NSNumber(value: (1.0 / Double(colors.count)) * Double(index)))
            locationsArray.append(NSNumber(value: (1.0 / Double(colors.count)) * Double(index + 1)))
        }
        
        gradientLayer.colors = colorsArray
        gradientLayer.locations = locationsArray
        
        self.backgroundColor = UIColor.blue
        self.layer.addSublayer(gradientLayer)
        
        // This can be done outside of this funciton
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}
