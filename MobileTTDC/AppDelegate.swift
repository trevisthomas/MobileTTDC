//
//  AppDelegate.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 5/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?
    
    let applicationContext = ApplicationContext()
    
//    var CommentBarButton : UIBarButtonItem {
//        get{
//            return UIBarButtonItem(title: "Add", style: .Add, target: self, action: #selector(addTapped))
//        }
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().isTranslucent = false
        // Override point for customization after application launch.
        registerForPushNotifications(application)
        
        
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
//        applicationContext.reloadAllData()
        applicationContext.loadState() //Calls reload data once any saved token is vaidated
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //Push:

    // iOS 10 deprecated
//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//        if notificationSettings.types != UIUserNotificationType() {
//            application.registerForRemoteNotifications()
//        }
//    }
    
//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//        if notificationSettings.types != UIUserNotificationType() {
//            application.registerForRemoteNotifications()
//        }
//    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        
        applicationContext.deviceToken = tokenString
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }


}

extension AppDelegate {
    
//    func registerForPushNotifications(_ application: UIApplication) {
//        let notificationSettings = UIUserNotificationSettings(
//            types: [.badge, .sound, .alert], categories: nil)
//        application.registerUserNotificationSettings(notificationSettings)
//    }
    
    func registerForPushNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){
            (success, error) in
            application.registerForRemoteNotifications()
        }
        
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge],
//        completionHandler: { (granted, error) in
//            application.registerForRemoteNotifications()
//        }
    }
}

