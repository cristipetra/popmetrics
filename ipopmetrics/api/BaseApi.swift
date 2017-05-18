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
            headers["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1ODE0MzEzNjcsImlhdCI6MTQ5NTAzMTM2NywibmJmIjoxNDk1MDMxMzY3LCJqdGkiOiI1NDIwYTkyMC00YTJmLTQ0MTAtYjZiMC1iZTBlNGYzZTBiMWUiLCJpZGVudGl0eSI6IjU5MWM0MGM4YWExNDM5YzZmNGI1NTdjZiIsImZyZXNoIjpmYWxzZSwidHlwZSI6ImFjY2VzcyIsInVzZXJfY2xhaW1zIjp7fX0.l-12LFxgeE2dkqh0EinKAL8FYfFkFaNYgPLdAh5dIFE"
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
