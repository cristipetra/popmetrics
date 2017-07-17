//
//  WelcomeScreen.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 17/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class WelcomeScreen: UIViewController {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpColors()
        setUpCornerRadious()
        addShadowToView(blueButton)
        addShadowToView(btnNew)
        addShadowToView(heartButton)
    }
    
    
    private func setUpColors() {
        containerView.backgroundColor = UIColor(red: 255/255, green: 221/255, blue: 105/255, alpha: 1.0)
        blueButton.layer.backgroundColor = UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1.0).cgColor
        blueButton.setTitleColor(UIColor.white, for: .normal)
        btnNew.backgroundColor = UIColor.white
        heartButton.backgroundColor = UIColor.white
    }
    
    private func setUpCornerRadious() {
        blueButton.layer.cornerRadius = 30
        btnNew.layer.cornerRadius = 30
        heartButton.layer.cornerRadius = heartButton.frame.width / 2
    }
    
    internal func addShadowToView(_ toView: UIView) {
        toView.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        toView.layer.shadowOpacity = 0.3;
        toView.layer.shadowRadius = 2
        toView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        toView.layer.shouldRasterize = true
    }
    
}
