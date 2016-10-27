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
    var conversation : UIViewController!
    var login : UIViewController!
    var forum : UIViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        latest = storyboard.instantiateViewControllerWithIdentifier("LatestNav")
        conversation = storyboard.instantiateViewControllerWithIdentifier("ConversationNav")
        forum = storyboard.instantiateViewControllerWithIdentifier("ForumNav")
        login = storyboard.instantiateViewControllerWithIdentifier("LoginNav")
        
        configureGuest()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarViewController.catchNotification), name: ApplicationContext.currentUserKey, object: nil)
    }

    func catchNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let currentUser = userInfo["login"] as? String
            
            if currentUser != nil {
                configureAuthenticated()
            } else {
                configureGuest()
            }
        }
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
        self.tabBar.tintColor = UIColor.greenColor()
        
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
        controllerArray.append(conversation)
        controllerArray.append(forum)
        controllerArray.append(login)
        
        self.setViewControllers(controllerArray, animated: true)
        
        self.selectedIndex = 0
    }
    
    func configureGuest() {
        self.tabBar.tintColor = UIColor.greenColor()
        
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
