//
//  StatisticsApi.swift
//  ipopmetrics
//
//  Created by Rares Pop on 28/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Alamofire

class StatisticsApi: BaseApi {
    
    func getItems(_ brandId: String,
                  callback: @escaping (_ response: ResponseWrapperOne<StatisticsResponse>?, _ error: ApiError?) -> Void) {
        
        let params = [
            "a": 0
        ]
        
        Alamofire.request(ApiUrls.getMyBrandStatisticsUrl(brandId), method: .get, parameters: params,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<StatisticsResponse>>) in
                            
                            if let err = self.createErrorWithHttpResponse(response: response.response) {
                                callback(nil, err)
                                return
                            }
                            else {
                                callback(response.result.value, nil)
                            }
                            
        }
    }
    
}
