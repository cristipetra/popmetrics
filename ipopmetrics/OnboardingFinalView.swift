//
//  OnboardingFinalView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 21/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Hero

class OnboardingFinalView: UIViewController {
    
    @IBOutlet weak var greatJobLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        if self.greatJobLabel != nil {
            greatJobLabel.adjustLabelSpacing(spacing: 0, lineHeight: 34, letterSpacing: 1)
        }
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.goToMainStoryboard()
        }
    }
    
    func goToMainStoryboard() {
        let mainTabVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewNames.SBID_MAIN_TAB_VC)
        self.present(mainTabVC, animated: true, completion: nil)
    }
}
