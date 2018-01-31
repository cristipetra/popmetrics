//
//  PopTipCard.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@objc protocol PopTipCellDelegate: class {
    @objc func popTipCellDidTapAction(_ feedCard: FeedCard)
    @objc func popTipCellDidTapMoreInfo(_ feedCard: FeedCard)
}

class PopTipCard: UITableViewCell {
    
    @IBOutlet weak var toolBarView: ToolbarViewCell!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionLine: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var footerVIew: FooterView!
    
    private var feedCard: FeedCard!
    weak var delegate: PopTipCellDelegate?
    
    @IBOutlet weak var constraintHeightTitle: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightFooterView: NSLayoutConstraint!
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.backgroundImageView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        setupCorners()
        setUpShadowLayer()
        
        footerVIew.actionButton.addTarget(self, action: #selector(handlerActionButton), for: .touchUpInside)
        
        footerVIew.leftButton.isHidden = true
    }
    
    public func configure(_ feedCard: FeedCard, handler: RecommendActionHandler? = nil) {
        self.feedCard = feedCard
        
        if let _ = feedCard.headerTitle {
            titleLabel.setTextWhileKeepingAttributes(string: feedCard.headerTitle!)
        }
        
        if let _ = feedCard.message {
            messageLabel.text = feedCard.message!
        }
        
        if let imageUrl = feedCard.imageUri {
            if let url = URL(string: imageUrl) {
                backgroundImageView.af_setImage(withURL: url)
            }
        }
        
        if !feedCard.actionLabel.isEmpty {
            constraintHeightTitle.constant <= 140
            constraintHeightFooterView.constant = 94
            footerVIew.actionButton.changeTitle(feedCard.actionLabel)
        } else {
            constraintHeightFooterView.constant = 0
            constraintHeightTitle.constant = 440
        }
        
    }
    
    @objc func handlerActionButton() {
        guard let _ = feedCard else { return }
        delegate?.popTipCellDidTapAction(feedCard)
    }
    
    @objc func handlerMoreInfo() {
        guard let _ = feedCard else { return }
        delegate?.popTipCellDidTapMoreInfo(feedCard)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
            self.containerView.layer.masksToBounds = true
        }
    }
    
    private func setTitleRecommended(title: String) {
        titleLabel.text = title
    }
    
    private func setTitleInsight(title: String) {
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
    }
    
    private func setMessage(message: String) {
        messageLabel.text = message
    }
    
    func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.topAnchor.constraint(equalTo: toolBarView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        shadowLayer.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 12
    }
    
}

extension UILabel {
    func setTextWhileKeepingAttributes(string: String) {
        if let newAttributedText = self.attributedText {
            let mutableAttributedText = newAttributedText.mutableCopy()
            
            (mutableAttributedText as AnyObject).mutableString.setString(string)
            
            self.attributedText = mutableAttributedText as? NSAttributedString
        }
    }
}

