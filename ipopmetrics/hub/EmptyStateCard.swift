//
//  RecommendedCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class EmptyStateCard: UITableViewCell {
    
    @IBOutlet weak var toolBarView: ToolbarViewCell!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionLine: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var footerVIew: FooterView!
    
    @IBOutlet weak var constraintHeightImage: NSLayoutConstraint!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
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
        self.selectionStyle = .none
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.backgroundImageView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        setupCorners()
        setUpShadowLayer()
        
        self.footerVIew.actionButton.isHidden = true
        self.footerVIew.leftButton.isHidden = true
        
        footerVIew.actionButton.addTarget(self, action: #selector(handlerActionButton), for: .touchUpInside)
        footerVIew.leftButton.addTarget(self, action: #selector(handlerMoreInfo), for: .touchUpInside)
    }
    
    public func configure(_ feedCard: FeedCard, handler: RecommendActionHandler? = nil) {
        self.feedCard = feedCard
        
        titleLabel.text = feedCard.headerTitle!
        messageLabel.text = feedCard.message!

        footerVIew.actionButton.changeTitle(feedCard.actionLabel)
        
        if let imageUrl = feedCard.imageUri {
            if imageUrl.isValidUrl() {
                backgroundImageView.af_setImage(withURL: URL(string: imageUrl)!)
            }
        }
        
        self.footerVIew.actionButton.isHidden = true
    }
    
    internal func configure(todoCard: TodoCard) {
        
        titleLabel.text = todoCard.headerTitle
        messageLabel.text = todoCard.message!
        
        if let imageUrl = todoCard.imageUri {
            if let url = URL(string: imageUrl) {
              backgroundImageView.af_setImage(withURL: url)
            }
        }
        
        self.footerVIew.actionButton.isHidden = true
    }
    
    internal func configure(calendarCard: CalendarCard) {
        titleLabel.text = calendarCard.headerTitle
        messageLabel.text = calendarCard.message!
        
        if let imageUrl = calendarCard.imageUri {
            if let url = URL(string: imageUrl) {
                backgroundImageView.af_setImage(withURL: url)
            }
        }
        
        self.footerVIew.actionButton.isHidden = true
    }
    
    internal func configure(statsCard: StatsCard) {
        titleLabel.text = statsCard.headerTitle
        messageLabel.text = statsCard.message!
        
        if let imageUrl = statsCard.imageUri {
            if let url = URL(string: imageUrl) {
                backgroundImageView.af_setImage(withURL: url)
            }
        }
        
        self.footerVIew.actionButton.isHidden = true
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
    }
    
    internal func setMessage(message: String) {
        messageLabel.text = message
    }
    
    internal func setTitleCard(_ title: String) {
        titleLabel.text = title
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
