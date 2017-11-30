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
                                            userInfo: ["title":"Communication error", "message": "The requested resource does not exist."])
            return true
        }
        if response?.statusCode == 401 {
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiClientNotAuthenticated, object: nil,
                                            userInfo: ["title":"Communication error", "message": "Authentication is required."])
            return true
        }
        if response?.statusCode != 200 {
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiFailure, object: nil,
                                            userInfo: ["title":"Communication error", "message": "Communication with the cloud failed."])
            return true
        }
        return false
    }
    
    internal func handleResponseWrap(_ responseWrap: ResponseWrap) -> Bool{
        let value = responseWrap
        if value.getCode() != "success" && value.getCode() != "silent_error" {
                NotificationCenter.default.post(name: Notification.Popmetrics.ApiResponseUnsuccessfull, object: nil,
                                                userInfo: ["title":"Api error",
                                                           "message":value.getMessage() ?? "The request was completed unsuccessfully by the Cloud"])
                return true
                }
        return false
    }
    
}
