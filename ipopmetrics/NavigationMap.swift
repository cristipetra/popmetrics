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
        
        navigator.handle("vnd.popmetrics://hubs/home/section/<string:section") { url, values, context in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainTabVC = appDelegate.window?.rootViewController as! MainTabBarController
            mainTabVC.selectedIndex = 0
            
            // if the section is empty just leave it as default
            guard let section = values["section"] as? String else { return true }
            
            mainTabVC.navigateToSection(tabIndex:0, section: section)
            return true
        }
        
        navigator.handle("vnd.popmetrics://hubs/home/card/<string:card") { url, values, context in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainTabVC = appDelegate.window?.rootViewController as! MainTabBarController
            mainTabVC.selectedIndex = 0
            
            // if the section is empty just leave it as default
            guard let card = values["card"] as? String else { return true }
            
            mainTabVC.navigateToCard(tabIndex:0, cardName: card)
            
            return true
        }
        
        navigator.handle("vnd.popmetrics://hubs/todo/section/<string:section>") { url, values, context in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainTabVC = appDelegate.window?.rootViewController as! MainTabBarController
            mainTabVC.selectedIndex = 1
            // if the section is empty just leave it as default
            guard let section = values["section"] as? String else { return true }
            mainTabVC.navigateToSection(tabIndex:1, section: section)
            return true
        }
        
        navigator.handle("vnd.popmetrics://hubs/calendar/section/<string:section>") { url, values, context in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainTabVC = appDelegate.window?.rootViewController as! MainTabBarController
            mainTabVC.selectedIndex = 2
            // if the section is empty just leave it as default
            guard let section = values["section"] as? String else { return true }
            mainTabVC.navigateToSection(tabIndex:2, section: section)
            return true
        }
        
        navigator.handle("vnd.popmetrics://hubs/stats/section/<string:section>") { url, values, context in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainTabVC = appDelegate.window?.rootViewController as! MainTabBarController
            mainTabVC.selectedIndex = 3
            // if the section is empty just leave it as default
            guard let section = values["section"] as? String else { return true }
            mainTabVC.navigateToSection(tabIndex:0, section: section)
            return true
        }
        
        navigator.register("vnd.popmetrics://required_action/<string:action_name>") { url, values, context in
            
            let wizard = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ConnectWizardGoogleMyBusinessVC") as! ConnectWizardGoogleMyBusinessVC
            
            guard let cardName = values["action_name"] as? String else { return nil }
            guard let card = PopHubStore.getInstance().getHubCardWithName(cardName) else { return nil }
            wizard.configure(card as! PopHubCard)
            return wizard
        }
        
        navigator.register("vnd.popmetrics://insight_details/<string:id>") { url, values, context in
            
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "InsightDetailsViewController") as! InsightPageDetailsViewController
            guard let cardID = values["id"] as? String else { return nil }
            
            guard let card = PopHubStore.getInstance().getHubCardWithId(cardID) else { return nil }
            vc.configure(card:card)
            return vc
        }
        
        navigator.register("vnd.popmetrics://action_details/<string:action_name>") { url, values, context in
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ActionDetailsViewController") as! ActionDetailsViewController
            
            guard let cardName = values["action_name"] as? String else { return nil }
            guard let card = TodoStore.getInstance().getTodoCardWithName(cardName) else { return nil }
            
            vc.configure(card)
            return vc
        }
        
        navigator.register("vnd.popmetrics://action_status/<string:action_name>") { url, values, context in
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ActionStatusViewController") as! ActionStatusViewController
            
            guard let cardName = values["action_name"] as? String else { return nil }
            guard let card = TodoStore.getInstance().getTodoCardWithName(cardName) else { return nil }
            
            vc.configure(card)
            return vc
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
