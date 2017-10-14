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
        self.layer.masksToBounds = false
        self.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            self.addShadowForRoundedButton()
        }
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topView)
        topView.isUserInteractionEnabled = false
        self.addSubview(bottomView)
        bottomView.isUserInteractionEnabled = false
        self.addSubview(label)
        label.isUserInteractionEnabled = false
        self.addSubview(imgView)
        imgView.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: self.topAnchor),
            topView.leftAnchor.constraint(equalTo: self.leftAnchor),
            topView.rightAnchor.constraint(equalTo: self.rightAnchor),
            topView.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            bottomView.topAnchor.constraint(equalTo: self.centerYAnchor),
            bottomView.leftAnchor.constraint(equalTo: self.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: self.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 21),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 9),
            label.heightAnchor.constraint(equalToConstant: 14),
            imgView.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10),
            imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 9),
            imgView.heightAnchor.constraint(equalToConstant: 18)
            ]
        )
    }
    
    func changeImgConstraint(value: Int) {
        imgView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: CGFloat(value)).isActive = true
        self.image = UIImage(named: "iconCheck")
        self.layoutIfNeeded()
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = PopmetricsColor.textGrey
    }
    
    internal func animateButton(decreaseWidth: Float, increaseWidth: Float, imgLeftSpace: Float) {
        label.removeFromSuperview()
        self.image = nil
        let button = self
        UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
            button.frame = CGRect(x: button.frame.origin.x + CGFloat(decreaseWidth), y: button.frame.origin.y, width: button.frame.size.width - CGFloat(decreaseWidth), height: button.frame.size.height)
        }) { (completion) in
            button.changeImgConstraint(value: Int(imgLeftSpace))
            button.frame = CGRect(x: button.frame.origin.x - CGFloat(increaseWidth), y: button.frame.origin.y, width: button.frame.size.width + CGFloat(increaseWidth), height: button.frame.size.height)
        }
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
            NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 15),
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
