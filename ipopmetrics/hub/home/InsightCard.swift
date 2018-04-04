//
//  RecommendedCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

@objc protocol RecommendeCellDelegate: class {
    @objc func recommendedCellDidTapAction(_ feedCard: FeedCard)
    @objc func cellDidTapMoreInfo(_ feedCard: FeedCard)
}

class InsightCard: UITableViewCell {
    
    @IBOutlet weak var toolBarView: ToolbarViewCell!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionLine: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var footerVIew: FooterView!
    @IBOutlet weak var constraintBottomContainerView: NSLayoutConstraint!
    
    private var feedCard: FeedCard!
    weak var delegate: RecommendeCellDelegate?
    
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
        footerVIew.leftButton.addTarget(self, action: #selector(handlerMoreInfo), for: .touchUpInside)
    
        footerVIew.changeTitleLeftButton("View Analysis")
        updateTitleFont()
    }
    
    private func updateTitleFont() {
        if Utils.isPlusSize {
            titleLabel.font = UIFont(name: FontBook.extraBold, size: 30)
        }
    }
    
    public func configure(_ feedCard: FeedCard, handler: RecommendActionHandler? = nil) {
        self.feedCard = feedCard
        
        if feedCard.isTest {
            self.toolBarView.changeColorCircle(color: UIColor(named:"blue_bottle")!)
        }
        
        //titleLabel.text = feedCard.headerTitle!
        titleLabel.setTextWhileKeepingAttributes(string: feedCard.headerTitle!)
        
        //titleLabel.attributedText = feedCard.headerTitle!
        messageLabel.text = feedCard.message!
        footerVIew.actionButton.changeTitle(feedCard.actionLabel)
        
        if let imageUrl = feedCard.imageUri {
            if let url = URL(string: imageUrl) {
                backgroundImageView.af_setImage(withURL: url)
            }
        }

        if feedCard.recommendedAction.isEmpty || feedCard.recommendedAction == "" {
            footerVIew.actionButton.isHidden = true
        }
        else {
            if TodoStore.getInstance().getTodoCardWithName(feedCard.recommendedAction) != nil {
                footerVIew.actionButton.isHidden = false
            }
            else {
                footerVIew.actionButton.isHidden = true
            }
                
        }
        
    }
    
    internal func updateVisibilityConnectionLine(_ indexPath: IndexPath) {
        let cards = HomeHubSection().getSectionCardsThatHasActiveCellView("Insights")
        if(cards.count - 1 == indexPath.row) {
            connectionLine.isHidden = true;
            constraintBottomContainerView.constant = 0
        } else {
            connectionLine.isHidden = false
            constraintBottomContainerView.constant = 37
        }
    }
    
    @objc func handlerActionButton() {
        guard let _ = feedCard else { return }
        delegate?.recommendedCellDidTapAction(feedCard)
    }
    
    @objc func handlerMoreInfo() {
        guard let _ = feedCard else { return }
        delegate?.cellDidTapMoreInfo(feedCard)
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
