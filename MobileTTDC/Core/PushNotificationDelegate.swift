//
//  PushNotificationDelegate.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 1/4/17.
//  Copyright © 2017 Trevis Thomas. All rights reserved.
//

import Foundation

protocol PushNotificationDelegate {
    func registerDeviceToken(deviceToken : String)
    func failedToRegister()
}
