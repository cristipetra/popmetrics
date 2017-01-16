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
        if let localUser = UsersStore.getInstance().getCredentials() {
            headers["Authorization"] = "Bearer " + localUser.authToken!
        }
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
    
}
