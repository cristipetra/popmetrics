//
//  TodoApi.swift
//  ipopmetrics
//
//  Created by Rares Pop on 05/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Alamofire

class TodoApi: BaseApi {
    
    func getItems(_ brandId: String,
                  callback: @escaping (_ response: TodoResponse?)  -> Void) {
        
        let url = ApiUrls.composedBaseUrl(String(format:"/api/todo/me/brand/%@", brandId))
        let params = ["a":0]
        
        Alamofire.request(url, method: .get, parameters: params,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<TodoResponse>>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                let handled = super.handleResponseWrap(response.value!)
                                if !handled {
                                    callback(response.result.value?.data)
                                }
                            }
        }
    }
    
    func postAction(_ todoCardId:String, params:[String:Any],
                callback: @escaping (_ response: ResponseWrapperEmpty?, _ error: ApiError?) -> Void) {
        
        Alamofire.request(ApiUrls.getTodoActionUrl(todoCardId),
                          method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperEmpty>) in
                            if let err = self.createErrorWithHttpResponse(response: response.response) {
                                callback(nil, err)
                                return
                            }
                            
                            if let result = response.result.value {
                                callback(result, nil)
                            }
                            
        }
    }
    
    func postRequiredAction(_ brandId:String, params:[String:Any],
                    callback: @escaping (_ response: RequiredActionResponse?)  -> Void) {
        
        // /api/actions/brand/<brand_id>/required-action
        
        let url = ApiUrls.composedBaseUrl(String(format:"/api/actions/brand/%@/required-action", brandId))
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<RequiredActionResponse>>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                let handled = super.handleResponseWrap(response.value!)
                                if !handled {
                                    callback(response.result.value?.data)
                                }
                            }
                            
        }
    }
    
    func approvePost(_ todoSocialPostId:String, callback: @escaping ()  -> Void) {
        let params = ["a":0]
        let url = ApiUrls.composedBaseUrl(String(format:"/api/todo/approve-social-post/%@", todoSocialPostId))
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperEmpty>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                let handled = super.handleResponseWrap(response.value!)
                                if !handled {
                                    callback()
                                }
                            }
        }
    }
    
    func denyPost(_ todoSocialPostId:String, callback: @escaping ()  -> Void) {
        let params = ["a":0]
        let url = ApiUrls.composedBaseUrl(String(format:"/api/todo/deny-social-post/%@", todoSocialPostId))
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperEmpty>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                let handled = super.handleResponseWrap(response.value!)
                                if !handled {
                                    callback()
                                }
                            }
        }
    }
    
    
    
}
