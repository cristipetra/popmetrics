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
import URLNavigator
import ObjectMapper
import SafariServices
//import STPopup


public extension Notification {
    public class Popmetrics {
        public static let ApiClientNeedsUpdating = Notification.Name("Notification.Popmetrics.ApiClientNeedsUpdating")
        public static let ApiClientNotAuthenticated = Notification.Name("Notification.Popmetrics.ApiClientNotAuthenticated")
        public static let ApiFailure = Notification.Name("Notification.Popmetrics.ApiFailure")
        public static let ApiReachable = Notification.Name("Notification.Popmetrics.ApiReachable")
        public static let ApiNotReachable = Notification.Name("Notification.Popmetrics.ApiNotReachable")
        public static let ApiResponseUnsuccessfull = Notification.Name("Notification.Popmetrics.ApiResponseUnsuccessfull")
        
        
        public static let SignIn = Notification.Name("Notification.Popmetrics.SignIn")
        public static let RemoteMessage = Notification.Name("Notification.Popmetrics.RemoteMessage")
        public static let UiRefreshRequired = Notification.Name("Notification.Popmetrics.UiRefreshRequired")
        public static let ReloadGraph = Notification.Name("Notification.Popmetrics.ReloadGraph")
        
    }
}

var navigator: Navigator = Navigator()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
    var usersStore: UserStore!
    var feedStore: FeedStore!
    var storyBoard: UIStoryboard!
    
    var syncService: SyncService!
    
    var safari: SFSafariViewController?
    
    var welcomeViewController: WelcomeScreen?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        usersStore = UserStore()
        feedStore = FeedStore()
        
        syncService = SyncService()
        
        ReachabilityManager.shared.startMonitoring()

        storyBoard = UIStoryboard(name: "Main", bundle: nil)

        
        Fabric.with([Twitter.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Initialize navigation map
        NavigationMap.initialize(navigator: navigator)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = getInitialViewController()
        window.makeKeyAndVisible()

        getNotificationSettings()
        
        syncService.syncAll(silent: false)
        
        // Check if launched from notification
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            
            let pnotification = Mapper<PNotification>().map(JSONObject: notification)!
            guard let link = pnotification.deepLink else { return true}
            navigator.push(link)
            
        }
        
        return true
    }
    
    func openURLInside(_ controller:UIViewController, url: String) {
        let url = URL(string: url)
        self.safari = SFSafariViewController(url: url!)
        controller.present(self.safari!, animated: true)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let fb = FBSDKApplicationDelegate.sharedInstance()
        if fb!.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
            return true
        }
        // URLNavigator Handler
        if navigator.open(url) {
            return true
        }
        
        // URLNavigator View Controller
        if navigator.present(url, wrap: UINavigationController.self) != nil {
            return true
        }
        
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        FBSDKAppEvents.activateApp() 
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        self.syncService.syncAll(silent: false)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        ReachabilityManager.shared.startMonitoring()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        ReachabilityManager.shared.stopMonitoring()
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
        
        if url.absoluteString.contains("/registration") {
            let outcome = url.queryParameters["outcome"]
            guard let phoneNumber = url.queryParameters["phone"] else { return true }
            UserStore.getInstance().phoneNumber = phoneNumber
            self.safari?.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Popmetrics.SignIn, object: nil, userInfo: ["sucess":true])
                })
        }
        
        // Try presenting the URL first
        if navigator.present(url, wrap: UINavigationController.self) != nil {
            print("[Navigator] present: \(url)")
            return true
        }
        
        // Try opening the URL
        if navigator.open(url) == true {
            print("[Navigator] open: \(url)")
            return true
        }
        
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
            || FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//            || PDKClient.sharedInstance().handleCallbackURL(url)
    }
    
    
    
    private func createViewController(viewURI: URL) -> UIViewController? {

        let mainTbc = storyBoard.instantiateViewController(withIdentifier: ViewNames.SBID_MAIN_TAB_VC)
        return mainTbc
             
    }
    
    
    // PUSH NOTIFICATIONS
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            
            print("Permission granted: \(granted)")
            guard granted else { return }
            
            self.getNotificationSettings()
        }
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // handler for push notifications received while the app is running or in background
        
        self.syncService.syncAll(silent: false, completionHandler:completionHandler)
        
//      let aps = userInfo["aps"] as! [String: AnyObject]
        let pnotification = Mapper<PNotification>().map(JSONObject: userInfo)!
        NotificationCenter.default.post(name: Notification.Popmetrics.RemoteMessage, object: nil,
                                        userInfo: pnotification.toJSON())
        
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        let changed = UIDevice.current.name != UserStore.iosDeviceName || token != UserStore.iosDeviceToken
        if changed {
            UserStore.iosDeviceName = UIDevice.current.name
            UserStore.iosDeviceToken = token
            UsersApi().registerIosDeviceToken(token, deviceName: UIDevice.current.name)
        }
        
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

}

