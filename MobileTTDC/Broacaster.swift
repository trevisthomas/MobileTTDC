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

fileprivate class Weak<T: AnyObject> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
}

public class Broacaster : NSObject {
    fileprivate var postUpdateObservers : [Weak<AnyObject>] = []
    
    func subscribe(consumer : BroadcastEventConsumer) {
        postUpdateObservers.append(Weak(value: consumer as AnyObject))
    }
    
    func postUpdated(post : Post){
        NotificationCenter.default.post(name: Notification.Name(rawValue: Event.postUpdated.rawValue), object: nil, userInfo: ["post" : PostWrapper(post: post)])
    }
    
    override init() {
        super.init()
        setupPostBroacastUpdates()
    }
    
    func setupPostBroacastUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(catchPostUpdated), name: NSNotification.Name(rawValue: Event.postUpdated.rawValue), object: nil)
    }
    
    func catchPostUpdated(_ notification: Notification) {
        guard let postWrapper = notification.userInfo?["post"] as? PostWrapper else {
            return
        }
        
        for weakO in postUpdateObservers {
            guard let consumer = weakO.value as? BroadcastEventConsumer else {
                return
            }
            if consumer.post == nil {
                continue
            }
            
            if consumer.post.postId == postWrapper.post.postId {
                consumer.onPostUpdated(post: postWrapper.post)
            }
        }
    }
}

protocol BroadcastEventConsumer {
    var post : Post! {get set}
    func onPostUpdated(post : Post)
    
}

