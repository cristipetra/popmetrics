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
    
    func postOverlay(_ overlay: OverlayDetails, brandId:String, callback: @escaping (_ response: Brand?) -> Void) {
        
        let url = ApiUrls.composedBaseUrl("/api/usersettings/overlay/"+overlay.id!)
        let params = ["brand_id":brandId, "overlay": overlay.toJSON()] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters:params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<Brand>>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                let handled = super.handleResponseWrap(response.value!)
                                if !handled {
                                    callback(response.result.value?.data)
                                }
                            }
        }
    }
    
}
