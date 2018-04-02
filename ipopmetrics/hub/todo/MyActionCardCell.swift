//
//  TodoMyActionCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 24/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class MyActionCardCell: UITableViewCell {
    
    @IBOutlet weak var wrapperView: UIStackView!
    
    @IBOutlet weak var btnMarkAsComplete: UIButton!
    @IBOutlet weak var containerBtn: UIView!
    @IBOutlet weak var containerShadow: UIView!
    @IBOutlet weak var impactView: ImpactScoreView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    var todoCard: TodoCard!

    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        addShadowToView(containerShadow, radius: 4, opacity: 0.5)
        setCornerRadius()
        
        addActionToImage()
    }
    
    private func addActionToImage() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cardImageView.isUserInteractionEnabled = true
        cardImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setCornerRadius() {
        self.containerShadow.layer.cornerRadius = 14
        self.containerBtn.layer.cornerRadius = 14
    }
    
    private func updateView() {
        
        if let url = todoCard.imageUri {
            cardImageView.af_setImage(withURL: URL(string: url)!)
        }
        
        if let title = todoCard.headerTitle {
            cardTitle.text = title
        }
        
        let valueProgress = Double(todoCard.iceImpactPercentage) / Double(100)
        impactView.setProgress(CGFloat(valueProgress))
        
    }
    
    internal func configure(_ todoCard: TodoCard) {
        self.todoCard = todoCard
        
        updateView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        navigator.push("vnd.popmetrics://action_status/"+(todoCard.name))
    }

}
