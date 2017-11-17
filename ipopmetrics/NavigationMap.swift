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
        
        navigator.register("popmetrics://user/<username>") { url, values, context in
            guard let username = values["username"] as? String else { return nil }
            print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
            return nil
        }
        navigator.register("http://<path:_>", self.webViewControllerFactory)
        navigator.register("https://<path:_>", self.webViewControllerFactory)
        
        navigator.handle("popmetrics://alert", self.alert(navigator: navigator))
        navigator.handle("popmetrics://<path:_>") { (url, values, context) -> Bool in
            // No navigator match, do analytics or fallback function here
            print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
            return true
        }
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
