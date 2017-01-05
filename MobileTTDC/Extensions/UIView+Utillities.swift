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
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
//            UIApplication.shared.openURL(request.url!)
            
            
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                //If you want handle the completion block than
//                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
//                    print("Open url : \(success)")
//                })
//            }
            
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
}


protocol DynamicAppStyle {
    func refreshStyle()
}

protocol CurrentUserProtocol {
    func onCurrentUserChanged()
}


extension UIView : DynamicAppStyle {
    
    func registerForStyleUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(catchStyleNotification), name: NSNotification.Name(rawValue: ApplicationContext.styleChangedNotificationKey), object: nil)
        
        refreshStyle()
    }
    
    func catchStyleNotification(_ notification: Notification) {
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
        NotificationCenter.default.addObserver(self, selector: #selector(catchStyleNotification), name: NSNotification.Name(rawValue: ApplicationContext.styleChangedNotificationKey), object: nil)
        
        refreshStyle()
    }
    
    func catchStyleNotification(_ notification: Notification) {
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


