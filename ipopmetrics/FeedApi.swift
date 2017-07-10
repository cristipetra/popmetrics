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
    
    func getItems(_ brandId: String,
                  callback: @escaping (_ resultDict: [String: Any]?, _ error: ApiError?) -> Void) {
        
        let params = [
            "a": 0
        ]
        
        
        Alamofire.request(ApiUrls.getMyBrandFeedUrl(brandId), method: .get, parameters: params,
                          encoding: JSONEncoding.default, headers:createHeaders()).responseJSON { response in
            if let err = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, err)
                return
            }
            
            if let resultDict = response.result.value as? [String: Any] {
                callback(resultDict, nil)
            }
            
        }
    }
    
    
    func connectGoogleAnalytics(userId:String, brandId:String,  token:String, serverAuthCode: String,
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
        
        Alamofire.request(ApiUrls.getConnectGoogleAnalyticsUrl(brandId), method: .post, parameters: params, encoding: JSONEncoding.default,
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
    
    func connectTwitter(userId:String, brandId:String, token:String, tokenSecret: String,
                                callback: @escaping (_ resultDict: [String: Any]?, _ error: ApiError?) -> Void) {
        let params = [
            "user_id":userId,
            "access_token": token,
            "access_token_secret": tokenSecret
            ] as [String : Any]
        
        Alamofire.request(ApiUrls.getConnectTwitterUrl(brandId), method: .post, parameters: params, encoding: JSONEncoding.default,
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
