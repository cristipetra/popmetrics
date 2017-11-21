//
//  ApprovalCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ApprovalCardCell: UITableViewCell {
    @IBOutlet weak var secondContentView: UIView!
    
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var connectionView: UIView!

    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnDeny: UIButton!
    @IBOutlet weak var btnAllow: UIButton!
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
    func configure(_ item: FeedCard, handler: CardActionHandler) {
        self.titleLabel.text = item.headerTitle
        //self.messageLabel.text = item.message
        
         adjustLabelLineSpaceing()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCornerRadious()
        headerView.backgroundColor = UIColor(red: 255/255.0, green: 221/255.0, blue: 105/255.0, alpha: 1.0)
        self.backgroundColor = UIColor.cloudsColor()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func adjustLabelLineSpaceing() {
        if let titleText = titleLabel.text {
            let attributedString = NSMutableAttributedString(string: titleText)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            style.maximumLineHeight = 23
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: (titleText.characters.count)))
            titleLabel.attributedText = attributedString
        }
        
        if let messageText = messageLabel.text {
            let attributedString = NSMutableAttributedString(string: messageText)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            style.maximumLineHeight = 20
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: (messageText.characters.count)))
            messageLabel.attributedText = attributedString
        }
    }
    
    func setCornerRadious() {
        secondContentView.layer.cornerRadius = 14
        secondContentView.layer.masksToBounds = true
        
        btnSearch.layer.cornerRadius = btnSearch.layer.frame.width / 2
        btnDeny.layer.cornerRadius = btnDeny.layer.frame.width / 2
        btnAllow.layer.cornerRadius = btnAllow.layer.frame.width / 2
        btnSearch.layer.masksToBounds = true
        btnDeny.layer.masksToBounds = true
        btnAllow.layer.masksToBounds = true
    }
}
