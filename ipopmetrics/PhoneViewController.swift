//
//  PhoneViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 18/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class PhoneViewController: UIViewController {
    
    var phoneView: PhoneView = PhoneView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    override func viewDidLoad() {
        super.viewDidLoad()

        addPhoneView();
    }
    
    func addPhoneView() {
        self.view.addSubview(phoneView);
    }
}

// MARK: - UITextFieldDelegate

extension PhoneViewController: UITextFieldDelegate {
    
}
