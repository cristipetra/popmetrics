//
//  ConnectWizardGoogleMyBusinessAuthenticatedVC.swift
//  ipopmetrics
//
//  Created by Rares Pop on 23/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import GoogleSignIn
import Alamofire
class ConnectWizardGoogleMyBusinessAccountConfirmationVC: UIViewController {

    @IBOutlet weak var authenticatedUserLabel: UILabel!
    @IBOutlet weak var myBusinessLabel: UILabel!
    @IBOutlet weak var accountImageView: UIImageView!
    
    var account:MyBusinessAcccount?
    var signedUser:GIDGoogleUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.accountImageView.af_setImage(withURL: (signedUser?.profile.imageURL(withDimension: 100))!)
        self.authenticatedUserLabel?.text = signedUser?.profile.name
        self.myBusinessLabel?.text = account?.describe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configure(account:MyBusinessAcccount, signedUser:GIDGoogleUser) {
        self.account = account
        self.signedUser = signedUser
    }
    

}
