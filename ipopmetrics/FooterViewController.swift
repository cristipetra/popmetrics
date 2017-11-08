//
//  FooterViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class FooterViewController: UIViewController {

    var footerView: FooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = FooterView()
    }
    
    func configureCard(item: FeedCard, view: FooterView) {
        self.footerView = view
        
        view.displayOnlyActionButton()
        view.cardType = .required
        
        
        changetActionButton(item)
        
        addEventsTarget()
    }
    
    private func addEventsTarget() {
        footerView.xButton.addTarget(self, action: #selector(deleteHandler), for: .touchUpInside)
        footerView.actionButton.addTarget(self, action: #selector(approveHandler), for: .touchUpInside)
        footerView.informationBtn.addTarget(self, action: #selector(informationHandler(_:)), for: .touchUpInside)
    }
    
    private func changetActionButton(_ item: FeedCard) {
        
        print(item.actionHandler)
        switch item.actionHandler {
        case RequiredActionHandler.RequiredActionType.twitter.rawValue:
            self.footerView.actionButton.changeTitle("Connect Your Twitter")
        case RequiredActionHandler.RequiredActionType.googleAnalytics.rawValue:
            footerView.actionButton.changeTitle("Connect Google")
        case RequiredActionHandler.RequiredActionType.email.rawValue:
            footerView.actionButton.changeTitle("Connect Email")
        default:
            footerView.actionButton.changeTitle("Connect")
            break
        }
    }
    
    @objc func deleteHandler() {
        animateButtonBlink(button: footerView.xButton)
    }
    
    @objc func informationHandler(_ btn: UIButton) {
        animateButtonBlink(button: btn)
    }
    
    @objc func approveHandler() {
        
    }
    
    func animateButtonBlink(button: UIButton) {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            button.alpha = 0.0
        }) { (completion) in
            button.alpha = 1.0
        }
    }

}
