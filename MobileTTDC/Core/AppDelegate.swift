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
    
    private(set) var applicationContext : ApplicationContext!
    
    
    private var latestPostId : String?
//    private(set) var serverEventMonitor : ServerEventMonitor!
    
//    private(set) var serverEventMonitor
    
//    var CommentBarButton : UIBarButtonItem {
//        get{
//            return UIBarButtonItem(title: "Add", style: .Add, target: self, action: #selector(addTapped))
//        }
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        UINavigationBar.appearance().isTranslucent = false//Trevis is ths working?
        UITabBar.appearance().isTranslucent = false
        
        //Below is the code for removing the one pixel line (drop shadow i guess?) on NavigationBar
//        UINavigationBar.appearance().setBackgroundImage(
//            UIImage(),
//            for: .any,
//            barMetrics: .default)
//        
//        UINavigationBar.appearance().shadowImage = UIImage()
//        
        
        
        return true
    }
    
    func initialize(appContext : ApplicationContext){
        applicationContext = appContext
//        serverEventMonitor = ServerEventMonitor(delegate: applicationContext)
//        serverEventMonitor.connect()
        
        // Override point for customization after application launch.
//        registerForPushNotifications(UIApplication.shared)
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//        serverEventMonitor.stop()
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
        
        resetBadgeCount() //If the app is running, aways set to zero.
        
//        applicationContext.reloadAllData()
        print("did become active")
//        applicationContext.loadState() //Calls reload data once any saved token is vaidated
//        serverEventMonitor.start()
        
        if let _ = applicationContext {
            applicationContext.becomeActive()
        }
        
        self.fetchLatestPostId(){
            (postId) in
            if self.latestPostId == nil {
                //latesPost wasn't initialized
                self.latestPostId = postId
            } else if self.latestPostId != postId {
                //New content exists
                print("Became active and discovored new content.")
                self.applicationContext.reloadPosts()
            } else {
                //Nothing to do.  No new content.
            }
            
        }
    }
    
    func resetBadgeCount(){
        UIApplication.shared.applicationIconBadgeNumber = 0
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        application.applicationIconBadgeNumber = 0 //If the app is running, aways set to zero.
        
//        if let aps = userInfo["aps"] as? [String: AnyObject] {
//            if let badge = aps["badge"] as? Int {
//                application.applicationIconBadgeNumber = badge
//            }
//        }
        
        
        
        
        // 1
//        if (aps["content-available"] as? NSString)?.integerValue == 1 {
//        if aps["content-available"] as? NSNumber == 1 {
//            //This is being a good citizen letting the device know what happened.  If you set these up as silent, i think that the OS uses this to guage battery usage.
////            completionHandler(didLoadNewItems ? .NewData : .NoData)
//            completionHandler(.newData)
//            
////            if let event = userInfo["event"] as? [String: AnyObject] {
////                let push = PushServerEvent(delegate: applicationContext)
////                push.pushEvent(event: event)
////            }
//            
//            if let event = userInfo["event"] as? [String: AnyObject] {
//                let push = PushServerEvent(delegate: applicationContext)
//                push.pushEvent(event: event)
//            }
//            
//        }
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            if let badge = aps["badge"] as? Int {
                application.applicationIconBadgeNumber = badge
            }
        }

        if let event = userInfo["event"] as? [String: AnyObject] {
            let push = PushServerEvent(delegate: applicationContext)
            completionHandler(.newData)
            push.pushEvent(event: event)
        } else if let postId = userInfo["postId"] as? String {
            completionHandler(.newData)
            let push = PushServerEvent(delegate: applicationContext)
            var event = [String : AnyObject]()
            
            event["type"] = "NEW" as AnyObject
            event["guid"] = postId as AnyObject
            push.pushEvent(event: event)
        }else {
            completionHandler(.noData)
        }
        
        
//        print("I was pushed: \(userInfo)")
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        
        pushNotificationDelegate?.registerDeviceToken(deviceToken: tokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
        pushNotificationDelegate?.failedToRegister()
    }
    
    
    fileprivate var pushNotificationDelegate : PushNotificationDelegate?
    func registerForPushNotifications(delegate : PushNotificationDelegate){
        pushNotificationDelegate = delegate
        self.registerForPushNotifications(UIApplication.shared)
    }

    public func buildSummary() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        
        return "Mobile TTDC v\(version) build \(build)"
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
    
    fileprivate func fetchLatestPostId(callback : @escaping (String?) -> Void){
        let cmd = PostCommand(action: .LATEST_FLAT, pageNumber: 1, pageSize: 1)
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            
            guard let post = response?.list[0] else {
                //This should never happen.
                callback(nil)
                return;
            }
            
            callback(post.postId)
        };
        
    }
}

