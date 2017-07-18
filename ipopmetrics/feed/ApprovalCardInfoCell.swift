//
//  ApprovalCardInfoCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ApprovalCardInfoCell: UITableViewCell {
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var secondContainerView: UIView!
    
    @IBOutlet weak var connectionView: UIView!
    
    
    func configure(_ item: FeedItem, handler: CardActionHandler) {
        addGradient();
    }
    
    func addGradient() {
        let colorTop = UIColor(red: 255/255, green: 240/255, blue: 162/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1.0).cgColor
        
        let gl = CAGradientLayer()
        gl.colors = [colorTop, colorBottom]
        gl.locations = [0.0, 1.0]
    
        self.secondContainerView.layer.insertSublayer(gl, at: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGradient();
        adjustLabelLineSpaceing()
        setCornerRadious()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func adjustLabelLineSpaceing() {
        
        messageLabel.sizeToFit()
        
        if let messageText = messageLabel.text {
            let attributedString = NSMutableAttributedString(string: messageText)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 3
            style.maximumLineHeight = 20
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: (messageText.characters.count)))
            messageLabel.attributedText = attributedString
        }
    }
    
    func setCornerRadious() {
        
        secondContainerView.layer.cornerRadius = 14
        secondContainerView.layer.masksToBounds = true
        
    }
    
    
}
