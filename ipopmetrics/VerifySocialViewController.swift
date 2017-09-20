//
//  VerifySocialViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 19/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import GTProgressBar

class VerifySocialViewController: UIViewController {
    
    @IBOutlet weak var progressBar: GTProgressBar!
    @IBOutlet weak var facebookConnectLabel: UILabel!
    @IBOutlet weak var linkedInConnectButton: TwoImagesButton!
    @IBOutlet weak var twitterConnectLabel: UILabel!
    @IBOutlet weak var linkedInConnectLabel: UILabel!
    @IBOutlet weak var twitterConnectButton: TwoImagesButton!
    @IBOutlet weak var facebookConnectButton: TwoImagesButton!
    @IBOutlet weak var progressViewWrapper: UIView!
    @IBOutlet weak var statusLabelStackView: UIStackView!
    @IBOutlet weak var onboardingFooter: OnboardingFooter!
    @IBOutlet var collectionOflabels: Array<UILabel>?
    var i = 0
    var timer : Timer?
    
    var actionsCompleted: Int = 0 {
        didSet {
            setProgressBar(actionsCompleted: actionsCompleted)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDivider(view: progressViewWrapper)
        setProgressBar(actionsCompleted: actionsCompleted)
        twitterConnectButton.imageButtonType = .twitter
        timer =  Timer.scheduledTimer(timeInterval: 8.0, target: self, selector:#selector(VerifySocialViewController.delayedActionCompletion), userInfo: nil, repeats: true)
        
    }
    func delayedActionCompletion(){
        if i == 4 {
            timer?.invalidate()
        } else {
            i += 1
            actionsCompleted = i
        }
    }
    
    func addDivider(view: UIView) {
        let divider = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5))
        divider.backgroundColor = PopmetricsColor.dividerBorder
        view.addSubview(divider)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setProgressBar(actionsCompleted: Int) {
        switch actionsCompleted {
        case 0:
            progressBar.progress = 0.05
            progressBar.barFillColor = PopmetricsColor.salmondColor
        case 1:
            progressBar.progress = 0.33
            progressBar.barFillColor = PopmetricsColor.yellowBGColor
            setStatusText(actionsCompleted: actionsCompleted)
            onboardingFooter.enableContinueButton()
            setActionDisabled(actionType: .facebook, actionsCompleted: actionsCompleted)
        case 2:
            progressBar.progress = 0.66
            progressBar.barFillColor = PopmetricsColor.yellowBGColor
            setStatusText(actionsCompleted: actionsCompleted)
            setActionDisabled(actionType: .twitter, actionsCompleted: actionsCompleted)
        case 3:
            progressBar.progress = 1
            progressBar.barFillColor = PopmetricsColor.yellowBGColor
            setStatusText(actionsCompleted: actionsCompleted)
            setActionDisabled(actionType: .linkedIn, actionsCompleted: actionsCompleted)
        //showBanner(bannerType: .completed)
        default:
            break
        }
    }
    
    private func setStatusText(actionsCompleted: Int) {
        for it in 0 ..< actionsCompleted {
            collectionOflabels?[it].textColor = PopmetricsColor.textGrey
        }
    }
    
    private func setActionDisabled(actionType: ActionType, actionsCompleted: Int) {
        switch actionType {
        case .facebook:
            facebookConnectLabel.text = "Company Facebook Connected"
            facebookConnectLabel.alpha = 0.3
            facebookConnectButton.changeToDisabled()
            if actionsCompleted < 3 {
                // showBanner(title: "Facebook successfully connected!", subtitle: "Connect all 3 for best results. 👉")
            }
        case .twitter:
            twitterConnectLabel.text = "Twitter Account Connected"
            twitterConnectLabel.alpha = 0.3
            twitterConnectButton.changeToDisabled()
            if actionsCompleted < 3 {
                //showBanner(title: "Twitter successfully connected!", subtitle: "Connect all 3 for best results. 👉")
            }
        case .linkedIn:
            linkedInConnectLabel.text = "LinkedIn Account Connected"
            linkedInConnectLabel.alpha = 0.3
            linkedInConnectButton.changeToDisabled()
            if actionsCompleted < 3 {
                //showBanner(title: "LinkedIn successfully connected!", subtitle: "Connect all 3 for best results. 👉")
            }
        default:
            break
        }
    }
}

enum ActionType {
    case facebook
    case twitter
    case linkedIn
}

extension VerifySocialViewController: ShowBanner {
    func showBanner(bannerType: BannerType) {
        
    }
}
