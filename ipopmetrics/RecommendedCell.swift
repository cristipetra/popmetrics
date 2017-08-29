//
//  RecommendedCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class RecommendedCell: UITableViewCell {
    
    @IBOutlet weak var toolBarView: ToolbarViewCell!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionLine: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var footerVIew: FooterView!
    @IBOutlet weak var secondMessageLabel: UILabel!
    
    
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
        secondMessageLabel.numberOfLines = 2
    }
    
    private func setUpToolbar(imageName: String, titleName: String) {
        
        self.toolBarView.isLeftImageHidden = false
        self.toolBarView.leftImage.image = UIImage(named: imageName)
        self.toolBarView.title.text = titleName
        self.toolBarView.leftImage.contentMode = UIViewContentMode.scaleAspectFit
        self.toolBarView.title.font = UIFont(name: FontBook.bold, size: 15)
    }
    
    func setUpCell(type: String) {
        
        switch type {
        case "Recommended Reading":
            setUpToolbar(imageName: "iconHeaderArticle", titleName: "Recommended Reading")
            self.backgroundImageView.image = UIImage(named: "image_pattern")
            self.setTitleRecommended(title : "This Is An Article For You To Read (Title)")
            self.setMessage(message: "Short explanation of what the story is here leading to a blog post about what the user should be doing in their best course of action and how it relates to their business.")
            self.messageLabel.textColor = UIColor(red: 189/255, green: 197/255, blue: 203/255, alpha: 1)
            self.messageLabel.font = UIFont(name: FontBook.semibold, size: 15)
            self.secondMessageLabel.isHidden = true
            self.footerVIew.actionButton.leftHandImage = UIImage(named: "icon2CtaViewarticle")
            self.footerVIew.approveLbl.text = "View Article"
            self.footerVIew.approveLbl.textColor = UIColor.black
            
            break
        case "Popmetrics Insight":
            setUpToolbar(imageName: "iconHeaderBranding", titleName: "Popmetrics Insight")
            self.backgroundImageView.image = UIImage(named: "imagePyramid")
            self.setTitleInsight(title : "We've had a look and your brand's Twitter could do with some love!")
            self.setMessage(message: "We've looked at your industry and prepared some actions for you to improve your digital footprint: ")
            self.messageLabel.textColor = UIColor.white
            self.messageLabel.font = UIFont(name: FontBook.regular, size: 18)
            self.secondMessageLabel.text = ""
            self.secondMessageLabel.textColor = UIColor.white
            self.secondMessageLabel.font = UIFont(name: FontBook.regular, size: 18)
            
            //self.footerVIew.informationBtn.isHidden = true
            self.footerVIew.actionButton.imageButtonType = .todo
            self.footerVIew.approveLbl.text = "Connect Twitter"
            self.footerVIew.approveLbl.textColor = UIColor.black
            self.connectionLine.isHidden = true
            break
        default:
            break
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
