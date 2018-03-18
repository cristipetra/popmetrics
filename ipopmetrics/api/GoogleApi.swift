//
//  GoogleApi.swift
//  ipopmetrics
//
//  Created by Rares Pop on 16/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import UIKit
import Alamofire
import GoogleSignIn
import ObjectMapper

class GoogleApi: BaseApi {
    
    override internal func createHeaders( authToken:String = "" ) -> HTTPHeaders {
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
    
    func connectGoogle(userId:String, brandId:String,  token:String, serverAuthCode: String,
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
    
    func getMyBusinessAccounts( authToken: String, callback: @escaping (_ response: MyBusinessAccountsResponse?) -> Void) {
        
        let url = "https://mybusiness.googleapis.com/v4/accounts"
        let params = ["a":0]
        
        Alamofire.request(url, method: .get, parameters: params,
                          headers:createHeaders()).responseObject() { (response: DataResponse<MyBusinessAccountsResponse>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                    let accounts = response.result.value
                                    callback(accounts)
                                }
                            }
    }
    
    func getMyBusinessAccount( authToken: String, callback: @escaping (_ response: MyBusinessAccountsResponse?) -> Void) {
        
        let url = "https://mybusiness.googleapis.com/v4/accounts"
        let params = ["a":0]
        
        Alamofire.request(url, method: .get, parameters: params,
                          headers:createHeaders()).responseObject() { (response: DataResponse<MyBusinessAccountsResponse>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                let accounts = response.result.value
                                callback(accounts)
                            }
        }
    }
    
    
    
}

class MyBusinessAcccount: Mappable {
    
    var accountName: String?
    var name: String?
    var type: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        name           <- map["name"]
        accountName    <- map["accountName"]
        type           <- map["type"]
    }
    
    
}

class MyBusinessAccountsResponse: Mappable {
    
    var accounts: [MyBusinessAcccount]?
    var nextPageToken: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        accounts           <- map["accounts"]
        nextPageToken      <- map["nextPageToken"]
    }
    
}
