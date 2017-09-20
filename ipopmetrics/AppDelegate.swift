//
//  AppDelegate.swift
//  ipopmetrics
//
//  Created by Rares Pop on 05/01/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import GoogleSignIn
import TwitterKit
import FBSDKCoreKit
import UserNotifications
//import STPopup



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var navigationController: NavigationController?
    
    var window: UIWindow?
    var usersStore: UsersStore!
    var feedStore: FeedStore!
    var storyBoard: UIStoryboard!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        storyBoard = UIStoryboard(name: "Main", bundle: nil)
        feedStore = FeedStore()
        usersStore = UsersStore()
        
        // Setup crashlytics
        // Fabric.with([Crashlytics.self])

        Fabric.with([Twitter.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        var configureError: NSError?
        
        navigationController = NavigationController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = getInitialViewController()
        window.makeKeyAndVisible()
        
        registerForPushNotifications()
        
        // Check if launched from notification
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            let aps = notification["aps"] as! [String: AnyObject]
            print("launched from notifications ... ")
            
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // login
    func setInitialViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = getInitialViewController()
        window!.makeKeyAndVisible()
    }
    
    func getInitialViewController() -> UIViewController {
        if !isLoggedIn() {
            return SplashScreen()
            return AnimationsViewController()
        }
        return AppStoryboard.Main.instance.instantiateViewController(withIdentifier: ViewNames.SBID_MAIN_TAB_VC)

    }
    
    func isLoggedIn() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "currentBrandId") != nil { return true }
            else { return false}
    }


    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//            || FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//            || PDKClient.sharedInstance().handleCallbackURL(url)
    }
    
    
    
    private func createViewController(viewURI: URL) -> UIViewController? {

        let mainTbc = storyBoard.instantiateViewController(withIdentifier: ViewNames.SBID_MAIN_TAB_VC)
        return mainTbc
             
    }
    
    
    
    
    @discardableResult private func open(viewURI: URL, animated: Bool) -> Bool {
        guard let viewController = createViewController(viewURI: viewURI) else {
            print("No view controller for URI \(viewURI)")
            return false
        }
        
        prepareAndPush(viewController: viewController, animated: animated)
        
        return true
    }
    
    // MARK: - View controller handling
    
    private func prepareAndPush(viewController: UIViewController, animated: Bool) {
        
       
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    // PUSH NOTIFICATIONS
    
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        
//        if aps["content-available"] as? Int == 1 {
//            let podcastStore = PodcastStore.sharedStore
//            podcastStore.refreshItems { didLoadNewItems in
//                completionHandler(didLoadNewItems ? .newData : .noData)
//            }
//        } else  {
//            _ = NewsItem.makeNewsItem(aps)
//            completionHandler(.newData)
//        }
    }
    
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            
            print("Permission granted: \(granted)")
            guard granted else { return }
            
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        let defaults = UserDefaults.standard
        defaults.set(token, forKey: "deviceToken")
        let deviceID = UIDevice.current.name
        defaults.set(deviceID, forKey:"deviceId")
        
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    


}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//        let userInfo = response.notification.request.content.userInfo
//        let aps = userInfo["aps"] as! [String: AnyObject]
//        
//        if let newsItem = NewsItem.makeNewsItem(aps) {
//            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//            
//            if response.actionIdentifier == viewActionIdentifier,
//                let url = URL(string: newsItem.link) {
//                let safari = SFSafariViewController(url: url)
//                window?.rootViewController?.present(safari, animated: true, completion: nil)
//            }
//        }
//        
//        completionHandler()
//    }
//}

