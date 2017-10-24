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
    
    //View
    private var topView: UIView = UIView()
    private var bottomView: UIView =  UIView()
    private var imgView: UIImageView = UIImageView()
    private var label: UILabel = UILabel()
    //End view
    
    @IBInspectable
    var topColor : UIColor = UIColor.white{
        didSet {
            setupTwoColorView(colors: [topColor, bottomColor])
        }
    }
    
    @IBInspectable
    var bottomColor : UIColor = UIColor.white{
        didSet {
            setupTwoColorView(colors: [topColor, bottomColor])
        }
    }
    
    @IBInspectable
    var labelText : String? {
        didSet {
            self.changeLabelText()
        }
    }
    
    @IBInspectable
    var image : UIImage? {
        didSet {
            image = image?.withRenderingMode(.alwaysTemplate)
            self.changeImage()
        }
    }
    
    var indexPath: IndexPath!
    
    var imageButtonType: ImageButtonType = .unapproved {
        didSet {
            changeImageButtonType()
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
        self.layer.masksToBounds = false
        self.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            //self.addShadowForRoundedButton()
        }
        
        self.image = UIImage(named: "iconRightYellow")
        self.labelText = "Connect Twitter"
        self.topColor = UIColor.red
        self.bottomColor = PopmetricsColor.yellowBGColor
        
        topView.backgroundColor = PopmetricsColor.topButtonColor
        bottomView.backgroundColor = PopmetricsColor.bottomButtonColor
        
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
        label.numberOfLines = 2
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
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 19),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -34),
            label.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 0),
            imgView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -18),
            imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 9),
            imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            imgView.heightAnchor.constraint(equalToConstant: 18)
            ]
        )
        
        
        label.textAlignment = .center
        
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.frame.height / 2
        }
    }
    
    internal func changeTitle(_ title: String) {
        self.labelText = title
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
        
        let attribute = [
            NSFontAttributeName: UIFont(name: "OpenSans-Bold", size: 12),
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
    
    func changeImageButtonType() {
        switch imageButtonType {
        
        default:
            break
        }
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
        
        
        self.layer.addSublayer(gradientLayer)
        
        // This can be done outside of this funciton
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}
