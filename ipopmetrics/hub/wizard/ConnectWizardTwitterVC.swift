//
//  ConnectWizardTwitterVC.swift
//  ipopmetrics
//
//  Created by Rares Pop on 27/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit

import FlexibleSteppedProgressBar
import EZAlertController
import GoogleSignIn
import Alamofire
import TwitterKit

class ConnectWizardTwitterVC: ConnectWizardBaseViewController {

    @IBOutlet weak var progressBar: FlexibleSteppedProgressBar!
    @IBOutlet weak var connectionTargetLabel: UILabel!
    @IBOutlet weak var connectionImageView: UIImageView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var currentStep = 0
    var steps: [String] = ["None"]
    var connectionTarget: String = ""
    var imageURL: String?
    var actionCard: FeedCard?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func authenticate() {
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { session, error in
            self.stepVerifyTwitter(session: session, error: error)
        }
    }
    
    func stepVerifyTwitter(session:TWTRSession?, error: Error?) {
        self.progressBar.currentIndex = 1
        if (session != nil) {
            // success
            
            let params = [
                "action_name": "twitter.connect_with_brand",
                "user_id":UserStore.getInstance().getLocalUserAccount().id,
                "twitter_user_id":session?.userID,
                "access_token":session?.authToken,
                "access_token_secret":session?.authTokenSecret
            ]
            let brandId = UserStore.currentBrandId
            let url = ApiUrls.composedBaseUrl(String(format:"/api/actions/brand/%@/required-action", brandId))
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,
                              headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<RequiredActionResponse>>) in
                                
                                let levelOneHandled = self.handleNotOkCodes(response: response.response)
                                if !levelOneHandled {
                                    let handled = self.handleResponseWrap(response.value!)
                                    if !handled {
                                        let store = FeedStore.getInstance()
                                        if let card = store.getFeedCardWithName("twitter.connect_with_brand") {
                                            store.updateCardSection(card, section: "None")
                                            self.stepDoneTwitter()
                                        }
                                    }
                                }
                                
            }
            
        } else {
            
            // failed
            EZAlertController.alert("Authentication Error", message: "Authentication has failed. Please try again.")
            return
        }
    }
    
    func stepDoneTwitter() {
        self.progressBar.currentIndex = self.steps.count-1
        self.mainButton.titleLabel?.text = "Done"
    }
    
    
}
