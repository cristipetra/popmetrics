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
                            callback: @escaping(_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
        let url = ApiUrls.composedBaseUrl(String(format:"/api/brand/validate_brand_website"))
        let params = ["website": website]
                            
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            
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

