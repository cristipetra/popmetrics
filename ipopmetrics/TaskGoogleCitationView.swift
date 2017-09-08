//
//  TaskGoogleCitationView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import SwiftRichString

class TaskGoogleCitationView: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var impactLevelLbl: UILabel!
    @IBOutlet weak var costLbl: UILabel!
    @IBOutlet weak var effortLbl: UILabel!
    @IBOutlet weak var impactSimpleMainProgressView: UIView!
    @IBOutlet weak var impactMultipleMainProgressView: UIView!
    @IBOutlet weak var costMainProgressView: UIView!
    @IBOutlet weak var effortMainProgressView: UIView!
    @IBOutlet weak var drawView: UIView!
    
    
    lazy var impactSimpleProgressView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var impactOnlineProgressView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var impactTrafficProgressView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var impactCustomerProgressView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var costProgressView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var effortProgressView : UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
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
        
        Bundle.main.loadNibNamed("TaskGoogleCitationView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setUpImpactSimpleProgressView()
        setUpCostProgressView()
        setUpEffortProgressView()
        setMultipleProgressViewConstaits()
        setCornerRadious()
        
    }
    
    private func setCornerRadious() {
        
        impactSimpleMainProgressView.layer.cornerRadius = 4
        impactMultipleMainProgressView.layer.cornerRadius = 4
        costMainProgressView.layer.cornerRadius = 4
        effortMainProgressView.layer.cornerRadius = 4
        
    }
    
    func setUpLabel(impactLevel: String, cost: String, effort: String) {
        
        let impactStyle = Style("impactStyle", { (style) -> (Void) in
            style.font = FontAttribute(FontBook.bold, size: 15)
            style.color = UIColor(red: 255/255, green: 229/255, blue: 136/255, alpha: 1)
        })
        
        let circaCharacterStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.regular, size: 15)
            style.color = UIColor(red: 255/255, green: 229/255, blue: 135/255, alpha: 1)
        }
        
        let dollarSignStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.light, size: 15)
            style.color = UIColor(red: 255/255, green: 229/255, blue: 135/255, alpha: 1)
        }
        
        let costStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.extraBold, size: 15)
            style.color = UIColor(red: 255/255, green: 229/255, blue: 135/255, alpha: 1)
        }
        
        let effortStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.bold, size: 15)
            style.color = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        }
        
        let circaCharacterStyle2 = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.regular, size: 15)
            style.color = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        }
        
        let circaChar = "~".set(style: circaCharacterStyle)
        let circaChar2 = "~".set(style: circaCharacterStyle2)
        let dollarChar =  "$".set(style: dollarSignStyle)
        let impactLvlAttr = impactLevel.set(style: impactStyle)
        let costAttr = cost.set(style: costStyle)
        let effortAttr = effort.set(style: effortStyle)
        
        let attrString: NSMutableAttributedString = "This is a " + impactLvlAttr + " task that we can complete for " + circaChar + "" + dollarChar + "" + costAttr + " or you can do it in " +  circaChar2 + "" + effortAttr + "."
        
        topLbl.attributedText = attrString
    }
    
    func setImpactLevel(impact: String) {
        impactLevelLbl.text = impact
        
        //here i need the value for the progress
        
        impactSimpleProgressView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        setCornerRadiousOneSide(mainView: impactSimpleMainProgressView, childView: impactSimpleProgressView)
        self.impactSimpleProgressView.backgroundColor = UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1)
        
    }
    
    func setCostStyle(cost: String) {
        
        
        guard let costProgress = NumberFormatter().number(from: cost) else {return}
        
        costProgressView.widthAnchor.constraint(equalToConstant: CGFloat(costProgress)).isActive = true
        setCornerRadiousOneSide(mainView: costMainProgressView, childView: costProgressView)
        self.costProgressView.backgroundColor = UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1)
        
        let circaCharacterStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.regular, size: 18)
            style.color = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        }
        
        let extraBoldStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.extraBold, size: 18)
            style.color = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        }
        
        costLbl.attributedText = "~".set(style: circaCharacterStyle) + "$".set(style: extraBoldStyle) + cost.set(style: extraBoldStyle)
        
    }
    
    func setEffortStyle(effort: String) {
        
        guard let effortProgress = NumberFormatter().number(from: effort) else {return}
        
        effortProgressView.widthAnchor.constraint(equalToConstant: CGFloat(effortProgress) * 10 ).isActive = true
        setCornerRadiousOneSide(mainView: effortMainProgressView, childView: effortProgressView)
        self.effortProgressView.backgroundColor = UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1)
        
        let circaCharacterStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.regular, size: 18)
            style.color = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        }
        
        let extraBoldStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.extraBold, size: 18)
            style.color = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        }
        
        effortLbl.attributedText = "~".set(style: circaCharacterStyle) + effort.set(style: extraBoldStyle) + " hours".set(style: extraBoldStyle)
    }
    
    private func setUpImpactSimpleProgressView() {
        
        impactSimpleMainProgressView.insertSubview(impactSimpleProgressView, at: 1)
        impactSimpleProgressView.leftAnchor.constraint(equalTo: impactSimpleMainProgressView.leftAnchor).isActive = true
        impactSimpleProgressView.topAnchor.constraint(equalTo: impactSimpleMainProgressView.topAnchor).isActive = true
        impactSimpleProgressView.bottomAnchor.constraint(equalTo: impactSimpleMainProgressView.bottomAnchor).isActive = true
        
    }
    
    private func setUpCostProgressView() {
        
        costMainProgressView.insertSubview(costProgressView, at: 1)
        costProgressView.leftAnchor.constraint(equalTo: costMainProgressView.leftAnchor).isActive = true
        costProgressView.topAnchor.constraint(equalTo: costMainProgressView.topAnchor).isActive = true
        costProgressView.bottomAnchor.constraint(equalTo: costMainProgressView.bottomAnchor).isActive = true
        
    }
    
    private func setUpEffortProgressView() {
        
        effortMainProgressView.insertSubview(effortProgressView, at: 1)
        effortProgressView.leftAnchor.constraint(equalTo: effortMainProgressView.leftAnchor).isActive = true
        effortProgressView.topAnchor.constraint(equalTo: effortMainProgressView.topAnchor).isActive = true
        effortProgressView.bottomAnchor.constraint(equalTo: effortMainProgressView.bottomAnchor).isActive = true
        
    }
    
    private func setMultipleProgressViewConstaits() {
        
        impactMultipleMainProgressView.insertSubview(impactTrafficProgressView, at: 1)
        impactMultipleMainProgressView.insertSubview(impactOnlineProgressView, at: 1)
        impactMultipleMainProgressView.insertSubview(impactCustomerProgressView, at: 1)
        
        impactTrafficProgressView.leftAnchor.constraint(equalTo: impactMultipleMainProgressView.leftAnchor).isActive = true
        impactTrafficProgressView.topAnchor.constraint(equalTo: impactMultipleMainProgressView.topAnchor).isActive = true
        impactTrafficProgressView.bottomAnchor.constraint(equalTo: impactMultipleMainProgressView.bottomAnchor).isActive = true
        
        
        impactOnlineProgressView.topAnchor.constraint(equalTo: impactMultipleMainProgressView.topAnchor).isActive = true
        impactOnlineProgressView.bottomAnchor.constraint(equalTo: impactMultipleMainProgressView.bottomAnchor).isActive = true
        
        
        impactCustomerProgressView.topAnchor.constraint(equalTo: impactMultipleMainProgressView.topAnchor).isActive = true
        impactCustomerProgressView.bottomAnchor.constraint(equalTo: impactMultipleMainProgressView.bottomAnchor).isActive = true
        
        
        //for now i set here the width/progress
        
        impactTrafficProgressView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        impactTrafficProgressView.backgroundColor = UIColor(red: 255/255, green: 34/255, blue: 105/255, alpha: 1)
        //setCornerRadiousOneSide(mainView: impactMultipleMainProgressView, childView: impactTrafficProgressView)
        
        impactOnlineProgressView.leftAnchor.constraint(equalTo: impactMultipleMainProgressView.leftAnchor,constant: 60).isActive = true
        impactOnlineProgressView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        impactOnlineProgressView.backgroundColor = UIColor(red: 255/255, green: 157/255, blue: 103/255, alpha: 1)
        
        impactCustomerProgressView.leftAnchor.constraint(equalTo: impactMultipleMainProgressView.leftAnchor,constant: 140).isActive = true
        impactCustomerProgressView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        impactCustomerProgressView.backgroundColor = UIColor(red: 78/255, green: 198/255, blue: 255/255, alpha: 1)
        
    }
    
    func setCornerRadiousOneSide(mainView: UIView, childView: UIView) {
        
        if mainView.frame.width == childView.frame.width {
            DispatchQueue.main.async {
                childView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 4)
            }
        } else {
            
            DispatchQueue.main.async {
                childView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 4)
            }
        }
        
    }
    
}
