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
    
    func getMyTeams(_ callback: @escaping (_ resultDict: [String: Any]?, _ error: ApiError?) -> Void)
    {
        
    }
    
    
    func getItems(_ brandId: String,
                  callback: @escaping (_ resultDict: [String: Any]?, _ error: ApiError?) -> Void) {
        
        let params = [
            "a": 0
        ]
        
        Alamofire.request(ApiUrls.getMyBrandTodoUrl(brandId), method: .get, parameters: params,
                          headers:createHeaders()).responseJSON { response in
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
