//
//  UIView+Utillities.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/4/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

/*
 Trevis, this is some bold shit right here.  Consider if you want this code to live here.
 */
extension UIView : UIWebViewDelegate {
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }
}

//Trevis, you also have this extension on ViewController.  Is that redundant?
extension UIView {
    func getApplicationContext() -> ApplicationContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.applicationContext
    }
}

protocol DynamicAppStyle {
    func refreshStyle()
}

//extension DynamicAppStyle {
//    func refreshStyle() {
//                //Default impl does nothing
//            }
//}

extension UIView : DynamicAppStyle {
    
    func registerForStyleUpdates() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(catchStyleNotification), name: ApplicationContext.styleChangedNotificationKey, object: nil)
        
        refreshStyle()
    }
    
    func catchStyleNotification(notification: NSNotification) {
        //Hm.  Not sure how to make this work.
//        if(self.respondsToSelector(#selector(refreshStyle))){
//            refreshStyle()
//        }
        refreshStyle()
        
        
    }
    func refreshStyle() {
        //Default impl does nothing
    }
    
}

extension UIViewController : DynamicAppStyle {
    
    func registerForStyleUpdates() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(catchStyleNotification), name: ApplicationContext.styleChangedNotificationKey, object: nil)
        
        refreshStyle()
    }
    
    func catchStyleNotification(notification: NSNotification) {
        //Hm.  Not sure how to make this work.
        //        if(self.respondsToSelector(#selector(refreshStyle))){
        //            refreshStyle()
        //        }
        refreshStyle()
        
        
    }
    func refreshStyle() {
        //Default impl does nothing
    }
    
}
