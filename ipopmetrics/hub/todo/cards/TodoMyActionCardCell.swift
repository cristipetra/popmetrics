//
//  TodoMyActionCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 24/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TodoMyActionCardCell: UITableViewCell {
    
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    var todoCard: TodoCard!

    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.backgroundColor = .clear
        updateView()
    }
    
    private func updateView() {
        
        let url = "http://blog.popmetrics.io/wp-content/uploads/sites/13/2017/07/shutterstock_397574752-1600x1015.jpg"
        cardImageView.af_setImage(withURL: URL(string: url)!)
        
        return
        if let title = todoCard.headerTitle {
            cardTitle.text = title
        }
    }
    
    internal func configure(_ todoCard: TodoCard) {
        self.todoCard = todoCard
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
