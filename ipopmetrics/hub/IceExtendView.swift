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
    
    @IBOutlet weak var containerEstimations: UIStackView!
    @IBOutlet weak var progressCost: GTProgressBar!
    @IBOutlet weak var progressEffort: GTProgressBar!
    @IBOutlet var splitLabelsLeadingAnchor: [NSLayoutConstraint]!
    
    @IBOutlet weak var constraintWidthProgressEffort: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthProgressCost: NSLayoutConstraint!
    
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var constraintTopContainerEstimations: NSLayoutConstraint!
    @IBOutlet weak var firstScoreView: ImpactScoreView!
    @IBOutlet weak var secondScoreView: ImpactScoreView!
    @IBOutlet weak var thirdScoreView: ImpactScoreView!
    
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
        
        setCornerRadious()
        
        initialScores()
        
        self.expandButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2) );
    }
    
    private func initialScores() {
        impactScoreView.setProgress(0.0)
        progressCost.animateTo(progress: 0)
        progressEffort.animateTo(progress: 0)
        firstScoreView.alpha = 0.6
        firstScoreView.setTitle("Site Traffic")
        
        secondScoreView.alpha = 0.6
        secondScoreView.setTitle("Brand")
        
        thirdScoreView.alpha = 0.6
        thirdScoreView.setTitle("Customers")
        
    }
    
    func configure(_ feedCard: FeedCard) {
        self.feedCard = feedCard
        iceCardModel = IceCardViewModel(feedCard: feedCard)
    }
    
    func configure(todoCard: TodoCard) {
        self.todoCard = todoCard
        iceCardModel = IceCardViewModel(todoCard: todoCard)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIScreen.main.bounds.width > 320 {
            constraintWidthProgressCost.constant = 170
            constraintWidthProgressEffort.constant = 170
        }
    }
    
    private func updateView() {
        
        setSplitValues(splitValues: iceCardModel.getIceImpactSplit())
        
        setProgressEffortStyle()
        setProgressCostStyle()
        
        updateValues()
        
        let progress = CGFloat(iceCardModel.iceImpactPercentage) / CGFloat(100)
        impactScoreView.setProgress(progress)

    }
    
    var isExpand = true
    @IBAction func handlerExpandable(_ sender: UIButton) {
        self.parentViewController?.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            let estimationTop: CGFloat =  self.isExpand ? -100 : 60
            self.isExpand = !self.isExpand
            
            self.constraintTopContainerEstimations.constant = estimationTop
            let expandRotationAngle: CGFloat = !self.isExpand ?  CGFloat((Double.pi / 2) * 3) : CGFloat(Double.pi / 2)
            self.expandButton.transform = CGAffineTransform(rotationAngle: expandRotationAngle );
            self.parentViewController?.view.layoutIfNeeded()
        }
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
        let scoreViews: [ImpactScoreView] = [firstScoreView, secondScoreView, thirdScoreView]
        for index in 0..<splitValues.count {
            scoreViews[index].setTitle(splitValues[index].label)
            scoreViews[index].setProgressPercentage( CGFloat(splitValues[index].percentage) / 100.0)
        }
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

