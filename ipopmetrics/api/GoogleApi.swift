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
    
    var locations = [MyBusinessLocation]()
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        name           <- map["name"]
        accountName    <- map["accountName"]
        type           <- map["type"]
    }
    
    func describe() -> String {
        var description = "No locations defined"
        if locations.count == 0 {
            return description
        }
        var hq = 0
        var primaryLocation = locations[0]
        for location in locations {
            if location.primaryCategory?.categoryId == "gcid:corporate_office" {
                primaryLocation = location
                break
            }
        }
        description = primaryLocation.locationName ?? "Undefined name"
        if locations.count > 1 {
            description = String(format:"%@ with %d locations", description, locations.count)
        }
        return description
        
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

class MyBusinessLocationsResponse: Mappable {
    
    var locations: [MyBusinessLocation]?
    var nextPageToken: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        locations           <- map["locations"]
        nextPageToken      <- map["nextPageToken"]
    }
    
}

class MyBusinessLocationAddress: Mappable {
    
    var addressLines: [String]?
    var languageCode: String?
    var locality: String?
    var regionCode: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        addressLines       <- map["addressLines"]
        languageCode       <- map["languageCode"]
        locality           <- map["locality"]
        regionCode         <- map["regionCode"]
    }
    
}

class MyBusinessLocationCategory: Mappable {
    
    var categoryId: String?
    var displayName: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        categoryId           <- map["categoryId"]
        displayName          <- map["displayName"]
    }
    
}


class MyBusinessLocation: Mappable {
    
    var address: MyBusinessLocationAddress?
    var languageCode: String?
    var locationName: String?
    var primaryCategory: MyBusinessLocationCategory?
    var primaryPhone: String?
    var websiteUrl: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map:Map) {
        address            <- map["address"]
        languageCode       <- map["languageCode"]
        locationName       <- map["locationName"]
        primaryPhone       <- map["primaryPhone"]
        primaryCategory    <- map["primaryCategory"]
        websiteUrl         <- map["websiteUrl"]
    }

}
