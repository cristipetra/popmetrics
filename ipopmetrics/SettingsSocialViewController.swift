//
//  SettingsSocialViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 20/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsSocialViewController: SettingsBaseViewController {
    
    @IBOutlet weak var brandURLLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    
    private var socialType: SocialType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigationWithBackButton()
        changeSocialType()
    }
    
    func displayTwitter() {
        titleWindow = "TWITTER ACCOUNT"
        socialType = .twitter
    }
    
    func displayLinkedin() {
        titleWindow = "LINKEDIN ACCOUNT"
        socialType = .linkedin
    }
    
    func displayFacebook() {
        titleWindow = "FACEBOOK ACCOUNT"
        socialType = .facebook
    }
    
    private func changeSocialType() {
        switch socialType {
        case .facebook:
            brandURLLabel.text = "http://www.facebook.com/brandname"
        case .twitter:
            brandURLLabel.text = "http://www.twitter.com/brandname"
            break
        case .linkedin:
            brandURLLabel.text = "http://www.linkedin.com/username"
            break
        default:
            break
        }
    }
    
}

enum SocialType: String {
    case linkedin = "linkedin"
    case twitter = "twitter"
    case facebook = "facebook"
}
