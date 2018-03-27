//
//  ConnectWizardFacebookVC.swift
//  ipopmetrics
//
//  Created by Rares Pop on 27/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import EZAlertController
import Alamofire
import FacebookCore
import FacebookLogin

class ConnectWizardFacebookVC: ConnectWizardBaseViewController {
    
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
        
        self.connectionTarget = "Facebook Page"
        let loginManager = LoginManager()
        let readPermissions = [ReadPermission.publicProfile, ReadPermission.email, ReadPermission.pagesShowList]
        loginManager.logIn(readPermissions:readPermissions, viewController: self) { result in
             switch result {
             case LoginResult.failed(let error):
                // Show fail read permissions message
                self.presentAlertWithTitle("Failure", message:"Failed to connect with Facebook.")
             case LoginResult.cancelled:
                //Show declined read permissions message
                self.presentAlertWithTitle("Failure", message: "You need to grant all the requested permissions to continue.")
             case LoginResult.success(let grantedPermissions, let declinedPermissions, let accessToken):
                // check if all requested permissions were granted
                if !declinedPermissions.isEmpty {
                    //Show declined read permissions message
                    self.presentAlertWithTitle("Failure", message: "You need to grant all the requested permissions to continue.")
                    return
                }
                self.stepApproveFacebook(loginManager:loginManager)
                break
            }
        }
    }

    
    
    
    func stepApproveFacebook(loginManager: LoginManager) {
//        self.progressBar.currentIndex = 1
//
//
//        let connection = GraphRequestConnection()
//        connection.add(GraphRequest(graphPath: "/me/accounts", parameters: ["fields": "id, name, perms, username, picture"])) { httpResponse, result in
//            switch result {
//            case .failed( _):
//                // Show fail gettting pages
//                self.presentAlertWithTitle("Failure", message: "Failed to get your Facebook Pages.")
//            case .success(let response):
//                guard let facebookAccounts = self.parseFacebookAccounts(response.dictionaryValue), facebookAccounts.count > 0 else{
//                    // Show no pages message
//                    self.presentAlertWithTitle("Failure", message: "You don't have any Facebook Pages.")
//                    return
//                }
//                self.stepPickFacebook(facebookAccounts, loginManager: loginManager)
//
//            }//switch
//
//
//
//        }//connection.add
//        connection.start()
        
    }//step
    
    func stepPickFacebook(_ facebookAccounts:[FacebookAccount], loginManager:LoginManager) {
//        let pickFacebookPageController = FacebookPagePickerViewController(facebookPages: facebookAccounts){
//            selectedFacebookAccount in
//            guard let selectedFacebookAccount = selectedFacebookAccount else {
//                self.presentAlertWithTitle("Message", message: "Please select a Facebook Page.")
//                return
//            }
//            
//            if !selectedFacebookAccount.canCreateContent {
//                self.presentAlertWithTitle("Message", message: "You must be an Administrator or an Editor to post content as this Page.")
//                return
//            }
//            let publishPermissions = [PublishPermission.managePages, PublishPermission.publishPages]
//            loginManager.logIn(publishPermissions:publishPermissions, viewController: self) { result in
//                switch result {
//                case LoginResult.failed( _):
//                    // Show fail request publish permissions
//                    self.presentAlertWithTitle("Failure", message: "Failed to connect with Facebook.")
//                    
//                case LoginResult.cancelled:
//                    //Show declined publish permissions message
//                    self.presentAlertWithTitle("Failure", message: "You need to grant all the requested permissions to continue.")
//                    
//                case LoginResult.success( _, let declinedPermissions, let accessToken):
//                    if !declinedPermissions.isEmpty {
//                        //Show declined publish permissions message
//                        self.presentAlertWithTitle("Failure", message: "You need to grant all the requested permissions to continue.")
//                        return
//                    }
//                    
//                    /*
//                     UserStore.currentBrand?.facebookDetails?.accessToken = accessToken.authenticationToken
//                     UserStore.currentBrand?.facebookDetails?.selectedAccountId = facebookAccounts[itemSelected].id!
//                     */
//                    self.stepVerifyFacebook(accessToken: accessToken.authenticationToken,
//                                            facebookPageId: selectedFacebookAccount.id)
//                    
//                }//switch
//            }//logIn
//            
//        }///controller
//        pickFacebookPageController.modalPresentationStyle =  UIModalPresentationStyle.pageSheet
//        pickFacebookPageController.modalTransitionStyle =  UIModalTransitionStyle.coverVertical
        
    }//stepPickFacebook
    
    func stepVerifyFacebook(accessToken: String, facebookPageId: String){
        
        self.progressBar.currentIndex = self.steps.count-2
        let params = [
            "task_name": "facebook.connect_with_brand",
            "access_token": accessToken,
            "facebook_page_id": facebookPageId
            
        ]
        let brandId = UserStore.currentBrandId
        TodoApi().postRequiredAction(brandId, params: params) { requiredActionResponse in
            NotificationCenter.default.post(name:Notification.Popmetrics.RequiredActionComplete, object:nil,
                                            userInfo: nil )
            let store = FeedStore.getInstance()
            if let card = store.getFeedCardWithName("facebook.connect_with_brand") {
                store.updateCardSection(card, section: "None")
                NotificationCenter.default.post(name:Notification.Popmetrics.UiRefreshRequired, object:nil,
                                                userInfo: nil )
            }
        }
    }
    
    func parseFacebookAccounts(_ responseDict: [String: Any]?) -> [FacebookAccount]? {
        guard let accounts = responseDict?["data"] as? NSArray, accounts.count > 0 else {
            return nil
        }
        
        var facebookAccounts: [FacebookAccount] = []
        
        for account in accounts {
            guard let accountData = account as? [String: Any],
                let id = accountData["id"] as? String,
                let name = accountData["name"] as? String,
                let perms = accountData["perms"] as? [String] else {
                    continue
            }
            
            var fbAccount = FacebookAccount(id: id, name: name, perms:perms)
            
            if let link = accountData["link"] as? String {
                fbAccount.link = link
            }
            
            if let picture = accountData["picture"] as? [String: Any],
                let pictureData = picture["data"] as? [String: Any],
                let pictureUrl = pictureData["url"] as? String {
                
                fbAccount.picture = pictureUrl
            }
            
            facebookAccounts.append(fbAccount)
            
        }
        
        return facebookAccounts
    }
    
}
