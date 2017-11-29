//
//  PaidActionCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 24/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import GTProgressBar

class PaidActionCardCell: UITableViewCell {
    
    @IBOutlet weak var wrapperView: UIStackView!
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var impactLabel: UILabel!
    @IBOutlet weak var progressImpact: GTProgressBar!
    @IBOutlet weak var progressCost: GTProgressBar!
    @IBOutlet weak var containerBtn: UIView!
    @IBOutlet weak var containerShadow: UIView!
    @IBOutlet weak var impactView: ImpactScoreView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    var todoCard: TodoCard!
    
    private let colorCost = UIColor(red: 177/255, green: 154/255, blue: 219/255, alpha: 1)
    private let colorImpact = UIColor(red: 124/255, green: 202/255, blue: 176/255, alpha: 1)
    private let colorBackgroundBar = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clearView()
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        addShadowToView(containerShadow, radius: 4, opacity: 0.5)
        setCornerRadius()
        setProgressCosttStyle()
        setProgressImpacttStyle()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cardImageView.isUserInteractionEnabled = true
        cardImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func clearView() {
        cardTitle.text = ""
        impactLabel.text = ""
        costLabel.text = ""
        statusLabel.text = ""
    }
    
    private func setCornerRadius() {
        self.containerShadow.layer.cornerRadius = 14
        self.containerBtn.layer.cornerRadius = 14
    }
    
    private func setProgressCosttStyle() {
        progressCost.progress = 0
        progressCost.barBackgroundColor = colorBackgroundBar
        progressCost.barFillColor = colorCost
        progressCost.barBorderWidth = 0
        progressCost.barFillInset = 0
        progressCost.barBorderColor = colorCost
        progressCost.displayLabel = false
        progressCost.cornerRadius = 5
    }
    
    private func setProgressImpacttStyle() {
        progressImpact.progress = 0
        progressImpact.barBackgroundColor = colorBackgroundBar
        progressImpact.barFillColor = colorImpact
        progressImpact.barBorderWidth = 0
        progressImpact.barFillInset = 0
        progressImpact.barBorderColor = colorImpact
        progressImpact.displayLabel = false
        progressImpact.cornerRadius = 5
    }
    
    private func updateView() {
        if let url = todoCard.imageUri {
            cardImageView.af_setImage(withURL: URL(string: url)!)
        }
        
        if let title = todoCard.headerTitle {
            cardTitle.text = title
        }
        
        let valueProgress = CGFloat(todoCard.impactPercentage) / CGFloat(100)
        impactLabel.text = "+\(todoCard.impactPercentage)"
        progressImpact.animateTo(progress: valueProgress)
        
        costLabel.text = todoCard.iceCostLabel
        
        let costPercentage = CGFloat(todoCard.iceCostPercentage) / CGFloat(100)
        progressCost.animateTo(progress: costPercentage)
    }
    
    internal func configure(_ todoCard: TodoCard) {
        self.todoCard = todoCard
        
        updateView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let actionPageVc: ActionPageDetailsViewController = ActionPageDetailsViewController(nibName: "ActionPage", bundle: nil)
        actionPageVc.configure(todoCard: todoCard)
        self.parentViewController?.navigationController?.pushViewController(actionPageVc, animated: true)
    }
    
}

