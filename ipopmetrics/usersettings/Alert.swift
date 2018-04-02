//
//  Alert.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit
import XLActionController

    typealias ActionSheetResponse = (Int) -> (Void)

class Alert {
   
    
    typealias Action = (AlertAction) -> (Void)
    typealias ActionSheet = (ActionSheetPhoto) -> (Void)
    typealias ActionSheetPaymentOpt = (ActionSheetPayment) -> (Void)
    
    static func showAlertDialog(parent: UIViewController?, action: Action?) {
        let actionSelected: Action? = action
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontBook.bold, size: 16), NSAttributedStringKey.foregroundColor: UIColor(red: 49/255, green: 63/255, blue: 72/255, alpha: 1)]
        
        let messageAttributes : [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontBook.regular, size: 15), NSAttributedStringKey.foregroundColor: UIColor(red: 49/255, green: 63/255, blue: 72/255, alpha: 1)]
        
        let titleAttrString = NSMutableAttributedString(string: "There are unsaved changes.", attributes: titleAttributes)
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        
        let messageAttrString = NSMutableAttributedString(string: "Are you sure you would like to cancel?", attributes: messageAttributes)
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){ (cancel) in
            actionSelected!(.cancel)
        }
        
        let saveAction = UIAlertAction(title: "Save Changes", style: .default) { (save) in
            actionSelected!(.save)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        parent?.present(alertController, animated: true, completion: nil)
        //UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    static func showActionSheet(parent: UIViewController?, action: @escaping ActionSheet) {
        let actionSelected: ActionSheet? = action
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            actionSelected!(.takePicture)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Choose From Library", style: .default) { action -> Void in
            actionSelected!(.openGallery)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSelected!(.cancel)
        }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        parent?.present(actionSheetController, animated: true, completion: nil)
    }
    
    static func showActionSheetOptions(parent: UIViewController?, options: [String], action: @escaping ActionSheetResponse) -> UIAlertController {
        let selectedAction: ActionSheetResponse? = action
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            let action = UIAlertAction(title: option, style: .default, handler: { (action) in
                let selectedIndex = options.index(of: action.title!)
                selectedAction!(selectedIndex!)
            })
            actionSheetController.addAction(action)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        
        actionSheetController.addAction(cancelAction)
        actionSheetController.title = "Choose a page to post to."
        
        parent?.present(actionSheetController, animated: true, completion: nil)
        
        return actionSheetController
    }
    
    static func showNotificationAlertDialog(parent: UIViewController?, action: Action?, message: String, title: String, okButton: Bool) {
        let actionSelected: Action? = action
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontBook.bold, size: 16)!, NSAttributedStringKey.foregroundColor: UIColor(red: 49/255, green: 63/255, blue: 72/255, alpha: 1)]
        
        let messageAttributes : [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontBook.regular, size: 15)!, NSAttributedStringKey.foregroundColor: UIColor(red: 49/255, green: 63/255, blue: 72/255, alpha: 1)]
        
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleAttributes)
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageAttributes)
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        if okButton {
            let cancelAction = UIAlertAction(title: "Cancel", style: .default){ (ok) in
                actionSelected!(.cancel)
            }
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (save) in
                actionSelected!(.save)
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
        } else {
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){ (cancel) in
                actionSelected!(.cancel)
            }
            
            let saveAction = UIAlertAction(title: "Save Changes", style: .default) { (save) in
                actionSelected!(.save)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
        }
        
        parent?.present(alertController, animated: true, completion: nil)
        //UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    static func showActionSheetPayment(parent: UIViewController?, action: @escaping ActionSheetPaymentOpt) {
        let actionSelected: ActionSheetPaymentOpt? = action
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Do it for me! $9.99", style: .default) { action -> Void in
            actionSelected!(.doItForMe)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Do It Myself", style: .default) { action -> Void in
            actionSelected!(.doItMyself)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSelected!(.cancel)
        }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        actionSheetController.title = "Choose an action."
        // present an actionSheet...
        parent?.present(actionSheetController, animated: true, completion: nil)
    }
}

enum AlertAction {
    case cancel
    case save
}

enum ActionSheetPhoto {
    case cancel
    case takePicture
    case openGallery
}

enum ActionSheetPayment {
    case cancel
    case doItForMe
    case doItMyself
}

