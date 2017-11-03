//
//  TableViewCellTransition.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 03/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TableViewCellTransition: NSObject {
    
    func animateDisplayLoadindCell(_ indexPath: IndexPath, cell: UITableViewCell, completion: @escaping() -> () ) {
        let delay = 0.1 + Double(indexPath.row) * 0.2
        
        if indexPath.section == 0 {
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -148, 10)
            cell.layer.transform = transform
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: delay, options: .beginFromCurrentState, animations: {
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            }, completion: { (completed) in
                completion()
            })
        }
    }
    
    func animateDisplayLoadindFirstTimeCell(_ indexPath: IndexPath, cell: UITableViewCell) {
        let delay = 0.1 + Double(indexPath.row) * 0.2
        
        if indexPath.section == 0 {
            let transform = CATransform3DTranslate(CATransform3DIdentity, 0, -148, 10)
            cell.layer.transform = transform
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.3, delay: delay, options: .beginFromCurrentState, animations: {
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            }, completion: { (completed) in
                UsersStore.didShowedTransitionFromTodo = true
            })
        }
    }

}
