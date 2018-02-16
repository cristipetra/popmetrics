//
//  NotificationsManuallyEnableViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 02/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class NotificationsManuallyEnableViewController: UIViewController {
    @IBOutlet weak var textManually: UILabel!
    
    @IBOutlet weak var maybeLaterBtn: UIButton!
    @IBOutlet weak var goToSettingsBtn: UIButton!
    private var linkArticle: String = "http://blog.popmetrics.io/how-to-turn-on-push-notifications/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        
        setNavigationBar()
        
        updateView()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(tap:)))
        textManually.addGestureRecognizer(tapGesture)
        textManually.isUserInteractionEnabled = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        goToSettingsBtn.setTitleColor(PopmetricsColor.borderButton, for: .normal)
        maybeLaterBtn.setTitleColor(PopmetricsColor.secondGray, for: .normal)
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
    
    private func updateView() {
        let attributedString = NSMutableAttributedString(string: "Manually Enable Push Notifications\n\nApple only allows us one time to do it for you :( \nThe fate of notifications rests in your hands.\n\nFind out how to turn them on here, or...")
        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Bold", size: 15.0)!,
            .foregroundColor: UIColor(red: 67.0 / 255.0, green: 76.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: 34))
        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans", size: 15.0)!,
            .foregroundColor: UIColor(red: 67.0 / 255.0, green: 76.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 35, length: 100))
        attributedString.addAttributes([
            .font: UIFont(name: "OpenSans-Bold", size: 15.0)!,
            .foregroundColor: UIColor(red: 65.0 / 255.0, green: 155.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 164, length: 4))
        
        self.textManually.attributedText = attributedString
     
    }
    
    @objc func handleTapOnLabel(tap:UITapGestureRecognizer) {
        let tmpNsRange = NSRange(location: 168, length: 14)

        if tap.didTapAttributedTextInLabel(label: self.textManually, inRange: tmpNsRange) {
            openLink()
        }
    }
    
    private func openLink() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if linkArticle.isValidUrl() {
            appDelegate.openURLInside(self, url: linkArticle)
        }
    }
    
    private func openSettingsApp() {
        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
    }

    @IBAction func handlerGoToSettings(_ sender: UIButton) {
        openSettingsApp()
    }
    
    @IBAction func handlerMaybeLatter(_ sender: UIButton) {
        openNextView()
    }
    
    func openNextView() {
        let finalOnboardingVC = OnboardingFinalView()
        self.present(finalOnboardingVC, animated: true, completion: nil)
    }
    
    
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}
