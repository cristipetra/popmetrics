//
//  ConnectWizardErrorViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 28/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

class ConnectWizardErrorViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    var message: String?
    var instruction: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.messageLabel?.text = message
        self.instructionLabel?.text = instruction
    }
    

    func configure(message:String, instruction:String) {
        self.message = message
        self.instruction = instruction
    }

}
