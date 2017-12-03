//
//  BaseApi.swift
//  Popmetrics
//
//  Created by Rares Pop
//  Copyright © 2016 Popmetrics. All rights reserved.
//

import UIKit
import Alamofire

enum ApiError {
    // Generic
    case apiNotAvailable
    case internalStateError
    case resourceDoesNotExist
    
    // User related
    case userMismatch
    case userAlreadyExists
    case userNotAuthenticated
}

class BaseApi {
    
    internal func createHeaders() -> HTTPHeaders {
        var headers = [String: String]()
        let localUser = UserStore.getInstance().getLocalUserAccount()
        if localUser.authToken != nil { headers["Authorization"] = "Bearer "+localUser.authToken! }
        return headers
    }
    
    internal func createErrorWithHttpResponse(response: HTTPURLResponse?) -> ApiError? {
        // TODO Implement properly
        if response?.statusCode == 404 {
            return ApiError.resourceDoesNotExist
        }
        
        if response?.statusCode == 401 {
            return ApiError.userNotAuthenticated
        }
        
        if response?.statusCode != 200 {
            return ApiError.apiNotAvailable
        }
        
        return nil
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
