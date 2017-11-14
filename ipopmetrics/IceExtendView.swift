//
//  IceExtendView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import SwiftRichString
import M13ProgressSuite

class IceExtendView: UIView {
    
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
    
    @IBOutlet var splitSquare: [UILabel]!
    @IBOutlet var splitLabels: [UILabel]!
    
    
    private var feedCard: FeedCard! {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        Bundle.main.loadNibNamed("IceExtendView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        
        setCornerRadious()
    }
    
    func configure(_ feedCard: FeedCard) {
        self.feedCard = feedCard
    }
    
    private func updateView() {
        setUpLabel()
        
        setImpactLevel()
        setCostStyle()
        setEffortStyle()
        setSplitValues()
    }
    
    private func setCornerRadious() {
        
        impactSimpleMainProgressView.layer.cornerRadius = 4
        impactMultipleMainProgressView.layer.cornerRadius = 4
        costMainProgressView.layer.cornerRadius = 4
        effortMainProgressView.layer.cornerRadius = 4
        
        splitSquare.forEach { (label) in
            label.layer.cornerRadius = 2
            label.layer.masksToBounds = true
        }
    }
    
    private func getIceImpactLabel() -> String {
        if( feedCard.iceImpactPercentage < 30) {
            return "low"
        } else if(feedCard.iceImpactPercentage > 30 && feedCard.iceImpactPercentage<70) {
            return "medium"
        } else {
            return "high"
        }
    }
    
    private func setSplitValues() {
        
        var splitValues = feedCard.getIceImpactSplit()

        for index in 0..<splitValues.count {
            splitLabels[index].text = splitValues[index].label
            splitLabels[index].isHidden = false
            splitSquare[index].isHidden = false
        }
        setMultipleProgressViewConstaits()
    }
    
    private func setUpLabel() {
        let impactLevel: String = (getIceImpactLabel() + " impact")
        
        guard let cost = feedCard.iceCostLabel else { return }
        guard let effort = feedCard.iceEffortLabel else { return }
        
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
    
    private func setImpactLevel() {
        impactLevelLbl.text = getIceImpactLabel()
        let value = String(feedCard.iceImpactPercentage)
        
        impactSimpleMainProgressView.clipsToBounds = true
        
        setProgress(animationBounds: impactSimpleMainProgressView.bounds, value: value, childOff: impactSimpleMainProgressView, animationColor: UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1), animationDuration: 0.2)
        
    }
    
    private func setCostStyle() {
        costMainProgressView.clipsToBounds = true
        let value = String(feedCard.iceCostPercentage)
        guard let label = feedCard.iceCostLabel else {
            return
        }
        
        setProgress(animationBounds: costMainProgressView.bounds, value: value, childOff: costMainProgressView, animationColor: UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1), animationDuration: nil)
        
        let circaCharacterStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.regular, size: 18)
            style.color = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        }
        
        let extraBoldStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.extraBold, size: 18)
            style.color = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        }
        
        costLbl.attributedText = "~".set(style: circaCharacterStyle) + "$\(label)".set(style: extraBoldStyle)
        
    }
    
    private func setEffortStyle() {
        guard let effort: String = feedCard.iceEffortLabel else { return }
        let value = String(feedCard.iceEffortPercentage)
        
        effortMainProgressView.clipsToBounds = true
        
        setProgress(animationBounds: effortMainProgressView.bounds, value: value, childOff: effortMainProgressView, animationColor: UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1), animationDuration: 2)
        
        
        let circaCharacterStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.regular, size: 18)
            style.color = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        }
        
        let extraBoldStyle = Style.default { (style) -> (Void) in
            style.font = FontAttribute(FontBook.extraBold, size: 18)
            style.color = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1)
        }
        
        effortLbl.attributedText = "~".set(style: circaCharacterStyle) + "\(effort)".set(style: extraBoldStyle)
    }
    
    private func setMultipleProgressViewConstaits() {
        var splitValues = feedCard.getIceImpactSplit()
        impactMultipleMainProgressView.clipsToBounds = true
        
        var bounds: CGRect!
        let progressColor: [UIColor] = [UIColor(red: 255/255, green: 34/255, blue: 105/255, alpha: 1),UIColor(red: 255/255, green: 157/255, blue: 103/255, alpha: 1), UIColor(red: 78/255, green: 198/255, blue: 255/255, alpha: 1), UIColor.green]
        
        if splitValues.count == 0 {
            impactMultipleMainProgressView.isHidden = true
            splitSquare.forEach({ (label) in
                label.isHidden = true
            })
            
            splitLabels.forEach({ (label) in
                label.isHidden = true
            })
            return
        }
        
        for index in 0..<splitValues.count {
            
            delay(time: index * 2, closure: {
                if index == 0 {
                    bounds = self.calcProgressBounds(startingPos: 0)
                } else {
                    bounds = self.calcProgressBounds(startingPos: splitValues[index - 1].percentage,previousBounds: bounds)
                }
                self.setProgress(animationBounds: bounds, value: String(splitValues[index].percentage), childOff: self.impactMultipleMainProgressView, animationColor: progressColor[index], animationDuration: nil)
            })
        }
    }
    
    func delay(time: Int, closure: @escaping ()->()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(time)) {
            closure()
        }
        
    }
    
    func calcProgressBounds(startingPos: Int,previousBounds : CGRect? = CGRect.zero) -> CGRect {
        
        let bounds = CGRect(x: impactMultipleMainProgressView.bounds.origin.x + calcMainWidth(value: CGFloat(startingPos)) + (previousBounds?.origin.x)!, y: impactMultipleMainProgressView.bounds.origin.y, width: impactMultipleMainProgressView.bounds.width , height: impactMultipleMainProgressView.bounds.height)
        
        return bounds
    }
    
    func calcMainWidth(value: CGFloat) -> CGFloat {
        return (value * impactMultipleMainProgressView.bounds.width) / 100
    }
    
    func setProgress(animationBounds: CGRect, value: String, childOff: UIView, animationColor: UIColor?, animationDuration: CGFloat?) {
        
        let impactProgressView = M13ProgressViewBorderedBar(frame: animationBounds)
        
        guard let progress = NumberFormatter().number(from: value) else {return}
        
        let progressValue = CGFloat(progress) / 100
        
        impactProgressView.primaryColor = animationColor ?? UIColor.red//(red: 255/255, green: 227/255, blue: 130/255, alpha: 1)
        impactProgressView.animationDuration = animationDuration == nil ? 2 : animationDuration!
        impactProgressView.borderWidth = 0
        impactProgressView.cornerRadius = 0
        
        childOff.addSubview(impactProgressView)
        
        DispatchQueue.main.async {
            impactProgressView.setProgress(progressValue, animated: true)
        }
        
    }
}

