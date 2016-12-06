//
//  BaseCollectionViewCell.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 12/6/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class BaseCollectionViewCell : UICollectionViewCell, PostUpdateListener {
//    func getPostId() -> String? {
//        abort()
//    }
//    
//    func onPostUpdated(post : Post) {
//        assert(false)
//    }
    
    var post : Post!
    
    func onPostUpdated(post: Post) {
        self.post = post
    }
    
    func getPostId() -> String? {
        return self.post.postId
    }
}
