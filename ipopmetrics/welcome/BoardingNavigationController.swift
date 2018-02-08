//
//  OnboardNavigationController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 05/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class BoardingNavigationController: UINavigationController {

    
    public var registerBrand: RegisterBrand = RegisterBrand()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}
