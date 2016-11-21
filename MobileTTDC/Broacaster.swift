//
//  Broacaster.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/20/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

enum Event : String {
    case postUpdated = "Update"
}

public class Broacaster {
    class func postUpdated(post : Post){
        NotificationCenter.default.post(name: Notification.Name(rawValue: Event.postUpdated.rawValue), object: nil, userInfo: ["post" : PostWrapper(post: post)])
    }
}

protocol BroadcastEventConsumer {
    func onPostUpdated(post : Post)
}

