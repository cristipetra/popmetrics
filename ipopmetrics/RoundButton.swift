//
//  RoundButton.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 20/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    var timer: Timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup();
    }
    
    func setup() {
        DispatchQueue.main.async {
            
        }
        setBorder()
        self.setRadius()
        setShadows()
    }
    
    private func setBorder() {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = PopmetricsColor.textGrey.cgColor
    }
    
    private func setRadius() {
        self.layer.cornerRadius = self.frame.height / 2
        self.tintColor = PopmetricsColor.darkGrey
    }
    
    private func setShadows() {
        self.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.22).cgColor
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.white
    }
    
    func shouldPulsate(_ pulsate: Bool) {
        if(pulsate) {
            startPulsate()
        } else {
            endPulsate()
        }
    }
    
    private func startPulsate() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        self.pulsate()
    }

    private func endPulsate() {
         timer.invalidate()
    }


}

extension UIButton {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
}
