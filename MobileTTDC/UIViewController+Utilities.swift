//
//  UIViewController+AppDelegate.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 6/26/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

extension UIViewController {
    func getToken() -> String? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.currentToken
    }
    
    func getAuthenticatedPerson() -> Person? {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.authenticatedPerson
    }
}

