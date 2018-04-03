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
        
        setNavigationBar()
        
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
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        let logoImageView = UIImageView(image: UIImage(named: "logoPop"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        logoImageView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = logoImageView
    
        let backButton = UIBarButtonItem()
        self.navigationItem.leftBarButtonItems = [backButton]
    }
    
    func goToMainStoryboard() {
        self.navigationController?.popToRootViewController(animated: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainTabVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewNames.SBID_MAIN_TAB_VC)
        appDelegate.window?.rootViewController = mainTabVC

        self.present(mainTabVC, animated: true, completion: nil)
    }
}
