//
//  UsersApi.swift
//  ipopmetrics
//
//  Created by Rares Pop on 16/01/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper


class UsersApi: BaseApi {
    
    func sendCodeBySms(phoneNumber: String,
                                     callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
        let params = [
            "phone_number": phoneNumber
            ]
        
        
        Alamofire.request(ApiUrls.getSendCodeBySmsUrl(), method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if let err = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, err)
                return
            }
            
            if let resultDict = response.result.value as? [String: Any] {
                callback(resultDict, nil)
            }
            
        }
    }

    
    
    
    fileprivate func logInWithSocial(_ url: String, userId: String, token: String, clientId: String? = nil,
                                     callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
        var params = [
            "user_id": userId,
            "token": token,
            ]
        if clientId != nil {
            params["client_id"] = clientId!
        }
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if let err = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, err)
                return
            }
            
            if let resultDict = response.result.value as? [String: Any] {
                callback(resultDict, nil)
            }
            
        }
    }
    
    fileprivate func registerWithSocial(_ url: String, userId: String, token: String, name: String, email: String, imageUrl: String, clientId: String? = nil,
                                        callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
        
        var params = [
            "user_id": userId,
            "token": token,
            "name": name,
            "email": email,
            "image_url": imageUrl
        ]
        if clientId != nil {
            params["client_id"] = clientId!
        }
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if let err = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, err)
                return
            }
            
            if let resultDict = response.result.value as? [String: Any] {
                callback(resultDict, nil)
            }
            
            callback(nil, ApiError.apiNotAvailable)
        }
    }
    
//    func logInWithFacebook(_ userId: String, token: String,
//                           callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
//        logInWithSocial(ApiUrls.getLoginWithFacebookUrl(), userId: userId, token: token, callback: callback)
//    }
//    
//    func registerWithFacebook(_ userId: String, token: String, name: String, email: String, imageUrl: String,
//                              callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
//        registerWithSocial(ApiUrls.getRegisterWithFacebookUrl(), userId: userId, token: token, name: name, email: email, imageUrl: imageUrl,
//                           callback: callback)
//    }
//    
//    func logInWithPinterest(_ userId: String, token: String,
//                            callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
//        logInWithSocial(ApiUrls.getLoginWithPinterestUrl(), userId: userId, token: token, callback: callback)
//    }
//    
//    func registerWithPinterest(_ userId: String, token: String, name: String, email: String, imageUrl: String,
//                               callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
//        registerWithSocial(ApiUrls.getRegisterWithPinterestUrl(), userId: userId, token: token, name: name, email: email, imageUrl: imageUrl,
//                           callback: callback)
//    }
//    
//    func logInWithGoogle(_ userId: String, token: String,
//                         callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
//        let clientId = GOOGLE_CLIENT_ID
//        logInWithSocial(ApiUrls.getLoginWithGoogleUrl(), userId: userId, token: token, clientId: clientId, callback: callback)
//    }
//    
//    func registerWithGoogle(_ userId: String, token: String, name: String, email: String, imageUrl: String,
//                            callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
//        let clientId = GOOGLE_CLIENT_ID
//        registerWithSocial(ApiUrls.getRegisterWithGoogleUrl(), userId: userId, token: token, name: name, email: email, imageUrl: imageUrl,
//                           clientId: clientId, callback: callback)
//    }
//    
    func logInWithEmailAndPassword(_ email: String, password: String,
                                   callback: @escaping (_ resultDict: [String: Any]?, _ error: ApiError?) -> Void) {
        let params = [
            "email": email,
            "password": password
        ]
        Alamofire.request(ApiUrls.getLogInUrl(), method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if let err = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, err)
                return
            }
            
            if let resultDict = response.result.value as? [String: Any] {
                callback(resultDict, nil)
            }
            else {
                callback(nil, ApiError.apiNotAvailable)
            }
        }
    }
    
    
    func logInWithSmsCode(_ phoneNumber:String, smsCode: String,
                            callback: @escaping (_ response: ResponseWrapperOne<UserAccount>?, _ error: ApiError?) -> Void) {
        var params = [
            "code": smsCode,
            "phone_number": phoneNumber,
            "ios_udid": UserStore.iosDeviceName
        ]
        if let deviceToken = UserStore.iosDeviceToken {
            params["ios_device_token"] = deviceToken
        }
        
        let url = ApiUrls.getLoginWithCodeUrl()
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseObject() { (response:
            DataResponse<ResponseWrapperOne<UserAccount>>) in
            
            if let err = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, err)
                return
            }
            else {
                callback(response.result.value, nil)
                return
            }            
        }
    }
    
    func registerWithDetails(_ name: String, email: String, password: String,
                             callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
        
        let params = [
            "name": name,
            "email": email,
            "password": password
        ]
        Alamofire.request(ApiUrls.getRegisterUrl(), method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if let err = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, err)
                return
            }
            
            
            if let resultDict = response.result.value as? [String: Any] {
                if let responseDict = resultDict["response"] as? [String: Any] {
                    // Check if we've received any errors related to the email
                    // Maybe it already exists?
                    if let errorsDict = responseDict["errors"] as? [String: Any] {
                        if errorsDict["email"] != nil {
                            callback(nil, ApiError.userAlreadyExists)
                            return
                        }
                    }
                    
                    if let userDict = responseDict["user"] as? [String: Any] {
                        callback(userDict, nil)
                        return
                    }
                }
            }
            
            callback(nil, ApiError.apiNotAvailable)
        }
    }
    
    func getImageWithUrl(_ urlString: String, callback: @escaping (_ image: UIImage?, _ error: ApiError?) -> Void) {
        Alamofire.request(urlString).responseData { response in
            if let error = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, error)
                return
            }
            if let data = response.result.value {
                callback(UIImage(data: data), nil)
                return
            }
            callback(nil, ApiError.apiNotAvailable)
        }
    }
    
    func getAccountInfo(_ callback: @escaping (_ userDict: [String: Any]?, _ error: ApiError?) -> Void) {
        Alamofire.request(ApiUrls.getAccountInfoUrl(), headers: createHeaders()).responseJSON { response in
            if let err = self.createErrorWithHttpResponse(response: response.response) {
                callback(nil, err)
                return
            }
            if let userDict = response.result.value as? [String: Any] {
                callback(userDict, nil)
                return
            }
            callback(nil, ApiError.apiNotAvailable)
        }
    }
    
    func updateUserAccount(_ name: String, image: UIImage, callback: @escaping (_ error: ApiError?) -> Void) {
        
        
        let url = ApiUrls.getAccountUpdateUrl()
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                let nameData = name.data(using: String.Encoding.ascii)!
                let imageData = UIImagePNGRepresentation(image)!
                
                multipartFormData.append(nameData, withName: "name")
                multipartFormData.append(imageData, withName: "image", fileName: "image", mimeType: "image/png")
        },
            to: url,
            headers: self.createHeaders(),
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let error = self.createErrorWithHttpResponse(response: response.response) {
                            callback(error)
                            return
                        }
                        callback(nil)
                    }
                case .failure( _):
                    callback(ApiError.apiNotAvailable)
                }
        }
        )
    }
    
    func getMyBrands( callback: @escaping (_ response: [Brand]?) -> Void) {
        
        Alamofire.request(ApiUrls.getMyBrandsUrl(),
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperArray<Brand>>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                let handled = super.handleResponseWrap(response.value!)
                                if !handled {
                                    callback(response.result.value?.data)
                                }
                            }
        }
   }
    
    func getBrandDetails(_ brandId: String,
                  callback: @escaping (_ response: Brand?)  -> Void) {
        // /api/brand/describe/<brand_id>'
        let url = ApiUrls.composedBaseUrl(String(format:"/api/brand/describe/%@", brandId))
        let params = ["a":0]
        
        Alamofire.request(url, method: .get, parameters: params,
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
    
    func registerIosDeviceToken(_ token:String, deviceName: String) {
        // /api2/caas/me/register/ios-device-token
        let url = ApiUrls.composedBaseUrl("/api2/caas/me/register/ios-device-token")
        let params = ["ios_device_token":token,
                      "ios_device_name": deviceName]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, 
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperEmpty>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            
        }
    }
    
    func resetBrandHubs(_ brandId: String) {
        // /api/hubs/reset-brand/<brand_id>'
        let url = ApiUrls.composedBaseUrl(String(format:"/api/hubs/reset-brand/%@", brandId))
        let params = ["a":0]
        
        Alamofire.request(url, method: .get, parameters: params,
                          headers:createHeaders()).responseObject() { (response: DataResponse<ResponseWrapperOne<Brand>>) in
                            let levelOneHandled = super.handleNotOkCodes(response: response.response)
                            if !levelOneHandled {
                                let handled = super.handleResponseWrap(response.value!)
                                let when = DispatchTime.now() + 3 
                                DispatchQueue.main.asyncAfter(deadline: when) {
                                    SyncService().syncAll(silent:true)

                                }

                            }
        }
    }
    
    
}
