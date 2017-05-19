//
//  FeedApi.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn

class FeedApi: BaseApi {
    
    func getItems(sinceDate: Date,
                       callback: @escaping (_ resultDict: [String: Any]?, _ error: ApiError?) -> Void) {
        let params = [
            "sinceDate": 0
        ]
        
        
        Alamofire.request(ApiUrls.getUserFeedUrl(), method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if let err = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, err)
                return
            }
            
            if let resultDict = response.result.value as? [String: Any] {
                callback(resultDict, nil)
            }
            
        }
    }
    
    
    func connectGoogleAnalytics(userId:String, token:String, serverAuthCode: String,
                                authentication:GIDAuthentication,
                                callback: @escaping (_ resultDict: [String: Any]?, _ error: ApiError?) -> Void) {
        let params = [
            "user_id":userId,
            "client_id":GIDSignIn.sharedInstance().clientID,
            "token":token,
            "access_token": authentication.accessToken,
            "refresh_token": authentication.refreshToken,
            "server_auth_code": serverAuthCode,
            "scopes": GIDSignIn.sharedInstance().scopes
        ] as [String : Any]
        
        Alamofire.request(ApiUrls.getConnectGoogleAnalyticsUrl(), method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseJSON { response in
            if let err = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, err)
                return
            }
            
            if let resultDict = response.result.value as? [String: Any] {
                callback(resultDict, nil)
            }
            
        }
    }
    
   
    
}
