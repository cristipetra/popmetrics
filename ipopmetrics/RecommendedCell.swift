//
//  RecommendedCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

protocol RecommendeCellDelegate: class {
    func recommendedCellDidTapAction(_ feedCard: FeedCard)
}

class RecommendedCell: UITableViewCell {
    
    @IBOutlet weak var toolBarView: ToolbarViewCell!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionLine: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var footerVIew: FooterView!
    
    
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
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.backgroundImageView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        setupCorners()
        setUpShadowLayer()
        
        setUpToolbar(imageName: "iconHeaderBranding", titleName: "Popmetrics Insight")
        titleHeightConstraint.constant = 150
        titleLabel.numberOfLines = 4
        self.titleLabel.font = UIFont(name: FontBook.alfaRegular, size: 26)
        self.backgroundImageView.image = UIImage(named: "imagePyramid")
        self.messageLabel.textColor = UIColor.white
        self.messageLabel.font = UIFont(name: FontBook.regular, size: 18)
        self.messageLabel.numberOfLines = 5
            
        footerVIew.actionButton.addTarget(self, action: #selector(handlerActionButton), for: .touchUpInside)
    }
    
    public func configure(_ feedCard: FeedCard, handler: RecommendActionHandler? = nil) {
        self.feedCard = feedCard
        
        print(feedCard)
        
        titleLabel.text = feedCard.headerTitle!
        messageLabel.text = feedCard.message!
        
        footerVIew.actionButton.changeTitle(feedCard.actionLabel)
        
        //footerVIew.displayOnlyActionButton()
    }
    
    @objc func handlerActionButton() {
        guard let _ = feedCard else { return }
        delegate?.recommendedCellDidTapAction(feedCard)
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
        titleLabel.textColor = UIColor.white
        self.titleLabel.font = UIFont(name: FontBook.bold, size: 23)
    }
    
    private func setTitleInsight(title: String) {
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        self.titleLabel.font = UIFont(name: FontBook.bold, size: 18)
    }
    
    private func setMessage(message: String) {
        messageLabel.text = message
        messageLabel.numberOfLines = 5
    }
    
    private func setUpToolbar(imageName: String, titleName: String) {
        
        self.toolBarView.isLeftImageHidden = false
        self.toolBarView.leftImage.image = UIImage(named: imageName)
        self.toolBarView.title.text = titleName
        self.toolBarView.leftImage.contentMode = UIViewContentMode.scaleAspectFit
        self.toolBarView.title.font = UIFont(name: FontBook.bold, size: 15)
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
