//
//  DailyInsightsCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class DailyInsightsCardCell: UITableViewCell {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imageTitle: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstMessageLabel: UILabel!
    @IBOutlet weak var secondMessageLabel: UILabel!
    @IBOutlet weak var bottomImage: UIImageView!
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var secondContainerView: UIView!
    
    
    
    func configure(_ item: FeedItem, handler: CardActionHandler) {
        setupView()
    }
    
    func setupView() {
        headerView.backgroundColor = UIColor.turquoiseColor()
        self.backgroundColor = UIColor.feedBackgroundColor()
        connectionView.backgroundColor = UIColor.turquoiseColor()
        setCornerRadious()
        
        adjustLabelLineSpacing()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func adjustLabelLineSpacing() {
        
        if let firstMessage = firstMessageLabel.text {
            let attributedString = NSMutableAttributedString(string: firstMessage)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            style.maximumLineHeight = 23
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: (firstMessage.characters.count)))
            firstMessageLabel.attributedText = attributedString
        }
        
        if let secondMessage = secondMessageLabel.text {
            let attributedString = NSMutableAttributedString(string: secondMessage)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            style.maximumLineHeight = 23
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: (secondMessage.characters.count)))
            secondMessageLabel.attributedText = attributedString
        }
        
    }
    
    func setCornerRadious() {
        secondContainerView.layer.cornerRadius = 14
        secondContainerView.layer.masksToBounds = true
        
        learnMoreButton.layer.cornerRadius = 30
        learnMoreButton.layer.masksToBounds = true
        
    }
    
    
}
