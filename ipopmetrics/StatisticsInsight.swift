//
//  StatisticsInsight.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 04/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class StatisticsInsight: UIView {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var maximizeButton: UIButton!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var attentionLabel: UILabel!
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        Bundle.main.loadNibNamed("StatisticsInsight", owner: self, options: nil)
        self.addSubview(self.view)
        
        
        let buttonImage = UIImage(named: "iconCalRightBold")!.withRenderingMode(.alwaysTemplate)
        maximizeButton.imageView?.contentMode = .scaleAspectFill
        buttonImage.bma_tintWithColor(UIColor.white)
        maximizeButton.transform = maximizeButton.transform.rotated(by: 3*CGFloat.pi/2)
        maximizeButton.setImage(buttonImage, for: .normal)
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        attentionLabel.adjustLabelSpacing(spacing: 0, lineHeight: 23, letterSpacing: 0.4)
        //messageLabel.adjustLabelSpacing(spacing: 0, lineHeight: 23, letterSpacing: 0.5)
        
        self.messageLabel.text = "Google Plus is an important part of your digital footprint. Creating one will help increase your brand awareness and help bring in new customers"
    }
}
