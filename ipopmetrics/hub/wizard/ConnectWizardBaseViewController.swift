//
//  ConnectWizardBaseViewController.swift
//  ipopmetrics
//
//  Created by Rares Pop on 27/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import Alamofire

class ConnectWizardBaseViewController: BaseViewController {

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
    
    func add(asChildViewController viewController: UIViewController) {
        print("Override me!")
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
    
    func showError(_ message:String, instruction: String) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ConnectWizardErrorViewController") as! ConnectWizardErrorViewController
        vc.configure(message:message, instruction:instruction)
        self.add(asChildViewController: vc)
    }
    
    func showOk(_ message:String, instruction: String) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ConnectWizardOkViewController") as! ConnectWizardOkViewController
        vc.configure(message:message, instruction:instruction)
        self.add(asChildViewController: vc)
    }
    
    internal func handleNotOkCodes(response: HTTPURLResponse?) -> Bool {
        if response?.statusCode == 404 {
            self.showError("There was an error connecting your account with Popmetrics",
                           instruction:"Please try again.")
            return true
        }
        if response?.statusCode == 401 {
            self.showError("There was an error connecting your account with Popmetrics",
                           instruction:"Please try again.")
            return true
        }
        if response?.statusCode != 200 {
            self.showError("There was an error connecting your account with Popmetrics",
                           instruction:"Please try again.")
            return true
        }
        return false
    }
    
    internal func handleResponseWrap(_ responseWrap: ResponseWrap) -> Bool{
        let value = responseWrap
        if value.getCode() != "success" && value.getCode() != "silent_error" {
            self.showError("There was an error connecting your account with Popmetrics",
                           instruction:"Please try again.")
            return true
        }
        return false
    }
    
}
