//
//  AimeeCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 09/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import markymark

class AimeeCell: UITableViewCell {
    
    lazy var roundView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PopmetricsColor.yellowBGColor
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCellViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpCellViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setUpCellViews() {
        
        self.addSubview(roundView)
        
        roundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        roundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        roundView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        roundView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        roundView.layer.cornerRadius = 8//roundView.frame.width / 2
        
    }
    
    func configureCell(instruction: String) {
        styleWithMark(marks: instruction)
    }
    
    private func styleWithMark(marks: String) {
        
        let markyMark = MarkyMark { (mark) in
            mark.setFlavor(ContentfulFlavor())
        }
        
        let markItems = markyMark.parseMarkDown(marks)
        let styling = DefaultStyling()
        let configuration = MarkDownToAttributedStringConverterConfiguration(styling : styling)
        let converter = MarkDownConverter(configuration:configuration)
        
        let label = UILabel()
        label.font = UIFont(name: FontBook.regular, size: 15)
        label.textColor = PopmetricsColor.darkGrey
        label.numberOfLines = 2
        label.attributedText = converter.convert(markItems)
        
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leftAnchor.constraint(equalTo: roundView.rightAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
}
