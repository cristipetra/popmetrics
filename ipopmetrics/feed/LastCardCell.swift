//
//  LastCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class LastCardCell: UITableViewCell {
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var imageTitle: UIImageView!
    @IBOutlet weak var xbutton: RoundButton!
    @IBOutlet weak var goToButton: TwoImagesButton!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleActionButton: UILabel!
    
    internal var shadowView: UIView!;
    
    lazy var shadowLayer : UIView  = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.goToButton.backgroundColor = PopmetricsColor.yellowBGColor
        setCornerRadiou()
        setShadows(view: goToButton)
        setUpShadowLayer()
        
        self.xbutton.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCornerRadiou() {
        secondContainerView.layer.cornerRadius = 12
        secondContainerView.layer.masksToBounds = true
        self.goToButton.layer.borderWidth = 2.0
        self.goToButton.layer.borderColor = PopmetricsColor.darkGrey.cgColor
        self.goToButton.layer.cornerRadius = self.goToButton.frame.height / 2
    }
    
    private func setShadows(view: AnyObject) {
        view.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.22).cgColor
        view.layer.shadowOpacity = 1.0;
        view.layer.shadowRadius = 2.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    func changeTitleWithSpacing(title: String) {
        self.titleLabel.text = title
        titleLabel.adjustLabelSpacing(spacing: 1.5, lineHeight: 24, letterSpacing: 0.3);
    }
    
    func changeMessageWithSpacing(message: String) {
        self.messageLbl.text = message
        messageLbl.adjustLabelSpacing(spacing: 5, lineHeight: 15, letterSpacing: 0.3)
    }
    
    func setUpShadowLayer() {
        self.insertSubview(shadowLayer, at: 0)
        shadowLayer.topAnchor.constraint(equalTo: secondContainerView.topAnchor).isActive = true
        shadowLayer.bottomAnchor.constraint(equalTo: secondContainerView.bottomAnchor).isActive = true
        shadowLayer.leftAnchor.constraint(equalTo: secondContainerView.leftAnchor).isActive = true
        shadowLayer.rightAnchor.constraint(equalTo: secondContainerView.rightAnchor).isActive = true
        
        shadowLayer.layer.masksToBounds = false
        addShadowToView(shadowLayer, radius: 3, opacity: 0.6)
        
        shadowLayer.layer.cornerRadius = 12
    }
    
    @IBAction func closeCard(_ sender: UIButton) {
        //        self.isHidden = true
        //        shouldBeDisplayed = false
        print("x fired")
    }
    
    @IBAction func goToButtonPressed(_ sender: UIButton) {
        print("goTo fired")
    }
}

extension UILabel {
    func adjustLabelSpacing(spacing: CGFloat, lineHeight: CGFloat, letterSpacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: self.text!)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.maximumLineHeight = lineHeight
        attributedString.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSRange(location: 0, length: (self.text?.characters.count)!))
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: (self.text?.characters.count)!))
        self.attributedText = attributedString
    }
}
