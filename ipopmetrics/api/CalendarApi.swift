//
//  CalendarApi.swift
//  ipopmetrics
//
//  Created by Rares Pop on 08/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Alamofire

class CalendarApi: BaseApi {
    
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
    
    func cancelPost(_ calendarSocialPostId:String,
                     callback: @escaping ()  -> Void) {
        let params = ["a":0]
        let url = ApiUrls.composedBaseUrl(String(format:"/api/calendar/cancel-social-post/%@", calendarSocialPostId))
        
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
