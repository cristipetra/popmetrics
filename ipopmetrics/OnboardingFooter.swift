//
//  OnboardingFooter.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class OnboardingFooter: UIView {
    
    @IBOutlet weak var continueButton: RoundedCornersButton!
    @IBOutlet weak var questionButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let view = Bundle.main.loadNibNamed("OnboardingFooter", owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        continueButton.isUserInteractionEnabled = false
        continueButton.backgroundColor = PopmetricsColor.onboardingButtonDisabled
        continueButton.setTitleColor(PopmetricsColor.onboardingButtonTextDisabled, for: .normal)
        continueButton.setShadow()
    }
    
    func enableContinueButton() {
        continueButton.backgroundColor = PopmetricsColor.blueURLColor
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.isUserInteractionEnabled = true
    }
}
