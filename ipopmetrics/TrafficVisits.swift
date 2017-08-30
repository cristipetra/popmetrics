//
//  TrafficVisits.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TrafficVisits: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpVisitsView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpVisitsView()
    }
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var firstValueLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var secondValueLabel : UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var mainProgressView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var firstProgressView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var secondProgressView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    func setUpVisitsView() {
        
        self.backgroundColor = UIColor.white
        
        
        self.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 22).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 26).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        titleLabel.text = "Unique Visits"
        titleLabel.font = UIFont(name: FontBook.extraBold, size: 18)
        titleLabel.textColor = UIColor(red: 87/255, green: 93/255, blue: 99/255, alpha: 1)
        
        self.addSubview(firstValueLabel)
        firstValueLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 2).isActive = true
        firstValueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 26).isActive = true
        firstValueLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        self.addSubview(secondValueLabel)
        secondValueLabel.leftAnchor.constraint(equalTo: firstValueLabel.rightAnchor, constant: 2).isActive = true
        secondValueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 26).isActive = true
        secondValueLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.addSubview(mainProgressView)
        mainProgressView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 19).isActive = true
        mainProgressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13).isActive = true
        mainProgressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -21).isActive = true
        mainProgressView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        mainProgressView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        mainProgressView.addSubview(secondProgressView)
        mainProgressView.addSubview(firstProgressView)
        firstProgressView.leftAnchor.constraint(equalTo: mainProgressView.leftAnchor).isActive = true
        firstProgressView.topAnchor.constraint(equalTo: mainProgressView.topAnchor).isActive = true
        firstProgressView.bottomAnchor.constraint(equalTo: mainProgressView.bottomAnchor).isActive = true
        
        secondProgressView.leftAnchor.constraint(equalTo: mainProgressView.leftAnchor).isActive = true
        secondProgressView.topAnchor.constraint(equalTo: mainProgressView.topAnchor).isActive = true
        secondProgressView.bottomAnchor.constraint(equalTo: mainProgressView.bottomAnchor).isActive = true
        
        setDesign()
        
    }
    
    private func setDesign() {
        firstValueLabel.font = UIFont(name: FontBook.alfaRegular, size: 18)
        firstValueLabel.textColor = UIColor(red: 160/255, green: 12/255, blue: 77/255, alpha: 1)
        
        secondValueLabel.font = UIFont(name: FontBook.alfaRegular, size: 18)
        secondValueLabel.textColor = UIColor(red: 255/255, green: 33/255, blue: 122/255, alpha: 1)
        
        mainProgressView.layer.cornerRadius = 4
        firstProgressView.layer.cornerRadius = 4
        secondProgressView.layer.cornerRadius = 4
    }
    
    private func setProgress(firstValue: CGFloat, secondValue: CGFloat) {
        
        firstProgressView.widthAnchor.constraint(equalToConstant: firstValue).isActive = true
        secondProgressView.widthAnchor.constraint(equalToConstant: secondValue + firstValue).isActive = true
        
        let firstProgressViewGradient : [UIColor] = [UIColor(red: 196/255, green: 13/255, blue: 72/255, alpha: 1), UIColor(red: 192/255, green: 21/255, blue: 46/255, alpha: 1) ]
        let secondProgressViewGradient : [UIColor] = [UIColor(red: 255/255, green: 34/255, blue: 105/255, alpha: 1), UIColor(red: 255/255, green: 27/255, blue: 192/255, alpha: 1) ]
        
        
        setGradiendForProgressView(view: firstProgressView, leftColor: firstProgressViewGradient[0], rightColor: firstProgressViewGradient[1])
        setGradiendForProgressView(view: secondProgressView, leftColor: secondProgressViewGradient[0], rightColor: secondProgressViewGradient[1])
        
    }
    
    func setProgressValues(doubleValue: Bool, firstValue: Int,doubleFirst: Int? ,secondValue: Int, doubleSecond: Int?) {
        
        if doubleValue == false {
            firstValueLabel.text = "\(firstValue)"
            secondValueLabel.text = "+\(secondValue)"
            
        } else {
            firstValueLabel.widthAnchor.constraint(equalToConstant: 68).isActive = true
            secondValueLabel.widthAnchor.constraint(equalToConstant: 68).isActive = true
            if let firstDouble = doubleFirst {
                firstValueLabel.text = "\(firstValue):\(firstDouble)"
            }
            
            if let secondDouble = doubleSecond {
                secondValueLabel.text = "\(secondValue):\(secondDouble)"
            }
            
        }
        
        setProgress(firstValue: CGFloat(firstValue), secondValue: CGFloat(secondValue))
        
    }
    
    func setGradiendForProgressView(view: UIView,leftColor : UIColor , rightColor: UIColor) {
        
        let gradientLayer  = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        //view.layer.addSublayer(gradientLayer)
        
        DispatchQueue.main.async { 
            view.layer.addSublayer(gradientLayer)
        }
        
    }
    
}
