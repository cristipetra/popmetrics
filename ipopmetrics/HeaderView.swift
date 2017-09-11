//
//  HeaderView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 08/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@IBDesignable
class HeaderView: UIView {
    
    lazy var circleView : UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    
    lazy var statusLbl: UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 150, height: 18))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: FontBook.regular, size: 12)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        return stack
    }()
    
    lazy var iconLbl: UILabel = {
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 150, height: 18))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: FontBook.regular, size: 12)
        label.textColor = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1.0)
        return label
    }()
    
    lazy var iconView: UIImageView = {
        let iconImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return iconImage
    }()
    
    lazy var btnIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return btn
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
        
        self.backgroundColor = UIColor.white
        
        
        self.addSubview(circleView)
        circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        circleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 27).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        circleView.layer.cornerRadius = 6
        circleView.backgroundColor = PopmetricsColor.darkGrey
        
        //statusLbl
        self.addSubview(statusLbl)
        statusLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        statusLbl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50).isActive = true
        statusLbl.text = "Attention required"
        statusLbl.textColor = PopmetricsColor.darkGrey
        
        let rightContainer: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        rightContainer.translatesAutoresizingMaskIntoConstraints = false
        rightContainer.backgroundColor = UIColor.red
        
        //stackView
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        
        //iconImage
        iconView.image = UIImage(named: "iconExpand")
        
        //btnIcon
        btnIcon.setImage(UIImage(named: "iconExpand"), for: .normal)
        
        
        stackView.addArrangedSubview(iconLbl)
        //stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(btnIcon)
        
        stackView.isHidden = true
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    
        iconLbl.text = "Expand"
        
        addShadow()
    }
    
    func changeTitle(title: String) {
        statusLbl.text = title
    }
    
    func changeStatus(type: HeaderViewType) {
        if type == HeaderViewType.minimize {
            changeIconText("Expand")
            btnIcon.setImage(UIImage(named: "iconExpand"), for: .normal)
            
        } else {
            changeIconText("Minimize")
            btnIcon.setImage(UIImage(named: "iconMinimize"), for: .normal)
        }
    }
    
    func changeColorCircle(color: UIColor) {
        circleView.backgroundColor = color
    }
    
    func displayIcon(display: Bool) {
        stackView.isHidden = !display
    }
    
    func changeIconText(_ text: String) {
        iconLbl.text = text
    }
    
    func addShadow() {
        self.layer.masksToBounds = false
        DispatchQueue.main.async {
            self.addShadowToView(self, radius: 4, opacity: 0.5)
        }
    }
    
    func displayElements(isHidden: Bool) {
        self.circleView.isHidden = isHidden
        self.statusLbl.isHidden = isHidden
        self.stackView.isHidden = isHidden
    }
    
}

enum  HeaderViewType {
    case minimize
    case expand
}
