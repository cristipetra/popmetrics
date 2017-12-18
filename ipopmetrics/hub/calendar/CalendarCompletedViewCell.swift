//
//  CalendarCompletedViewCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 18/12/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class CalendarCompletedViewCell: UITableViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var actionImage: UIImageView!
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var actionTime: UILabel!
    @IBOutlet weak var toolbarView: ToolbarViewCell!
    
    private var socialPost: CalendarSocialPost!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        self.toolbarView.backgroundColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(socialPost: CalendarSocialPost) {
        let formatedDate = self.formatDate((socialPost.scheduledDate)!)

        self.actionTime.text = "Completed on \(formatedDate)"
        
        if socialPost.text != "" {
            self.actionTitle.text = socialPost.text
        }
        
        if let imageUrl = socialPost.image {
            if imageUrl.isValidUrl() {
                self.actionImage.af_setImage(withURL: URL(string: imageUrl)!)
            }
        }
    }
    
    internal func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd @ h:mma"
        dateFormatter.amSymbol = "a.m."
        dateFormatter.pmSymbol = "p.m."
        
        return dateFormatter.string(from: date)
    }

}
