//
//  InfoCardView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 05/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class InfoCardView: UIView {

    var mutableString = NSMutableAttributedString()
    @IBOutlet weak var labelCard: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
    }
    
    internal func changeTextColor() {
        
        mutableString = NSMutableAttributedString(string: labelCard.text!, attributes: [NSAttributedStringKey.font:UIFont(name: FontBook.regular, size: 17.0)!])
        mutableString.addAttributes([.font: UIFont(name: "OpenSans-Bold", size: 18.0)!,], range: NSRange(location: 0, length: 4));
        labelCard.attributedText = mutableString
 
    }
    
    internal func changeCardNumber(cardNumber: String) {
        let lastNumbers = cardNumber.subString(startIndex: (cardNumber.count - 4), endIndex: (cardNumber.count - 1))
        
        labelCard.text = "\(labelCard.text!) \(lastNumbers)"
        
        changeTextColorCardAdded()
    }
    
    internal func changeTextColorCardAdded() {
        
        mutableString = NSMutableAttributedString(string: labelCard.text!, attributes: [NSAttributedStringKey.font:UIFont(name: FontBook.regular, size: 17.0)!])
        mutableString.addAttributes([.font: UIFont(name: "OpenSans-Bold", size: 18.0)!,], range: NSRange(location: 0, length: 4));
        mutableString.addAttributes([.font: UIFont(name: "OpenSans-Bold", size: 18.0)!,], range: NSRange(location: (labelCard.text?.count)! - 4, length: 4));
        labelCard.attributedText = mutableString
        
    }
    

}
