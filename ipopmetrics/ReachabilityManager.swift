//
//  ReachabilityManager.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 09/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ReachabilitySwift

public protocol NetworkStatusListener : class {
    func networkStatusDidChange(status: Reachability.NetworkStatus)
}

class ReachabilityManager: NSObject {
    static  let shared = ReachabilityManager()
    var listeners = [NetworkStatusListener]()
    var isNetworkAvailable = false
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    let reachability = Reachability()!
    
    func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            print("Network became unreachable")
        case .reachableViaWiFi:
            print("Network reachable through WiFi")
        case .reachableViaWWAN:
            print("Network reachable through Cellular Data")
        }
        isNetworkAvailable = !(reachability.currentReachabilityStatus == .notReachable)
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.currentReachabilityStatus)
        }
    }
    
    func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }
    
    func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
}
