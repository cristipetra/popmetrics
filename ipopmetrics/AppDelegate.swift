//
//  AppDelegate.swift
//  ipopmetrics
//
//  Created by Rares Pop on 05/01/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import GoogleSignIn
//import STPopup



private let SBID_LOGIN_NAV_VC = "LoginNavigationViewController"
private let SBID_MAIN_TAB_VC = "MainTabBarController"


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
        usersStore = UsersStore(context: managedObjectContext)
        feedStore = FeedStore()
        // Setup crashlytics
        // Fabric.with([Crashlytics.self])

        navigationController = NavigationController()

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = storyBoard.instantiateViewController(withIdentifier: SBID_MAIN_TAB_VC)
        window.makeKeyAndVisible()
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
//        feedItemsStore = FeedItemsStore(context: managedObjectContext)
//        setInitialViewController()

//        open(viewURI: .homeHubViewURI, animated: false)
        
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
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if !isLoggedIn() {
            return storyBoard.instantiateViewController(withIdentifier: SBID_LOGIN_NAV_VC)
        }
        return storyBoard.instantiateViewController(withIdentifier: SBID_MAIN_TAB_VC)
    }
    
    func isLoggedIn() -> Bool {
        return usersStore.hasCredentials()
    }

    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.athanasys.Homzen" in the application's documents Application Support directory.
        let urls = FileManager().urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Popmetrics", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("PopmetricsCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
//            || FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
//            || PDKClient.sharedInstance().handleCallbackURL(url)
    }
    
    
    
    private func createViewController(viewURI: URL) -> UIViewController? {

        let mainTbc = storyBoard.instantiateViewController(withIdentifier: SBID_MAIN_TAB_VC)
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


    


}

