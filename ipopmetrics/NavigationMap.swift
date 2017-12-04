//
//  NavigationMap.swift
//  ipopmetrics
//
//  Created by Rares Pop on 17/11/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import SafariServices
import UIKit

import URLNavigator

enum NavigationMap {
    static func initialize(navigator: NavigatorType) {
        
        navigator.register("vnd.popmetrics://settings") { url, values, context in
            
            let settingsVC = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "staticSettings") as! StaticSettingsViewController
            return settingsVC
        }
        
        navigator.register("vnd.popmetrics://hubs/home") { url, values, context in
            
            let mainTabVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewNames.SBID_MAIN_TAB_VC) as! MainTabBarController
            mainTabVC.selectedIndex = 0
            return mainTabVC
        }
        
        navigator.register("vnd.popmetrics://hubs/todo") { url, values, context in
            
            let mainTabVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewNames.SBID_MAIN_TAB_VC) as! MainTabBarController
            mainTabVC.selectedIndex = 1
            return mainTabVC
        }
        
        navigator.register("vnd.popmetrics://insight/string:id") { url, values, context in
            
            let insightDetails = InsightPageDetailsViewController(nibName: "InsightPage", bundle: nil)
            guard let cardID = values["id"] as? String else { return nil }
            guard let feedCard = FeedStore.getInstance().getFeedCardWithId(cardID) else { return nil }
            insightDetails.configure(feedCard)
            return insightDetails
        }
        
        navigator.register("http://<path:_>", self.webViewControllerFactory)
        navigator.register("https://<path:_>", self.webViewControllerFactory)

    }
    
    
    private static func webViewControllerFactory(
        url: URLConvertible,
        values: [String: Any],
        context: Any?
        ) -> UIViewController? {
        guard let url = url.urlValue else { return nil }
        return SFSafariViewController(url: url)
    }
    
    private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            navigator.present(alertController)
            return true
        }
    }
}
