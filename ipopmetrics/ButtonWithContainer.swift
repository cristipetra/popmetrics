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
    var viewType: ParentView = .aimeeView
    
    convenience init(view: IndividualTaskView, type: ParentView) {
        self.init(frame: CGRect.zero)
        parentView = view
        viewType = type
    }

}

enum ParentView {
    case aimeeView
    case instructionView
}
