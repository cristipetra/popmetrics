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

class InsightCard: UITableViewCell, HubCell {
    
    @IBOutlet weak var toolBarView: ToolbarViewCell!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionLine: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var constraintBottomContainerView: NSLayoutConstraint!

    @IBOutlet weak var primaryActionButton: UIButton!
    @IBOutlet weak var secondaryActionButton: UIButton!
    
    var card: HubCard?
    var hubController: HubControllerProtocol?
    
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
        
        updateTitleFont()
    }
    
    private func updateTitleFont() {
        if Utils.isPlusSize {
            titleLabel.font = UIFont(name: FontBook.extraBold, size: 30)
        }
    }
    
    func updateHubCell( card: HubCard, hubController: HubControllerProtocol) {
        self.card = card
        self.hubController = hubController
        if card.isTest {
            toolBarView.setUpCircleBackground(topColor: UIColor(named:"blue_bottle")!, bottomColor: UIColor(named:"blue_bottle")!)
        }
        
        if let imageUrl = card.imageUri {
            if imageUrl.isValidUrl() {
                backgroundImageView.af_setImage(withURL: URL(string: imageUrl)!)
            }
        }
        titleLabel?.text = card.headerTitle
        messageLabel?.text = card.message
        
        if card.primaryAction != "" {
            self.primaryActionButton.isHidden = false
            self.primaryActionButton.setTitle(card.primaryActionLabel, for: .normal)
            self.primaryActionButton.setTitle(card.primaryActionLabel, for: .selected)
        }
        else {
            self.primaryActionButton.isHidden = true
        }
        
        if card.secondaryAction != "" {
            self.secondaryActionButton.isHidden = false
            self.secondaryActionButton.setTitle(card.secondaryActionLabel, for: .normal)
            self.secondaryActionButton.setTitle(card.secondaryActionLabel, for: .selected)
        }
        else {
            self.secondaryActionButton.isHidden = true
        }
        
    }
    
    @IBAction func primaryActionHandler(_ sender: Any) {
        self.hubController?.handleCardAction(card:self.card!, actionType:"primary")
        
    }
    
    @IBAction func secondaryActionHandler(_ sender: Any) {
        self.hubController?.handleCardAction(card:self.card!, actionType:"secondary")
        
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
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
            self.containerView.layer.masksToBounds = true
        }
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
