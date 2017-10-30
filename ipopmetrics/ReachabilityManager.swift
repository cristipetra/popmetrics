//
//  ReachabilityManager.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 09/10/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Reachability

public protocol NetworkStatusListener : class {
    func networkStatusDidChange(status: Reachability.Connection)
}

class ReachabilityManager: NSObject {
    static  let shared = ReachabilityManager()
    var listeners = [NetworkStatusListener]()
    var isNetworkAvailable = false
    var reachabilityStatus: Reachability.Connection = .none
    let reachability = Reachability()!
    
    func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            print("Network became unreachable")
        case .wifi:
            print("Network reachable through WiFi")
        case .cellular:
            print("Network reachable through Cellular Data")
        }
        isNetworkAvailable = !(reachability.connection == .none)
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.connection)
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
                                               name: Notification.Name.reachabilityChanged,
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
                                                  name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
}
