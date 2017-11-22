//
//  OnboardingViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import GTProgressBar
import Hero

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var verifySocialButton: TwoImagesButton!
    @IBOutlet weak var credentialsButton: RoundedCornersButton!
    @IBOutlet weak var maybeLaterButton: RoundedCornersButton!
    
    @IBOutlet weak var topLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        let user = UsersStore.getInstance().getLocalUserAccount()
        
        guard let _ = user.name else {
            return
        }
        topLabel.text = "Hey [" + user.name! + "] please verify your connection to [\(user.businessURL)] using social media:"
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
    @IBAction func handlerButtonPressed(_ sender: Any) {
        let notificationsVC = AppStoryboard.Notifications.instance.instantiateViewController(withIdentifier: ViewNames.SBID_PUSH_NOTIFICATIONS_VC)
        let finalOnboardingVC = OnboardingFinalView()
        let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
        if notificationType == [] {
            self.present(notificationsVC, animated: true, completion: nil)
        } else {
            self.present(finalOnboardingVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
