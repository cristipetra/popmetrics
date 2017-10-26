//
//  TodoPostDetailsView.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 26/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class TodoPostDetailsView: UIView {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var socialIconImageView: UIImageView!
    @IBOutlet weak var recommendedLabel: UILabel!
    @IBOutlet weak var logoImageVIew: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var socialIconContainerView: UIView!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    @IBOutlet weak var appIconBackground: UIView!
    @IBOutlet weak var postUrl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        loadNib()
        socialIconStyle()
        appIconStyle()
        
    }
    
    func configureView(socialPost: TodoSocialPost) {
        recommendedLabel.text = socialPost.articleText
        if let title = socialPost.articleTitle {
            titleLabel.text = title
        }
        postUrl.text = socialPost.articleUrl
        
        scheduleTimeLabel.text = formatDate(date: socialPost.updateDate)
        
    }
    
    func formatDate(date: Date) -> String {
        
        let dateFormater = DateFormatter()
        var days: String = ""
        var hour: String = ""
        var fullDate: String = ""
        
        dateFormater.dateFormat = "MM/dd"
        dateFormater.pmSymbol = "p.m"
        days = dateFormater.string(from: date)
        
        dateFormater.dateFormat = "h:mm a"
        dateFormater.amSymbol = "a.m"
        hour = dateFormater.string(from: date)
        
        
        fullDate = "\(days) @ \(hour)"
        return fullDate
        
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("TodoPostDetailsView", owner: self, options: nil)
        
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func appIconStyle() {
        
        appIconBackground.backgroundColor = UIColor.white
        appIconBackground.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        appIconBackground.layer.shadowOpacity = 0.8;
        appIconBackground.layer.shadowRadius = 2
        appIconBackground.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        appIconBackground.layer.cornerRadius = appIconBackground.frame.width / 2
        
    }
    
    private func socialIconStyle() {
        
        socialIconContainerView.layer.cornerRadius = socialIconContainerView.frame.width / 2
        socialIconContainerView.layer.masksToBounds = true
        socialIconContainerView.backgroundColor = UIColor.white
        
    }
    
    
}
