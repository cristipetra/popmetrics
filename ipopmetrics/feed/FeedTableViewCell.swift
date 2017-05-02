//
//  FeedTableViewCell.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//


import UIKit
import MGSwipeTableCell

class FeedTableViewCell: MGSwipeTableCell {
    
    // Outlets
    @IBOutlet weak var propertyImageView: UIImageView!
    
    @IBOutlet weak var overlayView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var percentLabel: UILabel!
    
    var property: FeedItem! {
        didSet {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        // General setuo for UI
        propertyImageView.contentMode = .scaleAspectFill
        propertyImageView.layer.cornerRadius = 4
        propertyImageView.layer.masksToBounds = true
        
        overlayView.backgroundColor = PopmetricsColor.overlayBGColor
        overlayView.layer.cornerRadius = 4
        
        
        // Set the address lines
        titleLabel.text = property.title
        descriptionLabel.text = property.desc
        
        
        // Load the image
//        let store = PropertiesStore.getInstance()
        
//        if let curveAppeal = store.findElementsWithKey(property, key: PROPERTY_ELEMENT_KEY_CURB_APPEAL).first {
//            if let photoTag = store.getPhotoTags(curveAppeal).last {
//                
//                PropertyUtils.getPhotoTagImageAsync(photoTag: photoTag, withSize: .medium) { image, localImage in
//                    DispatchQueue.main.async {
//                        if image != nil {
//                            self.propertyImageView.image = image
//                        }
//                        else {
//                            self.propertyImageView.image = DEFAULT_IMAGE_PROPERTY
//                        }//else
//                    }//dispatch
//                }//getPhoto
//            } //
//            else { // no curbAppeal Photo
//                DispatchQueue.main.async {
//                    self.propertyImageView.image = DEFAULT_IMAGE_PROPERTY
//                }
//            }
//        } else { // no curbAppeal Element
//            DispatchQueue.main.async {
//                self.propertyImageView.image = DEFAULT_IMAGE_PROPERTY
//            }
//        }
        
    }
    

}
