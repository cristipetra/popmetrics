//
//  IceCardViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import M13ProgressSuite

protocol RecommendedActionViewCellDelegate: class {
    func recommendedActionViewCellDidTapAction(_ feedCard: FeedCard)
}

class IceCardViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toolBar: ToolbarViewCell!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var middleContainerView: UIView!
    @IBOutlet weak var impactMainProgressView: UIView!
    @IBOutlet weak var costMainProgressView: UIView!
    @IBOutlet weak var effortMainProgressView: UIView!
    @IBOutlet weak var connectionView: UIView!
    
    
    // Extend View
    lazy var impactProgress: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 137/255, alpha: 1)
        return view
    }()
    
    lazy var costProgress: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 137/255, alpha: 1)
        return view
    }()
    
    lazy var effortProgress: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 137/255, alpha: 1)
        return view
    }()
    
    lazy var shadowLayer: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.feedBackgroundColor()
        return view
    }()
    // end extend view
    
    private var feedCard: FeedCard!
    weak var delegate: RecommendedActionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.containerView.backgroundColor = UIColor.feedBackgroundColor()
        middleContainerView.layer.cornerRadius = 12
        
        setUpFooter()
        setUpToolbar()
        setUpShadowLayer()
        
        DispatchQueue.main.async {
            self.impactProgressValue(value: 100)
            self.costProgressValue(value: 40)
            self.effortProgressValue(value: 60)
        }
        
        self.connectionView.isHidden = true
        
        //add target
        footerView.actionButton.addTarget(self, action: #selector(handlerActionButton(_:)), for: .touchUpInside)
    }
    
    
    func configure(_ card: FeedCard) {
        feedCard = card
    }
    
    @objc internal func handlerActionButton(_ sender: TwoImagesButton) {
        guard let _ = feedCard else { return }
        delegate?.recommendedActionViewCellDidTapAction(feedCard)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        shadowLayer.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 12
        self.containerView.layer.cornerRadius = 12
    }
    
    func setProgress(animationBounds: CGRect, value: CGFloat, childOff: UIView, animationColor: UIColor?, animationDuration: CGFloat?) {
        let view = M13ProgressViewBorderedBar(frame: animationBounds)
        let progressValue = value / 100
        view.primaryColor = animationColor
        view.animationDuration = animationDuration == nil ? 6 : animationDuration!
        view.borderWidth = 0
        childOff.addSubview(view)
        view.setProgress(progressValue, animated: true)
        if value == 1 {
            view.roundCorners(corners: [.allCorners], radius: 5)
        } else {
            view.roundCorners(corners: [.bottomLeft, .topLeft], radius: 5)
        }
    }
    
    internal func impactProgressValue(value : CGFloat) {
        setProgress(animationBounds: impactMainProgressView.bounds, value: value, childOff: impactMainProgressView, animationColor: PopmetricsColor.yellowBGColor, animationDuration: nil)
    }
    
    internal func costProgressValue(value : CGFloat) {
        setProgress(animationBounds: costMainProgressView.bounds, value: value, childOff: costMainProgressView, animationColor: PopmetricsColor.yellowBGColor, animationDuration: nil)
    }
    
    internal func effortProgressValue(value : CGFloat) {
        setProgress(animationBounds: effortMainProgressView.bounds, value: value, childOff: effortMainProgressView, animationColor: PopmetricsColor.yellowBGColor, animationDuration: nil)
    }
    
    private func setUpToolbar() {
        toolBar.changeColorCircle(color: UIColor(red: 255/255, green: 189/255, blue: 80/255, alpha: 1))
        toolBar.title.text = "Recommended Action"
    }
    
    private func setUpFooter() {
        footerView.configure(.action)
    }
    
}
