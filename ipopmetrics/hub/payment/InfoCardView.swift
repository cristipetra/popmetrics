//
//  InfoCardView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 05/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class InfoCardView: UIView {

    @IBOutlet weak var labelCard: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal func changeLabel(label: String) {
        labelCard.text = label
        labelCard.attributedText = getAttributedText(label:label)
        
    }
    
    internal func resetLabel(label: String){
        labelCard.text = label
        labelCard.attributedText = NSMutableAttributedString(string: label, attributes: [NSAttributedStringKey.font:UIFont(name: FontBook.regular, size: 17.0)!])
        
    }
    
    internal func getAttributedText(label: String) -> NSMutableAttributedString {
        var attributedText = NSMutableAttributedString(string: labelCard.text!, attributes: [NSAttributedStringKey.font:UIFont(name: FontBook.regular, size: 17.0)!])
        attributedText.addAttributes([.font: UIFont(name: "OpenSans-Bold", size: 18.0)!,], range: NSRange(location: 0, length: label.count - 4));
        
        return attributedText
    }
    

}
