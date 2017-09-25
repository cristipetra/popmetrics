//
//  ButtonWithContainer.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 15/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ButtonWithContainer: UIButton {

    var parentView: IndividualTaskView!
    
    convenience init(view: IndividualTaskView) {
        self.init(frame: CGRect.zero)
        parentView = view
    }

}
