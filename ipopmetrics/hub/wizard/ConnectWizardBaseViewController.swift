//
//  ConnectWizardBaseViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 27/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import Alamofire

class ConnectWizardBaseViewController: UIViewController {

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
    
    internal func addShadowToView(_ toView: UIView) {
        toView.layer.shadowColor = UIColor(red: 50/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0).cgColor
        toView.layer.shadowOpacity = 0.3;
        toView.layer.shadowRadius = 2
        toView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    internal func presentAlertWithTitle(_ title: String, message: String, useWhisper: Bool = false) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        DispatchQueue.main.async(execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    internal func createHeaders( authToken:String = "" ) -> HTTPHeaders {
        var headers = [String: String]()
        if authToken != "" {
            headers["Authorization"] = "Bearer "+authToken
        }
        else {
            let localUser = UserStore.getInstance().getLocalUserAccount()
            if localUser.authToken != nil { headers["Authorization"] = "Bearer "+localUser.authToken! }
        }
        return headers
    }
    
    internal func handleNotOkCodes(response: HTTPURLResponse?) -> Bool {
        if response?.statusCode == 404 {
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiResponseUnsuccessfull, object: nil,
                                            userInfo: ["title": "Cloud communication error.",
                                                       "subtitle":"The requested resource does not exist",
                                                       "type":"failure"])
            return true
        }
        if response?.statusCode == 401 {
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiClientNotAuthenticated, object: nil,
                                            userInfo: ["title": "Cloud communication error.",
                                                       "subtitle":"User is not authorized.",
                                                       "type":"failure"])
            return true
        }
        if response?.statusCode != 200 {
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiFailure, object: nil,
                                            userInfo: ["title": "Cloud communication error.",
                                                       "subtitle":"",
                                                       "type":"failure"])
            return true
        }
        return false
    }
    
    internal func handleResponseWrap(_ responseWrap: ResponseWrap) -> Bool{
        let value = responseWrap
        if value.getCode() != "success" && value.getCode() != "silent_error" {
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiResponseUnsuccessfull, object: nil,
                                            userInfo: ["title": "Cloud communication error.",
                                                       "subtitle":"Operation was unsuccessfull",
                                                       "type":"failure"])
            return true
        }
        return false
    }
    
}
