//
//  HeaderCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 12/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class HeaderCardCell: UITableViewCell {
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var roundConnectionView: UIView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLeftAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var roundCircleLeftAnchor: NSLayoutConstraint!
    lazy var toastView: ToastView = {
        let toast = ToastView()
        toast.translatesAutoresizingMaskIntoConstraints = false
        return toast
    }()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.cloudsColor()
        containerView.backgroundColor = UIColor.cloudsColor()
        roundConnectionView.layer.cornerRadius = 6
        
        //roundCircleLeftAnchor.constant = 0
        //titleLeftAnchor.constant = 0
        
        
        connectionView.backgroundColor = PopmetricsColor.salmondColor
        roundConnectionView.backgroundColor = PopmetricsColor.salmondColor
        connectionView.isHidden = true
        roundConnectionView.isHidden = true
        sectionTitleLabel.font =  UIFont(name: FontBook.extraBold, size: 18)
        sectionTitleLabel.textColor = PopmetricsColor.weekDaysGrey
        titleLeftAnchor.constant = 0
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func changeColor(section: Int) {
        switch section {
        case 0:
            connectionView.backgroundColor = PopmetricsColor.darkGrey
            roundConnectionView.backgroundColor = PopmetricsColor.darkGrey
            //connectionView.backgroundColor = UIColor.carrotColor()
            //roundConnectionView.backgroundColor = UIColor.carrotColor()
            break
        case 1:
            connectionView.backgroundColor = UIColor.turquoiseColor()
            roundConnectionView.backgroundColor = UIColor.turquoiseColor()
            break
        case 4:
            let yellowColor = UIColor(red: 255/255.0, green: 189/255.0, blue: 80/255.0, alpha: 1.0)
            connectionView.backgroundColor = yellowColor
            roundConnectionView.backgroundColor = yellowColor
            break
        case 5:
            connectionView.backgroundColor = UIColor.turquoiseColor()
            roundConnectionView.backgroundColor = UIColor.turquoiseColor()
            break
        default:
            
            break
        }
    }
    
    func changeColor(cardType :CardType) {
        switch cardType {
        case .todo:
            connectionView.backgroundColor = PopmetricsColor.yellowUnapproved
            roundConnectionView.backgroundColor = PopmetricsColor.yellowUnapproved
        case .recommended:
            connectionView.backgroundColor = PopmetricsColor.darkGrey
            roundConnectionView.backgroundColor = PopmetricsColor.darkGrey
        case .required:
            connectionView.backgroundColor = PopmetricsColor.salmondColor
            roundConnectionView.backgroundColor = PopmetricsColor.salmondColor
            connectionView.isHidden = true
            roundConnectionView.isHidden = true
            sectionTitleLabel.font =  UIFont(name: FontBook.extraBold, size: 18)
            sectionTitleLabel.textColor = PopmetricsColor.weekDaysGrey
            titleLeftAnchor.constant = 0
        case .traffic:
            connectionView.backgroundColor = PopmetricsColor.trafficHeaderColor
            roundConnectionView.backgroundColor = PopmetricsColor.trafficHeaderColor
        case .insight:
            connectionView.backgroundColor = PopmetricsColor.darkGrey
            roundConnectionView.backgroundColor = PopmetricsColor.darkGrey
        case .scheduled:
            connectionView.backgroundColor = PopmetricsColor.blueURLColor
            roundConnectionView.backgroundColor = PopmetricsColor.blueURLColor
        default:
            break
        }
    }
    
    func changeColor(color: UIColor) {
        connectionView.backgroundColor = color
        roundConnectionView.backgroundColor = color
        //containerView.backgroundColor = color
        //toolbarView.backgroundColor = color
        //toolbarView.changeColorCircle(color: color)
        //roundConnectionView.backgroundColor = color
        //connectionView.backgroundColor = color
    }
    
    func changeTitle(title: String) {
        sectionTitleLabel.text = title
    }
    
    func displayToastView() {
        if !toastView.isDescendant(of: self.containerView) {
            self.containerView.addSubview(toastView)
        }
        
        toastView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        toastView.widthAnchor.constraint(equalToConstant: 72).isActive = true
        toastView.heightAnchor.constraint(equalToConstant: 31).isActive = true
        toastView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
