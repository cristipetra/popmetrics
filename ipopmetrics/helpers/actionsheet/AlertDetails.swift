//
//  AlertDetails.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 07/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import XLActionController

class AlertDetails {

    
    static func showActionSheetDetails(parent: UIViewController?, options: [String], action: @escaping ActionSheetResponse) {
        
        //let selectedAction: ActionSheetResponse? = action
        
        let actionController = DetailsActionController()
        
        for option in options {

            let action = Action(ActionData(title: option, subtitle: "Subtitle", image: #imageLiteral(resourceName: "logo")), style: .default, handler: { action in
                //let selectedIndex = options.index(of: action.title!)
                //selectedAction!(selectedIndex!)
            })    
            actionController.addAction(action)
        }
        
        actionController.headerData = "Choose a page to post to"
        parent?.present(actionController, animated: true, completion: nil)
        
    }

}
