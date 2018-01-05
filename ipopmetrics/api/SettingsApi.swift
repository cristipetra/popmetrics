//
//  SettingsApi.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 04/01/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import Foundation
import Alamofire

class SettingsApi: BaseApi {
    
    func changeOverlayDescription(description: String, callback: @escaping (_ error: ApiError?) -> Void) {
        let url = ""
        let params = ["description": description]
        
        Alamofire.request(url,
                          method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseJSON { response in
                            if let err = self.createErrorWithHttpResponse(response: response.response) {
                                callback(err)
                                return
                            }
                            callback(nil)
        }
    }
    
    func changeOverlayURL(url: String, callback: @escaping (_ error: ApiError?) -> Void) {
        let url = ""
        let params = ["url": url]
        
        Alamofire.request(url,
                          method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseJSON { response in
                            if let err = self.createErrorWithHttpResponse(response: response.response) {
                                callback(err)
                                return
                            }
                            callback(nil)
        }
    }
    
    func changeOverlayAction(action: String, callback: @escaping (_ error: ApiError?) -> Void) {
        let url = ""
        let params = ["action": action]
        
        Alamofire.request(url,
                          method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseJSON { response in
                            if let err = self.createErrorWithHttpResponse(response: response.response) {
                                callback(err)
                                return
                            }
                            callback(nil)
        }
    }
    
}
