//
//  TodoInMyActionsPopupViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 02/04/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class TodoOrderConfirmationPopupViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    var mutableString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTextColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        setupView()
        animateView()
    }
    
    func changeTextColor() {
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    
    private func animateView() {
        containerView.alpha = 0;
        self.containerView.frame.origin.y = self.containerView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.containerView.alpha = 1.0;
            self.containerView.frame.origin.y = self.containerView.frame.origin.y - 50
        })
    }
    
    @IBAction func navigateToHomeHub(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
        navigator.open("vnd.popmetrics://hubs/home")
    }
    
    @IBAction func navigateToTodoHub(_ sender: Any) {
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.popToRootViewController(animated: true)
        navigator.open("vnd.popmetrics://hubs/todo/sections/Paid Actions")
    }
}
