//
//  Alert.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 16/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    static func showAlertDialog(parent: UIViewController?) {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let titleAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontBook.bold, size: 16), NSAttributedStringKey.foregroundColor: UIColor(red: 49/255, green: 63/255, blue: 72/255, alpha: 1)]
        
        let messageAttributes : [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont(name: FontBook.regular, size: 15), NSAttributedStringKey.foregroundColor: UIColor(red: 49/255, green: 63/255, blue: 72/255, alpha: 1)]
        
        let titleAttrString = NSMutableAttributedString(string: "There are unsaved changes.", attributes: titleAttributes)
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        
        let messageAttrString = NSMutableAttributedString(string: "Are you sure you would like to leave them?", attributes: messageAttributes)
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save Changes", style: .default) { (save) in
            //self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        parent?.present(alertController, animated: true, completion: nil)
        //UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    static func showActionSheet(parent: UIViewController?) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            
            print("First Action pressed")
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Choose From Library", style: .default) { action -> Void in
            
            print("Second Action pressed")
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        parent?.present(actionSheetController, animated: true, completion: nil)
    }
}
