//
//  FeedTableActionRequiredViewCell.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class FeedTableActionRequiredTableViewCell: UITableViewCell {
    
    @IBOutlet weak var completionLabel: UILabel!
    
    @IBOutlet weak var completionView: CompletionView!
    
    @IBOutlet weak var separatorView: UIView!
    
    var completion: (completed: Int, total: Int)! {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        let (completed, total) = completion
//        completionView.setCompletion(completed, total: total)
//        completionLabel.text = String(format: "%d of %d ideal home questions answered", completed, total)
//        separatorView.backgroundColor = PopmetricsColor.borderMedium
    }
}
