//
//  PaymentApi.swift
//  ipopmetrics
//
//  Created by Ervin on 19/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

class PaymentApi: BaseApi {
    func ephemeralKeys(_ brandId: String,
                       apiVersion: String,
                       completion: @escaping STPJSONResponseCompletionBlock) {
        let url = ApiUrls.composedBaseUrl(String(format:"/api/payment/brand/%@/ephemeral_keys", brandId))
        let params = ["api_version": apiVersion]
        
        Alamofire.request(url, method: .post, parameters: params,
                          encoding: JSONEncoding.default, headers:createHeaders())
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        
    }
    
    func subscribe(brandId: String,
                   planId: String,
                   source: String,
                   email: String,
                   callback: @escaping (_ title: String, _ message: String, _ success:Bool, _ done: Bool) -> Void){
        let url = ApiUrls.composedBaseUrl(String(format:"/api/payment/brand/%@/subscribe", brandId))

        let params: [String: Any] = [
            "plan_id": planId,
            "source": source,
            "email": email
        ]

        Alamofire.request(url, method: .post,
                          parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders())
            .validate(statusCode: 200..<300)
            .responseObject(){(response: DataResponse<ResponseWrapperEmpty>) in
                var title = "Error"
                var message = "An error has occured. Please try again later"
                var done = true
                var success = false
                
                if response.result.isSuccess, let resultCode = response.result.value?.code, let resultMessage = response.result.value?.message {
                    message = resultMessage
                    
                    if resultCode == "success" || resultCode == "already_subscribed"{
                        title = "Success"
                        success = true
                    } else if resultCode == "invalid_card" || resultCode == "invalid_email"{
                        done = false
                    }
                }
                
                callback(title, message, success, done)
                
        }
    }
    
}
