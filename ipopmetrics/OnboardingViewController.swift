//
//  OnboardingViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import GTProgressBar

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var verifySocialButton: TwoImagesButton!
    @IBOutlet weak var credentialsButton: RoundedCornersButton!
    @IBOutlet weak var maybeLaterButton: RoundedCornersButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
    }
    
    func setup() {
        maybeLaterButton.backgroundColor = UIColor.white
        maybeLaterButton.setShadow()
        credentialsButton.backgroundColor = UIColor.white
        credentialsButton.setShadow()
    }
    @IBAction func verifySocialButtonPressed(_ sender: UIButton) {
        let verifySocialVC = VerifySocialViewController()
        self.present(verifySocialVC, animated: true, completion: nil)
    }
}
