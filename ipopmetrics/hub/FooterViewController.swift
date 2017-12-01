//
//  FooterViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

protocol ButtonHandler {
    func handler()
}

class FooterViewController: UIViewController {

    var footerView: FooterView!
    var feedCard: FeedCard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = FooterView()
    }
    
    func configureCard(item: FeedCard, view: FooterView) {
        self.footerView = view
        self.feedCard  = item
        view.feedCard = item
        //view.displayOnlyActionButton()
        view.cardType = .required
        
        changetActionButton(item)
        changeDisplayInfoButton(item)
        
        addEventsTarget()
    }
    
    private func addEventsTarget() {
        footerView.xButton.addTarget(self, action: #selector(informationHandler), for: .touchUpInside)
        footerView.actionButton.addTarget(self, action: #selector(approveHandler), for: .touchUpInside)
        footerView.informationBtn.addTarget(self, action: #selector(informationHandler(_:)), for: .touchUpInside)
    }
    
    private func changeDisplayInfoButton(_ item: FeedCard) {
        if Bool(item.tooltipEnabled) {
            footerView.changeVisibilityInformationButton(isVisible: Bool(item.tooltipEnabled))
        }
    }

    
    private func changetActionButton(_ item: FeedCard) {
        
        self.footerView.actionButton.changeTitle(item.actionLabel)
    }
    
    @objc func deleteHandler() {
        animateButtonBlink(button: footerView.xButton)
    }
    
    @objc func informationHandler(_ btn: UIButton) {
        print("information handler")
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

extension Bool {
    init<T: BinaryInteger>(_ num: T) {
        self.init(num != 0)
    }
}
