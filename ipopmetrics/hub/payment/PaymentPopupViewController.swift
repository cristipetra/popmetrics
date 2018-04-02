//
//  PaymentPopupViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 31/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

protocol PopupAlertViewDelegate: class {
    func goToHome()
}

class PaymentPopupViewController: UIViewController {

    var delegate: PopupAlertViewDelegate!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var secondLabel: UILabel!
    
    var mutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlerTap))
        self.view.addGestureRecognizer(tap)
        
        changeTextColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    func changeTextColor() {
        mutableString = NSMutableAttributedString(string: secondLabel.text!, attributes: [NSAttributedStringKey.font:UIFont(name: FontBook.regular, size: 18.0)!])
        mutableString.addAttribute(.foregroundColor, value: PopmetricsColor.blueURLColor, range: NSRange(location: 0, length: 4))
        secondLabel.attributedText = mutableString
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    
    private func animateView() {
        containerView.alpha = 0;
        self.containerView.frame.origin.y = self.containerView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.containerView.alpha = 1.0;
            self.containerView.frame.origin.y = self.containerView.frame.origin.y - 50
        })
    }
    
    @objc func handlerTap() {
        self.dismiss(animated: true, completion: nil)
    }
}
