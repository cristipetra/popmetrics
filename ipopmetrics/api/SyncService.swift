//
//  SyncService.swift
//  ipopmetrics
//
//  Created by Rares Pop on 27/09/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import Foundation
import Alamofire
import ReachabilitySwift

class SyncService: SessionDelegate {
    
    var manager: SessionManager!
    var reachability: Reachability!
    var usersStore: UsersStore!
    var usersApi: UsersApi!
    
    var feedStore: FeedStore!
    var feedApi: FeedApi!
    
    var todoStore: TodoStore!
    var todoApi: TodoApi!
    
    var calendarStore: CalendarFeedStore!
    var calendarApi: CalendarApi!
    
    var statsStore: StatisticsStore!
    
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
        
        usersStore = UsersStore.getInstance()
        usersApi = UsersApi()
        
        feedStore = FeedStore.getInstance()
        feedApi = FeedApi()
        
        todoStore = TodoStore.getInstance()
        todoApi = TodoApi()
        
        calendarStore = CalendarFeedStore()
        calendarApi = CalendarApi()
        
        statsStore = StatisticsStore()
        
    }
    
    
    
    func setupReachability(_ hostName: String?) {
        
        self.reachability = hostName == nil ? Reachability() : Reachability(hostname: hostName!)
        
        reachability?.whenReachable = { reachability in
            NotificationCenter.default.post(name: Notification.Popmetrics.ApiReachable, object: reachability)
        }
        reachability?.whenUnreachable = { reachability in
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

        let currentBrandId = UsersStore.currentBrandId
        
        FeedApi().getItems(currentBrandId) { responseWrapper, error in
            
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
                self.feedStore.updateFeed((responseWrapper?.data)!)
                if (!silent){
                    NotificationCenter.default.post(name: Notification.Popmetrics.UiRefreshRequired, object: nil,
                                                userInfo: ["sucess":true])
                }
            }
        }
        
    }
    
    func syncAll(silent:Bool) {
        self.syncHomeItems(silent: silent)
        
    }
  

}
