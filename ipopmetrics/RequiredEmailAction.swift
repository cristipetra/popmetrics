//
//  RequiredEmailAction.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 09/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import SwiftRichString

class RequiredEmailAction: UITableViewCell {
    
    
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var connectionView: UIView!
    
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setEmailFieldPlaceholder()
        setUpFooterView()
        setUpTopView()
        setUpShadowLayer()
        setupCorners()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setEmailFieldPlaceholder() {
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "youremail@emaildom.com", attributes: [NSForegroundColorAttributeName: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1), NSFontAttributeName: UIFont(name: FontBook.semibold, size: 15)!])
        
    }
    
    internal func setTitle(title: String) {
        
        titleLbl.text = title
        
    }
    
    internal func setMessage(message: String) {
        
        messageLbl.text = message
    }
    
    private func setUpFooterView() {
        
        footerView.backgroundColor = UIColor.clear
        footerView.isOpaque = false
        footerView.setIsTrafficUnconnected()
        footerView.xButton.alpha = 1
        footerView.hideButton(button: footerView.loadMoreBtn)
        footerView.approveLbl.text = "Send confirmation \nemail"
        footerView.approveLbl.textColor = UIColor.white
        footerView.actionButton.leftImageView.image = UIImage(named: "iconLetter")?.withRenderingMode(.alwaysOriginal)
    }
    
    internal func setupCorners() {
        DispatchQueue.main.async {
            self.containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 12)
            self.containerView.layer.masksToBounds = true
        }
    }
    
    private func setUpTopView() {
        
        toolbarView.isLeftImageHidden = false
        toolbarView.leftImage.image = UIImage(named: "iconAlertMessage")
        toolbarView.leftImage.contentMode = .scaleAspectFit
        toolbarView.backgroundColor = UIColor(red: 255/255, green: 119/255, blue: 106/255, alpha: 1)
        
        let headsUpStyle = Style.default { (style) -> (Void) in
            
            style.font = FontAttribute(FontBook.bold, size: 15)
            style.color = UIColor.white
        }
        
        let requiredAction = Style.default {
            
            $0.font = FontAttribute(FontBook.regular, size: 15)
            $0.color = UIColor.white
        }
        
        let headerTitle = "Heads Up: ".set(style: headsUpStyle) + "Required Action".set(style: requiredAction)
        toolbarView.title.attributedText = headerTitle
    }
    
    private func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.topAnchor.constraint(equalTo: toolbarView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        shadowLayer.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        self.backgroundColor = UIColor.feedBackgroundColor()
        shadowLayer.layer.cornerRadius = 12
    }
    
    
    
}
