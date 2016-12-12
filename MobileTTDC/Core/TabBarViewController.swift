//
//  TabBarViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/27/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    var controllerArray = [UIViewController]()
    
    var latest : UIViewController!
//    var conversation : UIViewController!
    var login : UIViewController!
    var forum : UIViewController!
    var profile : UIViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        latest = storyboard.instantiateViewController(withIdentifier: "LatestNav")
//        conversation = storyboard.instantiateViewController(withIdentifier: "ConversationNav")
        forum = storyboard.instantiateViewController(withIdentifier: "ForumNav")
        login = storyboard.instantiateViewController(withIdentifier: "LoginNav")
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
        
        profile = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNav")
        
        onCurrentUserChanged()
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarViewController.catchNotification), name: ApplicationContext.currentUserKey, object: nil)
//        
        registerForUserChangeUpdates()
        
        registerForStyleUpdates()
        
    }
    
    override func onCurrentUserChanged() {
        if getApplicationContext().isAuthenticated() {
            configureAuthenticated()
        } else {
            configureGuest()
        }
    }
    

//    func catchNotification(notification: NSNotification) {
//        if let userInfo = notification.userInfo {
//            let currentUser = userInfo["login"] as? String
//            
//            if currentUser != nil {
//                configureAuthenticated()
//            } else {
//                configureGuest()
//            }
//        }
//    }
    
    
    override func refreshStyle() {
        self.tabBar.tintColor = getApplicationContext().getCurrentStyle().tintColor()
        self.tabBar.barTintColor = getApplicationContext().getCurrentStyle().navigationBackgroundColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func authenticationStateChanged(authenticated : Bool){
//        if authenticated {
//            configureAuthenticated()
//        } else {
//            configureGuest()
//        }
//    }
//    
    func configureAuthenticated() {
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
//        controllerArray.removeAll()
//        controllerArray.append(storyboard.instantiateViewControllerWithIdentifier("LatestNav"))
//        controllerArray.append(storyboard.instantiateViewControllerWithIdentifier("ConversationNav"))
//        controllerArray.append(storyboard.instantiateViewControllerWithIdentifier("ForumNav"))
//        controllerArray.append(storyboard.instantiateViewControllerWithIdentifier("LoginNav"))
        
//        self.setViewControllers(controllerArray, animated: true)
        
//        self.selectedIndex = 0
        
//        if self.controllerArray.count > 3 {
//            controllerArray.rem
//        }
        
        controllerArray.removeAll()
        controllerArray.append(latest)
//        controllerArray.append(conversation)
//        controllerArray.append(forum)
        controllerArray.append(profile)
        
        self.setViewControllers(controllerArray, animated: true)
        
        self.selectedIndex = 0
    }
    
    func configureGuest() {
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        controllerArray.removeAll()
//        controllerArray.append(storyboard.instantiateViewControllerWithIdentifier("LatestNav"))
//        controllerArray.append(storyboard.instantiateViewControllerWithIdentifier("LoginNav"))
//        
//        
//        self.setViewControllers(controllerArray, animated: true)
        
//        self.viewControllers?.rem
        
//        self.selectedIndex = 0
        
        controllerArray.removeAll()
        controllerArray.append(latest)
        controllerArray.append(login)
        
        self.setViewControllers(controllerArray, animated: true)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
