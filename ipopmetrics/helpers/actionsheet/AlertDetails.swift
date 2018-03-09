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

    
    static func showActionSheetDetails(parent: UIViewController?, options: [ActionData], action: @escaping ActionSheetResponse) {
        
        let selectedAction: ActionSheetResponse? = action
        
        let actionController = DetailsActionController()
        
        for option in options {
            let action = Action(ActionData(title: option.title!, subtitle: option.subtitle!), style: .default, handler: { action in
                let selectedIndex = options.index(where: {$0.title == action.data?.title && $0.subtitle == action.data?.subtitle})
                selectedAction!(selectedIndex!)
            })
            actionController.addAction(action)
        }
        let cancel: Action = Action(ActionData(title: "Cancel"), style: .cancel) { (action) in
        }
        actionController.addAction(cancel)
        
        actionController.headerData = "Choose a page to post to"
        parent?.present(actionController, animated: true, completion: nil)
        
    }

}
