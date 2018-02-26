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
    @IBOutlet weak var messageLabel: UILabel!
    
    private var requiredActionHandler = RequiredActionHandler()
    
    private var socialType: SocialType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigationWithBackButton()
        changeSocialType()
        changeMessage()
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
    
    private func changeMessage() {
        switch socialType {
        case .facebook:
            messageLabel.text = "Popmetrics, with your approval, will share content on your Facebook channel to generate traffic to your website. Our software will also use your Facebook information to measure your digital footprint and benchmark you against your competition."
        case .twitter:
            messageLabel.text = "Popmetrics, with your approval, will share content on your Twitter profile to generate traffic to your website. Our software will also use your Twitter information to measure your digital footprint and benchmark you against your competition."
        case .linkedin:
            messageLabel.text = "Popmetrics, with your approval, will share content on your LinkedIn page to generate traffic to your website. Our software will also use your LinkedIn information to measure your digital footprint and benchmark you against your competition."
        default:
            break
        }
    }
    
    private func changeSocialType() {
        switch socialType {
        case .facebook:
            //brandURLLabel.text = currentBrand?.facebookDetails?.screenName ?? "N/A"
            //brandNameLabel.text = currentBrand?.facebookDetails?.name ?? "N/A"
            
            if let date = currentBrand?.facebookDetails?.connectionDate {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd hh:mm:ss"
                self.connectionDateLabel.text = df.string(from: date)
            }
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
    
    @IBAction func handlerDisconectSocial(_ sender: UIButton) {
        if socialType == SocialType.linkedin {
            requiredActionHandler.disconnectTwitter()
        }
    }
    
}

enum SocialType: String {
    case linkedin = "linkedin"
    case twitter = "twitter"
    case facebook = "facebook"
}
