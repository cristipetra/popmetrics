    //
//  SyncService.swift
//  ipopmetrics
//
//  Created by Rares Pop on 27/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import Alamofire
import Reachability

class SyncService: SessionDelegate {
    
    var manager: SessionManager!
    public var reachability: Reachability!
    var usersStore: UserStore!
    var usersApi: UsersApi!
    
    var feedStore: FeedStore!
    var feedApi: FeedApi!
    
    var todoStore: TodoStore!
    var todoApi: TodoApi!
    
    var calendarStore: CalendarStore!
    var calendarApi: CalendarApi!
    
    var statsStore: StatsStore!
    
    deinit {
        self.reachability.stopNotifier()
    }
    
    static func getInstance() -> SyncService {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.syncService
    }
    
    override init() {
        super.init()
        manager = createManager()
        setupReachability(ApiUrls.getHost())
        
        usersStore = UserStore.getInstance()
        usersApi = UsersApi()
        
        feedStore = FeedStore.getInstance()
        feedApi = FeedApi()
        
        todoStore = TodoStore.getInstance()
        todoApi = TodoApi()
        
        calendarStore = CalendarStore()
        calendarApi = CalendarApi()
        
        statsStore = StatsStore()
        
    }
    
    static var lastDate: Date {
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue.timeIntervalSince1970, forKey: "homeHubLastDate")
        }
        get {
            let cbi = UserDefaults.standard.double(forKey: "homeHubLastDate")
            return Date(timeIntervalSince1970: cbi)
        }
    }
    
    func setupReachability(_ hostName: String?) {
        
        self.reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        
        reachability?.whenReachable = { reachability in
            print("Reachability changed. Reachable state ...")
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiReachable, object: reachability)
            self.syncAll(silent: false)
        }
        
        reachability?.whenUnreachable = { reachability in
            print("Reachability changed. Unreachable state ...")
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiNotReachable, object: reachability)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    
    func createManager() -> SessionManager {
        let configId = UUID().uuidString
        let config = URLSessionConfiguration.background(withIdentifier: configId)
        
        let manager = SessionManager(configuration: config, delegate: self, serverTrustPolicyManager: nil)
        
        return manager
    }
    
    
    func syncHomeItems(silent:Bool) {
        
        if self.reachability.connection == Reachability.Connection.none {
            return
        }
        
        let currentBrandId = UserStore.currentBrandId
        
        FeedApi().getItems(currentBrandId) { feedResponse in
            
            self.feedStore.updateFeed(feedResponse!)
            if (!silent){
                    NotificationCenter.default.post(name: Notification.Popmetrics.UiRefreshRequired, object: nil,
                                                userInfo: ["sucess":true])
                }
        }
        
    }
    
    func syncTodoItems(silent:Bool) {
        
        if !self.reachability.isReachable {
            return
        }
        
        let currentBrandId = UserStore.currentBrandId
        
        TodoApi().getItems(currentBrandId) { todoResponse in
            
            self.todoStore.updateTodos(todoResponse!)
            if (!silent){
                    NotificationCenter.default.post(name: Notification.Popmetrics.UiRefreshRequired, object: nil,
                                                    userInfo: ["sucess":true])
                }
            }
        
    }
    
    func syncCalendarItems(silent: Bool) {
        if !self.reachability.isReachable {
            return
        }
        
        let currentBrandId = UserStore.currentBrandId
        
        
        CalendarApi().getItems(currentBrandId) { responseWrapper, error in
            if error != nil {
                if !silent {
                    NotificationCenter.default.post(name: Notification.Popmetrics.ApiFailure, object: nil,
                                                    userInfo: ["sucess":false])
                }
                return
            }
            if "success" != responseWrapper?.code {
                if !silent {
                    NotificationCenter.default.post(name: Notification.Popmetrics.ApiResponseUnsuccessfull, object: nil,
                                                    userInfo: ["sucess":false,
                                                               "message":responseWrapper?.message])
                }
            }
            else {
                self.calendarStore.updateCalendars((responseWrapper?.data)!)
                if (!silent){
                    NotificationCenter.default.post(name: Notification.Popmetrics.UiRefreshRequired, object: nil,
                                                    userInfo: ["sucess":true])
                }
            }
        }
    }
    
    
    func syncStatisticsItems(silent: Bool) {
        return
        
        if !self.reachability.isReachable {
            return
        }
        
        let currentBrandId = UserStore.currentBrandId
        
        StatisticsApi().getItems(currentBrandId) { responseWrapper, error in
            if error != nil {
                if !silent {
                    NotificationCenter.default.post(name: Notification.Popmetrics.ApiFailure, object: nil,
                                                    userInfo: ["sucess":false])
                }
                return
            }
            if "success" != responseWrapper?.code {
                if !silent {
                    NotificationCenter.default.post(name: Notification.Popmetrics.ApiResponseUnsuccessfull, object: nil,
                                                    userInfo: ["sucess":false,
                                                               "message":responseWrapper?.message])
                }
            }
            else {
                self.statsStore.updateStatistics((responseWrapper?.data)!)
                if (!silent){
                    NotificationCenter.default.post(name: Notification.Popmetrics.UiRefreshRequired, object: nil,
                                                    userInfo: ["sucess":true])
                }
            }
            
        }
    }
    
    func syncBrandDetails(silent:Bool) {
        
        if !self.reachability.isReachable {
            return
        }
        
        let currentBrandId = UserStore.currentBrandId
        UsersApi().getBrandDetails(currentBrandId) { brand in
            
            UserStore.currentBrand = brand!
            if (!silent){
                NotificationCenter.default.post(name: Notification.Popmetrics.UiRefreshRequired, object: nil, userInfo: ["sucess":true])
            }
        }
        
    }
    
    
    func syncAll(silent:Bool,
                 completionHandler: ((UIBackgroundFetchResult) -> Void)?) {
        
        if !usersStore.isUserDefined() {
            completionHandler?(.noData)
            return
            
        }
        
        if self.reachability.connection == Reachability.Connection.none {
            completionHandler?(.failed)
            return
        }
        
        let brandId = UserStore.currentBrandId
//        let dates = [self.feedStore.getLastUpdateDate(), self.todoStore.getLastCardUpdateDate(), self.todoStore.getLastSocialPostUpdateDate(),
//                     self.calendarStore.getLastCardUpdateDate(), self.calendarStore.getLastSocialPostUpdateDate(),
//                     self.statsStore.getLastCardUpdateDate(), self.statsStore.getLastMetricUpdateDate()]
        
        HubsApi().getHubsItems(brandId, lastDate:SyncService.lastDate) { hubsResponse in
            SyncService.lastDate = hubsResponse!.lastDate
            if let feedResponse = hubsResponse!.feed {
                self.feedStore.updateFeed( feedResponse)
            }
            if let todoResponse = hubsResponse!.todo {
                self.todoStore.updateTodos( todoResponse)
            }
            if let calendarResponse = hubsResponse!.calendar {
                self.calendarStore.updateCalendars( calendarResponse)
            }
            if let statsResponse = hubsResponse!.stats {
                self.statsStore.updateStatistics(statsResponse)
            }
            completionHandler?(.newData)
            
            if (!silent){
                NotificationCenter.default.post(name: Notification.Popmetrics.UiRefreshRequired, object: nil,
                                                userInfo: ["sucess":true])
            }
        }
    }
    

    
    func syncAll(silent:Bool) {
        syncAll(silent: silent, completionHandler: nil)
        
    }
  

}
