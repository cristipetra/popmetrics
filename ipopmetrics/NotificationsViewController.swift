//
//  NotificationsViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 21/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import SafariServices

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: RoundedCornersButton!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLabel.adjustLabelSpacing(spacing: 4, lineHeight: 15, letterSpacing: 0.4)
        secondLabel.adjustLabelSpacing(spacing: 4, lineHeight: 15, letterSpacing: 0.4)
        thirdLabel.adjustLabelSpacing(spacing: 4, lineHeight: 15, letterSpacing: 0.3)
        firstLabel.textAlignment = .center
        secondLabel.textAlignment = .center
        thirdLabel.textAlignment = .center
        confirmButton.backgroundColor = PopmetricsColor.blueURLColor
        confirmButton.setShadow()
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        //openURLInside(url: UIApplicationOpenSettingsURLString)
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationsViewController.applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        return
        
        let alert = UIAlertController(title: "", message: "Popmetrics is requesting to enable push notifications.", preferredStyle: UIAlertControllerStyle.alert)
        let backView = alert.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.white
        let message  = "Popmetrics is requesting to enable push notifications."
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSFontAttributeName:UIFont(name: "OpenSans", size: 15.0)!])
        messageMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1), range: NSRange(location:0,length:message.characters.count))
        alert.setValue(messageMutableString, forKey: "attributedMessage")
        let actionCancel = UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.default, handler: nil)
        actionCancel.setValue(UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(actionCancel)
        let actionConfirm = UIAlertAction(title: "Allow", style: UIAlertActionStyle.default, handler: nil)
        actionConfirm.setValue(UIColor(red: 65/255, green: 155/255, blue: 249/255, alpha: 1), forKey: "titleTextColor")
        alert.addAction(actionConfirm)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func applicationWillEnterForeground() {
        let finalOnboardingVC = OnboardingFinalView()
        self.present(finalOnboardingVC, animated: true, completion: nil)
    }
    
}

//MARK: Safari open
extension NotificationsViewController {
    private func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
