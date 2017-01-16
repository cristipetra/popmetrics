//
//  ApiUrls.swift
//  Popmetrics
//
//  Created by Rares Pop
//  Copyright © 2016 Popmetrics. All rights reserved.
//

import Foundation

// MARK: - Constants
private let PROTOCOL = "http"
// private let HOST = "staging.homzen.com"
// private let PORT = 80
// private let HOST = "192.168.7.101"
private let HOST = "10.0.1.11"
private let PORT = 5055

private let LOGIN_PATH = "/api/caas/sign_in_with_email"
private let LOGOUT_PATH = "/logout"
private let REGISTER_PATH = "/register"

// Facebook URLs
private let LOGIN_WITH_FACEBOOK_PATH = "/api/caas/sign_in_with_facebook"
private let REGISTER_WITH_FACEBOOK_PATH = "/api/caas/sign_up_with_facebook"
// Pinterest URLs
private let LOGIN_WITH_PINTEREST_PATH = "/api/caas/s1ign_in_with_pinterest"
private let REGISTER_WITH_PINTEREST_PATH = "/api/caas/sign_up_with_pinterest"
// Google URLs
private let LOGIN_WITH_GOOGLE_PATH = "/api/caas/sign_in_with_google"
private let REGISTER_WITH_GOOGLE_PATH = "/api/caas/sign_up_with_google"

private let ACCOUNT_INFO_PATH = "/api/caas/me"
private let ACCOUNT_EDIT_PATH = "/api/caas/me_edit"

private let PROFILE_GET_PATH = "/api/me/home_profile"
private let PROFILE_UPDATE_PATH = "/api/me/home_profile"

private let PROPERTIES_CREATE_PATH = "/api/me/visits"
private let PROPERTIES_UPDATE_PATH_FORMAT = "/api/me/visits/%@"
private let PROPERTIES_GET_PATH_FORMAT = "/api/me/visits/%@"
private let PROPERTIES_GET_ALL_PATH = "/api/me/visits"
private let PROPERTIES_SHARE_PATH_FORMAT = "/shared/visit/%@"

private let PHOTO_TAG_CREATE_PATH_FORMAT = "/api/me/visits/%@/images"
private let PHOTO_TAG_UPLOAD_IMAGE_PATH_FORMAT = "/api/visit_image/%@"

private let RATINGS_CONFIG_PATH = "" // TODO Add the actual path

class ApiUrls {
    
    fileprivate static func escapedUrl(_ url: String) -> String {
        return url.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    fileprivate static func composedBaseUrl(_ with: String) -> String {
        return escapedUrl(String(format: "%@%@", getBaseUrl(), with))
    }
    
    static func getBaseUrl() -> String {
        return escapedUrl(String(format: "%@://%@:%d", PROTOCOL, HOST, PORT))
    }
    
    
    static func getLogOutUrl() -> String {
        return composedBaseUrl(LOGOUT_PATH)
    }
    
    static func getLogInUrl() -> String {
        return composedBaseUrl(LOGIN_PATH)
    }
    
    static func getRegisterUrl() -> String {
        return composedBaseUrl(REGISTER_PATH)
    }
    
    static func getLoginWithFacebookUrl() -> String {
        return composedBaseUrl(LOGIN_WITH_FACEBOOK_PATH)
    }
    
    static func getRegisterWithFacebookUrl() -> String {
        return composedBaseUrl(REGISTER_WITH_FACEBOOK_PATH)
    }
    
    static func getLoginWithPinterestUrl() -> String {
        return composedBaseUrl(LOGIN_WITH_PINTEREST_PATH)
    }
    
    static func getRegisterWithPinterestUrl() -> String {
        return composedBaseUrl(REGISTER_WITH_PINTEREST_PATH)
    }
    
    
    static func getLoginWithGoogleUrl() -> String {
        return composedBaseUrl(LOGIN_WITH_GOOGLE_PATH)
    }
    
    static func getRegisterWithGoogleUrl() -> String {
        return composedBaseUrl(REGISTER_WITH_GOOGLE_PATH)
    }
    
    static func getAccountInfoUrl() -> String {
        return composedBaseUrl(ACCOUNT_INFO_PATH)
    }
    
    static func getAccountUpdateUrl() -> String {
        return composedBaseUrl(ACCOUNT_EDIT_PATH)
    }
    
    static func getProfilePreferencesUrl() -> String {
        return composedBaseUrl(PROFILE_GET_PATH)
    }
    
    static func getProfilePreferencesUpdateUrl() -> String {
        return composedBaseUrl(PROFILE_UPDATE_PATH)
    }
    
    static func getPropetyCreateUrl() -> String {
        return composedBaseUrl(PROPERTIES_CREATE_PATH)
    }
    
    static func getPropertyUpdateUrl(_ propertyId: String) -> String {
        return composedBaseUrl(String(format: PROPERTIES_UPDATE_PATH_FORMAT, propertyId))
    }
    
    static func getPropertyShareUrl(_ propertyId: String) -> String {
        return composedBaseUrl(String(format: PROPERTIES_SHARE_PATH_FORMAT, propertyId))
    }
    
    static func getPropertyUrl(_ propertyId: String) -> String {
        return composedBaseUrl(String(format: PROPERTIES_GET_PATH_FORMAT, propertyId))
    }
    
    static func getAllPropertiesUrl() -> String {
        return composedBaseUrl(PROPERTIES_GET_ALL_PATH)
    }
    
    static func getPhotoTagCreateUrl(_ propertyId: String) -> String {
        return composedBaseUrl(String(format: PHOTO_TAG_CREATE_PATH_FORMAT, propertyId))
    }
    
    static func getPhotoTagUploadImageUrl(_ photoTagId: String) -> String {
        return composedBaseUrl(String(format: PHOTO_TAG_UPLOAD_IMAGE_PATH_FORMAT, photoTagId))
    }
    
    static func getRatingsConfigUrl() -> String {
        return composedBaseUrl(RATINGS_CONFIG_PATH)
    }
}
