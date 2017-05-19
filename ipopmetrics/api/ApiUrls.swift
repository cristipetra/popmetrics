//
//  ApiUrls.swift
//  Popmetrics
//
//  Created by Rares Pop
//  Copyright © 2016 Popmetrics. All rights reserved.
//

import Foundation

// MARK: - Constants
// private let PROTOCOL = "https"
private let PROTOCOL = "http"
// private let HOST = "api.popmetrics.io"
// private let PORT = 443
private let HOST = "192.168.1.101"
// private let HOST = "10.0.1.30"
private let PORT = 5055
// private let PORT = 5030

private let LOGIN_PATH = "/api/caas/sign_in_with_email"
private let SEND_CODE_BY_SMS_PATH = "/api/caas/send_code_by_sms"
private let LOGIN_WITH_CODE_PATH = "/api/caas/sign_in_with_code"

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
private let ACCOUNT_EDIT_PATH = "/api/caas/me"

private let USER_FEED_PATH = "/api/feed/me"

private let CONNECT_GOOGLE_ANALYTICS = "/connect_google_analytics"
private let CONNECT_TWITTER = "/connect_twitter"

class ApiUrls {
    
    fileprivate static func escapedUrl(_ url: String) -> String {
        return url.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    fileprivate static func composedBaseUrl(_ with: String) -> String {
        return escapedUrl(String(format: "%@%@", getBaseUrl(), with))
    }
    
    static func getBaseUrl() -> String {
        if (PORT == 80 || PORT == 443) {
            return escapedUrl(String(format: "%@://%@", PROTOCOL, HOST, PORT))
        }
        else {
            
            return escapedUrl(String(format: "%@://%@:%d", PROTOCOL, HOST, PORT))
        }
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
    
    
    static func getSendCodeBySmsUrl() -> String {
        return composedBaseUrl(SEND_CODE_BY_SMS_PATH)
    }
    
    static func getLoginWithCodeUrl() -> String {
        return composedBaseUrl(LOGIN_WITH_CODE_PATH)
    }
    
    static func getUserFeedUrl() -> String {
        return composedBaseUrl(USER_FEED_PATH)
    }
    
    static func getConnectGoogleAnalyticsUrl() -> String {
        return composedBaseUrl(CONNECT_GOOGLE_ANALYTICS)
    }
    
    static func getConnectTwitterUrl() -> String {
        return composedBaseUrl(CONNECT_TWITTER)
    }
    
    
}
