//
//  HubsApi.swift
//  ipopmetrics
//
//  Created by Rares Pop on 03/12/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//


import UIKit
import Alamofire

class HubsApi: BaseApi {
    
    func getHubsItems(_ brandId: String, lastDate: Date,
                  callback: @escaping (_ response: HubsResponse?) -> Void) {
        
        ///me/brand/<brand_id>
        let url = ApiUrls.composedBaseUrl(String(format:"/api/hubs/me/brand/%@", brandId))
        let params = ["last_date":lastDate.timeIntervalSince1970]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<HubsResponse>>) in
                            
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                let handled = super.handleResponseWrap(response.value!)
                                if !handled {
                                    let hubsResponse = response.result.value?.data!
                                    if hubsResponse?.sendApnToken ?? false {
                                        if let iosDeviceToken = UserStore.iosDeviceToken, let iosDeviceName = UserStore.iosDeviceName {
                                        UsersApi().registerIosDeviceToken(iosDeviceToken, deviceName: iosDeviceName)
                                        }
                                    }
                                    
                                    callback(response.result.value?.data!)
                                }
                            }
                            
        }
    }
    
    func postAddToMyActions( cardId:String, brandId:String, callback: @escaping (_ response: TodoCard?) -> Void) {
        
        let url = ApiUrls.composedBaseUrl("/api/feed/add-to-my-actions")
        let params = ["card_id":cardId, "brand_id":brandId]
        
        Alamofire.request(url, method: .post, parameters:params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<TodoCard>>) in
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

