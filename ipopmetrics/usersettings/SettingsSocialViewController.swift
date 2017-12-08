//
//  SettingsSocialViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 20/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class SettingsSocialViewController: SettingsBaseViewController {
    
    var currentBrand: Brand?
    
    @IBOutlet weak var brandURLLabel: UILabel!
    @IBOutlet weak var brandNameLabel: UILabel!
    
    @IBOutlet weak var connectionDateLabel: UILabel!
    
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
            brandURLLabel.text = currentBrand?.twitterDetails?.screenName ?? "N/A"
            brandNameLabel.text = currentBrand?.twitterDetails?.name ?? "N/A"
            
            if let date = currentBrand?.twitterDetails?.connectionDate {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd hh:mm:ss"
                self.connectionDateLabel.text = df.string(from: date)
            }
            connectionDateLabel.text = "http://www.twitter.com/brandname"
            break
        case .linkedin:
            brandURLLabel.text = "http://www.linkedin.com/username"
            connectionDateLabel.text = "http://www.linkedin.com/brandname"
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
