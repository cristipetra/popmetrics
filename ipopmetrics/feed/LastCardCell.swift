//
//  LastCardCell.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 14/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class LastCardCell: UITableViewCell {
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var imageTitle: UIImageView!
    @IBOutlet weak var xbutton: UIButton!
    @IBOutlet weak var goToButton: TwoImagesButton!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    internal var shadowView: UIView!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.feedBackgroundColor()
        self.goToButton.backgroundColor = PopmetricsColor.yellowBGColor
        setCornerRadiou()
        setShadows(view: goToButton)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCornerRadiou() {
        secondContainerView.layer.cornerRadius = 14
        secondContainerView.layer.masksToBounds = true
        self.goToButton.layer.borderWidth = 2.0
        self.goToButton.layer.borderColor = UIColor.black.cgColor
        self.goToButton.layer.cornerRadius = self.goToButton.frame.height / 2
    }
    
    private func setShadows(view: AnyObject) {
        view.layer.shadowColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.22).cgColor
        view.layer.shadowOpacity = 1.0;
        view.layer.shadowRadius = 2.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    @IBAction func closeCard(_ sender: UIButton) {
        //        self.isHidden = true
        //        shouldBeDisplayed = false
        print("x fired")
    }
    @IBAction func goToButtonPressed(_ sender: UIButton) {
        print("goTo fired")
    }
}
