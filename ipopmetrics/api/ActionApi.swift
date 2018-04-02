//
//  ActionApi.swift
//  ipopmetrics
//
//  Created by Rares Pop on 21/03/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//
import UIKit
import Alamofire
import ObjectMapper

class ActionResponse: Mappable {
    
    var cards: [StatsCard]?
    var metrics: [StatsMetric]?
    
    required init?(map: Map) {
    }
    
    func mapping(map:Map) {
        cards               <- map["cards"]
        metrics   <- map["metrics"]
    }
    
    func matchCard(_ cardId:String) -> (Bool, StatsCard?) {
        if self.cards == nil {
            return (false, nil)
        }
        if let i = self.cards?.index(where: {$0.cardId == cardId}) {
            return (true, self.cards![i])
        }
        else {
            return (false, nil)
        }
        
    }
}


class ActionApi: BaseApi {
    
    func markAsComplete( cardId:String, brandId:String, callback: @escaping (_ response: ActionResponse?) -> Void) {
        
        let url = ApiUrls.composedBaseUrl("/api/actions/brand/"+brandId+"/mark-as-complete")
        let params = ["card_id":cardId, "brand_id":brandId]
        
        Alamofire.request(url, method: .post, parameters:params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<ActionResponse>>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                let handled = super.handleResponseWrap(response.value!)
                                if !handled {
                                    callback(response.result.value?.data)
                                }
                            }
        }
    }
    
    func order( cardId:String, brandId:String, callback: @escaping (_ response: ActionResponse?) -> Void) {
        
        let url = ApiUrls.composedBaseUrl("/api/actions/brand/"+brandId+"/order")
        let params = ["card_id":cardId, "brand_id":brandId]
        
        Alamofire.request(url, method: .post, parameters:params, encoding: JSONEncoding.default,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<ActionResponse>>) in
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
