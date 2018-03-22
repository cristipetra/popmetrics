//
//  BrandApi.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 06/02/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//


import Foundation
import Alamofire

class BrandApi: BaseApi {
    
    func valideBrandWebsite(_ website: String,
                            callback: @escaping(_ response: ResponseCheckWebsite?) -> Void) {
        let url = ApiUrls.composedBaseUrl(String(format:"/api/brand/validate_brand_website"))
        let params = ["website": website]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<ResponseCheckWebsite>) in
            
            let levelOneHandled = super.handleNotOkCodes(response: response.response)
            
            if !levelOneHandled {
                callback(response.result.value)
            }
            
        }
    }
    
    func validateUserEmail(_ email: String,
                            callback: @escaping(_ response: ResponseCheckEmail?) -> Void) {
        let url = ApiUrls.composedBaseUrl(String(format:"/api/brand/validate_user_email"))
        let params = ["email": email]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseObject { (response: DataResponse<ResponseCheckEmail>) in
            
            let levelOneHandled = super.handleNotOkCodes(response: response.response)
            
            if !levelOneHandled {
                callback(response.result.value)
            }
            
        }
    }
 
}
