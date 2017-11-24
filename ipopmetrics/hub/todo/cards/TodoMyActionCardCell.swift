//
//  TodoMyActionCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 24/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TodoMyActionCardCell: UITableViewCell {
    
    @IBOutlet weak var wrapperView: UIStackView!
    
    @IBOutlet weak var impactView: ImpactScoreView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    var todoCard: TodoCard!

    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        wrapperView.cornerRadius = 15
    }
    
    private func updateView() {
        
        if let url = todoCard.imageUri {
            cardImageView.af_setImage(withURL: URL(string: url)!)
        }
        
        let url = "http://blog.popmetrics.io/wp-content/uploads/sites/13/2017/07/shutterstock_397574752-1600x1015.jpg"
        cardImageView.af_setImage(withURL: URL(string: url)!)
        
        if let title = todoCard.headerTitle {
            cardTitle.text = title
        }
        
        let valueProgress = Double(todoCard.impactPercentage) / Double(100)
        impactView.setProgress(CGFloat(valueProgress))
        
    }
    
    internal func configure(_ todoCard: TodoCard) {
        self.todoCard = todoCard
        
        updateView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setCornerRadius() {
        wrapperView.layer.cornerRadius = 14
        wrapperView.layer.masksToBounds = true
    }

}
