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
    case postAdded = "added"
}

//fileprivate class Weak<T: AnyObject> {
//    weak var value : T?
//    init (value: T) {
//        self.value = value
//    }
//}

fileprivate class Weak<T: AnyObject> : Hashable {
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int = 1

    static func ==(lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        guard let _ = lhs.value, let _ = rhs.value else {
            return false
        }
        //ObjectIdentfier just saved my life. Hours spent seeing a solution and then i stumbled into this
        //http://nshipster.com/swift-comparison-protocols/
        return ObjectIdentifier(lhs.value!) == ObjectIdentifier(rhs.value!) //What!
    }
    
    weak var value : T?
    init (value: T) {
        self.value = value
    }
}

public class Broadcaster : NSObject {
//    fileprivate var postUpdateObservers : [Weak<AnyObject>] = []
//    fileprivate var postAddObservers : [Weak<AnyObject>] = []
    
    fileprivate var postUpdateObservers = Set<Weak<AnyObject>>()
    fileprivate var postAddObservers = Set<Weak<AnyObject>>()
    
    func subscribe(consumer : BroadcastEventConsumer) {
        postUpdateObservers.insert(Weak(value: consumer as AnyObject))
//        postUpdateObservers.append(Weak(value: consumer as AnyObject))
    }
    
    func subscribeForPostAdd(consumer : BroadcastPostAddConsumer) {
//        postAddObservers.append(Weak(value: consumer as AnyObject))
        postAddObservers.insert(Weak(value: consumer as AnyObject))
    }
    
    func postUpdated(post : Post){
        NotificationCenter.default.post(name: Notification.Name(rawValue: Event.postUpdated.rawValue), object: nil, userInfo: ["post" : PostWrapper(post: post)])
    }
    
    func postAdded(post: Post) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Event.postAdded.rawValue), object: nil, userInfo: ["post" : PostWrapper(post: post)])
    }
    
    override init() {
        super.init()
        setupPostBroacastUpdates()
    }
    
    private func setupPostBroacastUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(catchPostUpdated), name: NSNotification.Name(rawValue: Event.postUpdated.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(catchPostAdded), name: NSNotification.Name(rawValue: Event.postAdded.rawValue), object: nil)
    }
    
    func catchPostUpdated(_ notification: Notification) {
        guard let postWrapper = notification.userInfo?["post"] as? PostWrapper else {
            return
        }
        
        for weakO in postUpdateObservers {
            guard let consumer = weakO.value as? BroadcastEventConsumer else {
                return
            }
            if consumer.observingPostId(postId: postWrapper.post.postId) {
                consumer.onPostUpdated(post: postWrapper.post)
            }
        }
    }
    
    func catchPostAdded(_ notification: Notification) {
        guard let postWrapper = notification.userInfo?["post"] as? PostWrapper else {
            return
        }
        for weakO in postAddObservers {
            guard let consumer = weakO.value as? BroadcastPostAddConsumer else {
                return
            }
            
            consumer.onPostAdded(post: postWrapper.post)
        }
    }
    
    func reloadPosts(){
        for weakO in postAddObservers {
            guard let consumer = weakO.value as? BroadcastPostAddConsumer else {
                return
            }
            
            consumer.reloadPosts()
        }
    }
}

protocol BroadcastEventConsumer { //Rename to post update
//    var post : Post! {get set}
    
    func observingPostId(postId: String) -> Bool
    func onPostUpdated(post : Post)
}

protocol BroadcastPostAddConsumer {
    func onPostAdded(post : Post)
    func reloadPosts()
}

