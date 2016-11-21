//
//  BasePostCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 11/20/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class BasePostCell : UICollectionViewCell, BroadcastEventConsumer{
    var post : Post!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPostBroacastUpdates()
    }
    
    func setupPostBroacastUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(catchPostUpdated), name: NSNotification.Name(rawValue: Event.postUpdated.rawValue), object: nil)
    }
    
    func catchPostUpdated(_ notification: Notification) {
        guard let postWrapper = notification.userInfo?["post"] as? PostWrapper else {
            return
        }
        
        onPostUpdated(post: postWrapper.post)
    }
    
    func onPostUpdated(post: Post) {
        guard let p = self.post else {
            return
        }
        if p.postId == post.postId {
            self.post = post
        }
    }

}
