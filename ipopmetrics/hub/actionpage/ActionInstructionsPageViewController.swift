//
//  ActionInstructionsPageViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 23/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class ActionInstructionsPageViewController: UIViewController {
    @IBOutlet weak var instructionsLabel: UILabel!
    
    private var feedCard: FeedCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationWithBackButton()
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    public func configure(_ feedCard: FeedCard) {
        self.feedCard = feedCard
        
    }
    
    private func updateView() {
        updateText()
    }
    
    private func updateText() {
        let instructions = feedCard.getDiyInstructions()
        var textString = ""
        for argument in instructions {
            textString += "\(argument) \n\n"
        }
        instructionsLabel.text = textString
    }
    
    private func setupNavigationWithBackButton() {
        let titleWindow = "Instructions"
        let titleButton = UIBarButtonItem(title: titleWindow, style: .plain, target: self, action: nil)
        titleButton.tintColor = PopmetricsColor.darkGrey
        let titleFont = UIFont(name: FontBook.extraBold, size: 18)
        titleButton.setTitleTextAttributes([NSAttributedStringKey.font: titleFont], for: .normal)
        
        let leftButtonItem = UIBarButtonItem.init(image: UIImage(named: "calendarIconLeftArrow"), style: .plain, target: self, action: #selector(handlerClickBack))
        self.navigationItem.leftBarButtonItems = [leftButtonItem, titleButton]
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    @objc func handlerClickBack() {
        self.navigationController?.popViewController(animated: true)
    }

}
