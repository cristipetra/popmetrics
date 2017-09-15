//
//  TaskGoogleCitationView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import SwiftRichString
import M13ProgressSuite

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
    @IBOutlet weak var redSquareLbl: UILabel!
    @IBOutlet weak var yellowSquareLbl: UILabel!
    @IBOutlet weak var blueSquareLbl: UILabel!
    
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
        
        setMultipleProgressViewConstaits()
        setCornerRadious()
        
        
    }
    
    private func setCornerRadious() {
        
        impactSimpleMainProgressView.layer.cornerRadius = 4
        impactMultipleMainProgressView.layer.cornerRadius = 4
        costMainProgressView.layer.cornerRadius = 4
        effortMainProgressView.layer.cornerRadius = 4
        
        redSquareLbl.layer.cornerRadius = 2
        yellowSquareLbl.layer.cornerRadius = 2
        blueSquareLbl.layer.cornerRadius = 2
        redSquareLbl.layer.masksToBounds = true
        yellowSquareLbl.layer.masksToBounds = true
        blueSquareLbl.layer.masksToBounds = true
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
        
        impactSimpleMainProgressView.clipsToBounds = true
        
        setProgress(animationBounds: impactSimpleMainProgressView.bounds, value: "70", childOff: impactSimpleMainProgressView, animationColor: UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1), animationDuration: nil)
        
    }
    
    func setCostStyle(cost: String) {
        
        costMainProgressView.clipsToBounds = true
        
        setProgress(animationBounds: costMainProgressView.bounds, value: cost, childOff: costMainProgressView, animationColor: UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1), animationDuration: nil)
        
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
        
        effortMainProgressView.clipsToBounds = true
        
        setProgress(animationBounds: effortMainProgressView.bounds, value: effort, childOff: effortMainProgressView, animationColor: UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1), animationDuration: 15)
        
        
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
    
    private func setMultipleProgressViewConstaits() {
        
        impactMultipleMainProgressView.clipsToBounds = true
        
        setProgress(animationBounds: impactMultipleMainProgressView.bounds, value: "30", childOff: impactMultipleMainProgressView, animationColor:  UIColor(red: 255/255, green: 34/255, blue: 105/255, alpha: 1), animationDuration: nil)
        
        // insetend if 30 will be the value we get from parameter
        
        let onlineFootprintBounds = CGRect(x: impactMultipleMainProgressView.bounds.origin.x + 30, y: impactMultipleMainProgressView.bounds.origin.y, width: impactMultipleMainProgressView.bounds.width - 30 , height: impactMultipleMainProgressView.bounds.height)
        
        let when = DispatchTime.now() + 6
        //DispatchQueue.main.asyncAfter(deadline: when) {
        self.setProgress(animationBounds: onlineFootprintBounds, value: "60", childOff: self.impactMultipleMainProgressView, animationColor:  UIColor(red: 255/255, green: 157/255, blue: 103/255, alpha: 1), animationDuration: nil)
        // }
        
        let customersBounds = CGRect(x: onlineFootprintBounds.origin.x + 60, y: impactMultipleMainProgressView.bounds.origin.y, width: impactMultipleMainProgressView.bounds.width - 60, height: impactMultipleMainProgressView.bounds.height)
        
        // DispatchQueue.main.asyncAfter(deadline: when) {
        self.setProgress(animationBounds: customersBounds, value: "90", childOff: self.impactMultipleMainProgressView, animationColor:   UIColor(red: 78/255, green: 198/255, blue: 255/255, alpha: 1), animationDuration: nil)
        
        // }
        
    }
    
    func setProgress(animationBounds: CGRect, value: String, childOff: UIView, animationColor: UIColor?, animationDuration: CGFloat?) {
        
        let impactProgressView = M13ProgressViewBorderedBar(frame: animationBounds)
        
        guard let progress = NumberFormatter().number(from: value) else {return}
        
        let progressValue = CGFloat(progress) / 100
        
        impactProgressView.primaryColor = animationColor//UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1)
        impactProgressView.animationDuration = animationDuration == nil ? 6 : animationDuration!
        impactProgressView.borderWidth = 0
        impactProgressView.cornerRadius = 0
        
        childOff.addSubview(impactProgressView)
        
        DispatchQueue.main.async {
            impactProgressView.setProgress(progressValue, animated: true)
        }
        
    }
    
    //  func setCornerRadiousOneSide(mainView: UIView, childView: UIView) {
    //
    //    if mainView.frame.width == childView.frame.width {
    //      DispatchQueue.main.async {
    //        childView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 4)
    //      }
    //    } else {
    //      
    //    DispatchQueue.main.async {
    //      childView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 4)
    //    }
    //  }
    //    
    //}
    
    //  override func draw(_ rect: CGRect) {
    //    
    //      let firstContext = UIGraphicsGetCurrentContext()
    //      firstContext?.setLineWidth(2)
    //      firstContext?.setStrokeColor(UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1).cgColor)
    //    
    //      let startingPoint = CGPoint(x: drawView.bounds.origin.x, y: drawView.bounds.origin.y)
    //      
    //      firstContext?.move(to: startingPoint)
    //      firstContext?.addLine(to: CGPoint(x: drawView.bounds.origin.x + 20, y: drawView.bounds.origin.y + 30))
    //      firstContext?.strokePath()
    //  }
    //  
    
}
