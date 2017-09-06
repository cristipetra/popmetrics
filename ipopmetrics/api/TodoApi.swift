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
                  callback: @escaping (_ response: ResponseWrapperOne<TodoResponse>?, _ error: ApiError?) -> Void) {
        
        let params = [
            "a": 0
        ]
        
        Alamofire.request(ApiUrls.getMyBrandTodoUrl(brandId), method: .get, parameters: params,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<TodoResponse>>) in
                            
                            if let err = self.createErrorWithHttpResponse(response: response.response) {
                                callback(nil, err)
                                return
                            }
                            else {
                                callback(response.result.value, nil)
                            }
                            
        }
    }
    
    func postAction(todoCardId:String, params:[String:Any],
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
    
    
}
