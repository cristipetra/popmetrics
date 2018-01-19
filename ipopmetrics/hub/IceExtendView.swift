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
import GTProgressBar

class IceExtendView: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var effortLbl: UILabel!
    @IBOutlet weak var impactMultipleMainProgressView: UIView!
    @IBOutlet weak var costMainProgressView: UIView!
    @IBOutlet weak var effortMainProgressView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var impactScoreView: ImpactScoreView!
    
    @IBOutlet var splitSquare: [UIView]!
    @IBOutlet var splitLabels: [UILabel]!
    @IBOutlet weak var costLbl: UILabel!
    
    @IBOutlet weak var progressCost: GTProgressBar!
    @IBOutlet weak var progressEffort: GTProgressBar!
    @IBOutlet var splitLabelsLeadingAnchor: [NSLayoutConstraint]!
    
    private let colorCost = UIColor(red: 177/255, green: 154/255, blue: 219/255, alpha: 1)
    private let colorEffort = UIColor(red: 255/255, green: 227/255, blue: 130/255, alpha: 1)
    private let colorBackgroundBar = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    
    private var feedCard: FeedCard!
    private var todoCard: TodoCard!
    
    private var iceCardModel: IceCardViewModel! {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.updateView()
            }
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
        containerView.layoutIfNeeded()
        adjustSplitLabelToScreen()
        setCornerRadious()
        
        impactScoreView.setProgress(0.0)
    }
    
    func configure(_ feedCard: FeedCard) {
        self.feedCard = feedCard
        iceCardModel = IceCardViewModel(feedCard: feedCard)
        print(iceCardModel.impactPercentage)
        print(feedCard.iceImpactPercentage)
    }
    
    func configure(todoCard: TodoCard) {
        self.todoCard = todoCard
        iceCardModel = IceCardViewModel(todoCard: todoCard)
        print(iceCardModel.impactPercentage)
        print(todoCard.iceImpactPercentage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func adjustSplitLabelToScreen() {
        
        if UIScreen.main.bounds.width > 320 && UIScreen.main.bounds.width < 414 {
            splitLabelsLeadingAnchor.forEach({ (leadingAnchor) in
                leadingAnchor.constant = 12
                leadingAnchor.isActive = true
            })
        } else if UIScreen.main.bounds.width > 375 {
            splitLabelsLeadingAnchor.forEach({ (leadingAnchor) in
                leadingAnchor.constant = 28
                leadingAnchor.isActive = true
            })
        }
        
    }
    
    private func updateView() {
        setUpLabel()
        
        setSplitValues(splitValues: iceCardModel.getIceImpactSplit())
        
        setProgressEffortStyle()
        setProgressCostStyle()
        
        updateValues()
        
        let progress = CGFloat(iceCardModel.iceImpactPercentage) / CGFloat(100)
        impactScoreView.setProgress(progress)

    }
    
    func updateValues() {
        updateProgressCost()
        updateProgressEffort()
    }
    
    private func updateProgressCost() {
        
        let value = CGFloat(iceCardModel.iceCostPercentage) / CGFloat(100)
        self.progressCost.animateTo(progress: value)
        
        guard let label = iceCardModel.iceCostLabel else { return }
        
        costLbl.text = label
    }
    
    private func updateProgressEffort() {
        let value = CGFloat(iceCardModel.iceEffortPercentage) / CGFloat(100)
        progressEffort.animateTo(progress: CGFloat(value))
        if let effort = iceCardModel.iceEffortLabel {
            effortLbl.text = effort
        }
    }
    
    private func setProgressEffortStyle() {
        progressEffort.progress = 0
        progressEffort.barBackgroundColor = colorBackgroundBar
        progressEffort.barFillColor = colorEffort
        progressEffort.barBorderWidth = 0
        progressEffort.barFillInset = 0
        progressEffort.barBorderColor = colorEffort
        progressEffort.displayLabel = false
        progressEffort.cornerRadius = 5
    }
    
    private func setProgressCostStyle() {
        progressCost.progress = 0
        progressCost.barBackgroundColor = colorBackgroundBar
        progressCost.barFillColor = colorCost
        progressCost.barBorderWidth = 0
        progressCost.barFillInset = 0
        progressCost.barBorderColor = colorCost
        progressCost.displayLabel = false
        progressCost.cornerRadius = 5
    }
    
    
    private func setCornerRadious() {
        
        impactMultipleMainProgressView.layer.cornerRadius = 4
        
        splitSquare.forEach { (label) in
            label.layer.cornerRadius = 2
            label.layer.masksToBounds = true
        }
    }
    
    private func getIceImpactLabel() -> String {
        if( iceCardModel.iceImpactPercentage < 30) {
            return "low"
        } else if(iceCardModel.iceImpactPercentage > 30 && iceCardModel.iceImpactPercentage<70) {
            return "medium"
        } else {
            return "high"
        }
    }
    
    private func setSplitValues(splitValues: [ImpactSplit]) {
        for index in 0..<splitValues.count {
            splitLabels[index].text = splitValues[index].label
            
            splitLabels[index].isHidden = false
            splitSquare[index].isHidden = false
        }
        
        setMultipleProgressViewConstaits()
    }
    
    private func setUpLabel() {
        
    }
    
    func getMostLabel() -> String {
        let maxIndex = iceCardModel.getIceImpactSplitMaxIndex()
        if iceCardModel.getIceImpactSplit().count == 0 {
            return ""
        }
        return  (maxIndex <= iceCardModel.getIceImpactSplit().count) ? iceCardModel.getIceImpactSplit()[maxIndex].label : iceCardModel.getIceImpactSplit()[0].label
    }
    
    func getMostLabelColor() -> UIColor {
        let maxIndex = iceCardModel.getIceImpactSplitMaxIndex()
        if maxIndex > iceCardModel.getBreakdownsColors().count {
            return iceCardModel.getBreakdownsColors()[0]
        }
        
        return iceCardModel.getBreakdownsColors()[maxIndex]
    }

    private func setMultipleProgressViewConstaits() {
        var splitValues = iceCardModel.getIceImpactSplit()
        impactMultipleMainProgressView.clipsToBounds = true
        
        var bounds: CGRect! = CGRect.zero
        let progressColor: [UIColor] = [UIColor(red: 255/255, green: 34/255, blue: 105/255, alpha: 1), UIColor(red: 255/255, green: 157/255, blue: 103/255, alpha: 1), UIColor(red: 78/255, green: 198/255, blue: 255/255, alpha: 1), UIColor.green]
        
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
            
            delay(time: index * 1, closure: {
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
        
        
        let progressValue = CGFloat(truncating: progress) / 100
        
        impactProgressView.primaryColor = animationColor ?? UIColor.red
        
        impactProgressView.animationDuration = animationDuration == nil ? 0.8 : animationDuration!
        impactProgressView.borderWidth = 0
        impactProgressView.cornerRadius = 0
        
        childOff.addSubview(impactProgressView)
        
        DispatchQueue.main.async {
            impactProgressView.setProgress(progressValue, animated: true)
        }
        
    }
}


struct IceCardViewModel {
    internal var iceImpactPercentage: Int
    internal var impactPercentage: Int
    internal var iceImpactSplit: String? = nil // "[{'label': "Website Traffice", 'percentage': 10}]"
    
    internal var iceCostLabel: String? = nil
    internal var iceCostPercentage: Int = 0
    internal var iceEffortLabel: String? = nil
    internal var iceEffortPercentage: Int = 0
    
    init(todoCard: TodoCard) {
        iceImpactPercentage     = todoCard.iceImpactPercentage
        iceImpactSplit          = todoCard.iceImpactSplit
        iceCostLabel            = todoCard.iceCostLabel
        iceCostPercentage       = todoCard.iceCostPercentage
        iceEffortLabel          = todoCard.iceEffortLabel
        iceCostPercentage       = todoCard.iceCostPercentage
        iceEffortPercentage     = todoCard.iceEffortPercentage
        impactPercentage        = todoCard.impactPercentage
    }
    
    init(feedCard: FeedCard) {
        iceImpactPercentage     = feedCard.iceImpactPercentage
        iceImpactSplit          = feedCard.iceImpactSplit
        iceCostLabel            = feedCard.iceCostLabel
        iceCostPercentage       = feedCard.iceCostPercentage
        iceEffortLabel          = feedCard.iceEffortLabel
        iceCostPercentage       = feedCard.iceCostPercentage
        iceEffortPercentage     = feedCard.iceEffortPercentage
        impactPercentage        = feedCard.impactPercentage
    }
    
    func getIceImpactSplit() -> [ImpactSplit] {
        guard let _  = iceImpactSplit else { return [] }
        let values = iceImpactSplit!
        let splitImpactArray = values.toJSON() as! NSMutableArray
        
        var dict: [ImpactSplit] = []
        dict.removeAll()
        for index in 0..<splitImpactArray.count {
            if let obj = splitImpactArray.object(at: index) as? [String: Any] {
                var impact = ImpactSplit()
                impact.initParam(param: obj)
                dict.append(impact)
            }
        }
        return dict
    }
    
    func getIceImpactSplitMaxIndex() -> Int {
        let impactSplists: [ImpactSplit] = getIceImpactSplit()
        var maxIndex = 0
        for (pos, _) in impactSplists.enumerated() {
            if impactSplists[pos].percentage > impactSplists[maxIndex].percentage {
                maxIndex = pos
            }
        }
        return maxIndex
    }
    
    func getBreakdownsColors() -> [UIColor] {
        return [PopmetricsColor.firstBreadown, PopmetricsColor.secondBreadown, PopmetricsColor.thirdBreadown]
    }
    
}

