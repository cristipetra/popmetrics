//
//  FeedApi.swift
//  ipopmetrics
//
//  Created by Rares Pop on 07/04/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Alamofire

class FeedApi: BaseApi {
    
    func getItems(sinceDate: Date,
                       callback: @escaping (_ resultDict: [String: Any]?, _ error: ApiError?) -> Void) {
        let params = [
            "sinceDate": 0
        ]
        
        
        Alamofire.request(ApiUrls.getUserFeedUrl(), method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
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
