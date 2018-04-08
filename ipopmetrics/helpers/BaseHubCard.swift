//
//  BaseHubCard.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//
import UIKit

class BaseHubCard: UITableViewCell, HubCell {

    @IBOutlet weak var toolbarView: ToolbarViewCell!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var containerView: UIStackView!
    
    
    @IBOutlet weak var connectionLineView: UIView!
    
    
    @IBOutlet weak var constraintHeightConnectionLine: NSLayoutConstraint!
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var primaryActionButton: UIButton!
    @IBOutlet weak var secondaryActionButton: UIButton!



    var card: HubCard?
    var hubController: HubControllerProtocol?
    var indexPath: IndexPath?
    
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.containerView.backgroundColor = PopmetricsColor.salmondColor
        setupToolbarView()
        setupCorners()
        setUpShadowLayer()
        
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateHubCell( card: HubCard, hubController: HubControllerProtocol, options:[String:Any] = [String:Any]()) {
        
        self.card = card
        self.hubController = hubController
        if card.isTest {
            toolbarView.setUpCircleBackground(topColor: UIColor(named:"blue_bottle")!, bottomColor: UIColor(named:"blue_bottle")!)
        }
        
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
        
        let isLastCard = options["isLastCard", default:false] as! Bool
        if isLastCard {
            self.connectionLineView.isHidden = true
        }
        else {
            self.connectionLineView.isHidden = false
        }
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
            self.containerView.layer.masksToBounds = true
        }
    }
    
    func setupToolbarView() {
        let toolbarController: CardToolbarController  = CardToolbarController()
        toolbarController.setUpTopView(toolbarView: toolbarView)
    }
    
    func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.topAnchor.constraint(equalTo: toolbarView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        shadowLayer.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 12
    }
    
    
    
    @IBAction func primaryActionHandler(_ sender: Any) {
        print("primary action tapped")
        self.hubController?.handleCardAction(card:self.card!, actionType:"primary")
        
    }
    
    @IBAction func secondaryActionHandler(_ sender: Any) {
        print("secondary action tapped")
        self.hubController?.handleCardAction(card:self.card!, actionType:"secondary")
        
    }
    
    
    internal func changeVisibilityConnectionLine(isHidden: Bool) {
        if isHidden {
            constraintHeightConnectionLine.constant = 0
        } else {
            constraintHeightConnectionLine.constant = 37
        }
    }
    
    
}
