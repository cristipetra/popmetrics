//
//  InfoCardViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 24/07/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit

class InfoCardViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleTooltip: UILabel!
    
    var typeCard: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.text = "Popmetrics needs access to your Twitter account to analyze your account so that we can paint a picture of how strong your online brand is, and how it stacks up against the competition. We can scan the people and businesses that folow your account, and then analyze who follows them. With this information we can better identify the same groups of people you and your competition are marketing towards. Popmetrics also identifies the types of content you and your followers share, like and generally engage with on Twitter. We use this engagement metric to determine the best content to post."
        updateView()
    }
    
    func changeCardType(type: String) {
        typeCard = type
    }
    
    func updateView() {
        switch typeCard {
        case "insight":
            titleTooltip.text = "What is a 'Popmetrics Insight'?"
            messageLabel.text = "Consider an insight card as a doorway of opportunity to improve your business. We constantly run tests on areas of your business and wherever we find one of these opportunities, we present the solution as one of these insight cards."
        default:
            break
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
