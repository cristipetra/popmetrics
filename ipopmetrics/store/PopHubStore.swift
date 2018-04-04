//
//  PopHubStore.swift
//  ipopmetrics
//
//  Created by Rares Pop on 04/04/2018.
//  Copyright © 2018 Popmetrics. All rights reserved.
//

import Foundation
import RealmSwift

class PopHubStore:HubStore<PopHubCard> {
 
    static func getInstance() -> PopHubStore {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.hubStore
    }
    
}
