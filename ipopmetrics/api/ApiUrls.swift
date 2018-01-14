//
//  ApiUrls.swift
//  Popmetrics
//
//  Created by Rares Pop
//  Copyright © 2016 Popmetrics. All rights reserved.
//

import Foundation

// MARK: - Constants

//private let PROTOCOL = "https"
//private let HOST = "api.popmetrics.io"
//private let PORT = 443

//private let PROTOCOL = "https"
//private let HOST = "testapi.popmetrics.ai"
//private let PORT = 443


 private let PROTOCOL = "http"
 private let HOST = "192.168.7.100"
// private let HOST = "10.0.1.10"
// private let HOST = "172.20.10.2"
 private let PORT = 5030


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
private let ACCOUNT_THUMBNAIL_PATH_FORMAT = "/api/caas/user/%@/image/thumbnail"

private let USER_FEED_PATH = "/api/feed/me/brand/%@"
private let FEED_ACTION_PATH = "/api/feed/action/%@"

private let USER_TODO_PATH = "/api/todo/brand/%@"
private let USER_TODO_ACTION_PATH = "/api/todo/action/%@"

private let USER_STATISTICS_PATH = "/api/stats/brand/%@"
private let USER_STATISTICS_ACTION_PATH = "/api/stats/action/%@"

private let USER_CALENDAR_PATH = "/api/calendar/brand/%@"
private let USER_CALENDAR_ACTION_PATH = "/api/calendar/action/%@"

private let USER_TEAMS_PATH = "/api/market/user/%@/teams"

private let CONNECT_GOOGLE_ANALYTICS = "/api/market/brand/%@/connect_google_analytics"
private let CONNECT_TWITTER = "/api/market/brand/%@/connect_twitter"

class ApiUrls {
    
    fileprivate static func escapedUrl(_ url: String) -> String {
        return url.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    static func composedBaseUrl(_ with: String) -> String {
        return escapedUrl(String(format: "%@%@", getBaseUrl(), with))
    }
    
    static func getHost() -> String {
        return HOST
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
    
    static func getAccountThumbnailUrl(_ userId: String) -> String {
        return composedBaseUrl(String(format: ACCOUNT_THUMBNAIL_PATH_FORMAT, userId))
    }

    
    static func getSendCodeBySmsUrl() -> String {
        return composedBaseUrl(SEND_CODE_BY_SMS_PATH)
    }
    
    static func getLoginWithCodeUrl() -> String {
        return composedBaseUrl(LOGIN_WITH_CODE_PATH)
    }
    
    static func getMyBrandFeedUrl(_ brandId:String) -> String {
        return composedBaseUrl(String(format:USER_FEED_PATH, brandId))
    }
    
    static func getMyBrandTodoUrl(_ brandId:String) -> String {
        return composedBaseUrl(String(format:USER_TODO_PATH, brandId))
    }
    
    static func getMyBrandsUrl() -> String {
        return composedBaseUrl("/api/market/me/brands")
    }

    static func getTodoActionUrl(_ brandId:String) -> String {
        return composedBaseUrl(String(format:USER_TODO_ACTION_PATH, brandId))
    }
    
    static func getMyBrandCalendarUrl(_ brandId:String) -> String {
        return composedBaseUrl(String(format:USER_CALENDAR_PATH, brandId))
    }
    
    static func getCalendarActionUrl(_ brandId:String) -> String {
        return composedBaseUrl(String(format:USER_CALENDAR_ACTION_PATH, brandId))
    }
    
    static func getMyBrandStatisticsUrl(_ brandId:String) -> String {
        return composedBaseUrl(String(format:USER_STATISTICS_PATH, brandId))
    }
    
    static func getStatisticsActionUrl(_ brandId:String) -> String {
        return composedBaseUrl(String(format:USER_STATISTICS_ACTION_PATH, brandId))
    }
    
    
    static func getFeedRequiredActionUrl(_ brandId:String) -> String {
        return composedBaseUrl(String(format:FEED_ACTION_PATH, brandId))
    }
    
    
    static func getUserTeamsUrl(_ userId:String) -> String {
        return composedBaseUrl(String(format:USER_TEAMS_PATH, userId))
    }
    
    
    static func getConnectGoogleAnalyticsUrl(_ brandId:String) -> String {
        return composedBaseUrl(String(format:CONNECT_GOOGLE_ANALYTICS, brandId))
    }
    
    static func getConnectTwitterUrl(_ brandId:String) -> String {
        return composedBaseUrl(String(format:CONNECT_TWITTER, brandId))
    }
    
    
}
