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
//        if let localUser = UsersStore.getInstance().getCredentials() {
            headers["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODI1NDI2NDUsImlhdCI6MTQ5NjE0MjY0NSwibmJmIjoxNDk2MTQyNjQ1LCJqdGkiOiIzYTJkY2ZkYS0yZGRjLTRiYjUtOWNhNi1mZTZlNTM1YjU2MzkiLCJpZGVudGl0eSI6IjU5MjgwOTZmYWExNDM5YzZmNGI1YzM2MSIsImZyZXNoIjpmYWxzZSwidHlwZSI6ImFjY2VzcyIsInVzZXJfY2xhaW1zIjp7fX0.3mutdjP-EbOdesuv3j4zLltpNrxs_5r183LW_dOJBiw"
                // + localUser.authToken!
//        }
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
