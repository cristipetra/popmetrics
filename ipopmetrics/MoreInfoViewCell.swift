//
//  MoreInfoViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class  MoreInfoViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var messageLbl: UILabel!
    
    lazy var shadowLayer: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.feedBackgroundColor()
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.containerView.backgroundColor = UIColor.feedBackgroundColor()
        toolbarView.backgroundColor = UIColor(red: 101/255, green: 108/255, blue: 114/255, alpha: 1)
        setUpFooter()
        setUpShadowLayer()
        
        messageLbl.setLineSpacingAndTitle(text: "Dive deeper and go further Here are (2) extra cards for you to get even better.", spacing: 2.3,letterSpacing: 0.5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpToolbar() {
        
        toolbarView.title.text = "More Info"
        toolbarView.setupCircleView()
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        toolbarView.circleView.addSubview(label)
        label.layer.cornerRadius = 8
        label.text = "i"
        label.font = UIFont(name: FontBook.bold, size: 12)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(red: 101/255, green: 108/255, blue: 114/255, alpha: 1)
        label.layer.borderWidth = 1.5
        label.layer.borderColor = UIColor.white.cgColor
        label.textAlignment = .center
        
    }
    
    private func setUpFooter() {
        
        footerView.actionButton.leftHandImage = UIImage(named:"icon2CtaShowitems")
        footerView.informationBtn.isHidden = true
        footerView.approveLbl.text = "Show Items"
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
    
}


extension UILabel {
    
    func setLineSpacingAndTitle(text: String, spacing: CGFloat, letterSpacing: CGFloat) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = spacing
        
        let attrString = NSMutableAttributedString(string: text)
        
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        attrString.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSRange(location: 0, length: attrString.length))
        
        self.attributedText = attrString
    }
}
