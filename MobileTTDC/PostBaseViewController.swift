//
//  PostBaseViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 10/22/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class PostBaseViewController: UIViewController, PostViewCellDelegate{
    
    var replyPrototypeCell : PostReplyCollectionViewCell!
    var postPrototypeCell : PostCollectionViewCell!
    var reviewPostPrototypeCell : ReviewPostCollectionViewCell!
    var moviePostPrototypeCell : MoviePostCollectionViewCell!
    var rootPostPrototypeCell : RootPostCollectionViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        postPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.POST_CELL, forReuseIdentifier: ReuseIdentifiers.POST_CELL) as! PostCollectionViewCell
        
        replyPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.POST_REPLY_CELL, forReuseIdentifier: ReuseIdentifiers.POST_REPLY_CELL) as! PostReplyCollectionViewCell
        
        reviewPostPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.POST_REVIEW_CELL, forReuseIdentifier: ReuseIdentifiers.POST_REVIEW_CELL) as! ReviewPostCollectionViewCell
        
        moviePostPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.MOVIE_POST_CELL, forReuseIdentifier: ReuseIdentifiers.MOVIE_POST_CELL) as! MoviePostCollectionViewCell
        
        rootPostPrototypeCell = registerAndCreatePrototypeCellFromNib(ReuseIdentifiers.ROOT_POST_CELL, forReuseIdentifier: ReuseIdentifiers.ROOT_POST_CELL) as! RootPostCollectionViewCell
    }

    func likePost(post: Post){
        
    }
    func viewComments(post: Post){
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        performSegueWithIdentifier("ConversationWithReplyView", sender: dict)
    }
    func commentOnPost(post: Post){
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        dict["postId"] = post.postId
        performSegueWithIdentifier("ConversationWithReplyView", sender: dict)
    }
    func viewThread(post: Post) {
        performSegueWithIdentifier("ThreadView", sender: post.postId)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let nav = segue.destinationViewController as? UINavigationController else {
            return
        }
        
        if let destVC = nav.topViewController as? ThreadViewController {
            let postId = sender as! String
            destVC.rootPostId = postId
            return
        }
        
        guard let vc = nav.topViewController as? ConversationWithReplyViewController else {
            return
        }
        
        let dict = sender as! [String: String]
        
        print(dict["threadId"])
        
        vc.postId = dict["threadId"]
        if let postId = dict["postId"] {
            vc.replyToPostId = postId
        }
    }

    func dequeueCell(post : Post, indexPath : NSIndexPath, allowHierarchy : Bool = false) -> UICollectionViewCell {
        if post.isMovie {
            let cell =  self.getCollectionView()!.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.MOVIE_POST_CELL, forIndexPath: indexPath) as! MoviePostCollectionViewCell
            
            cell.post = post
            cell.delegate = self
            return cell
        } else if post.isRootPost {
            let cell =  self.getCollectionView()!.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.ROOT_POST_CELL, forIndexPath: indexPath) as! RootPostCollectionViewCell
            
            cell.post = post
            cell.delegate = self
            return cell
        } else if allowHierarchy && !post.threadPost {
            let cell =  self.getCollectionView()!.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.POST_REPLY_CELL, forIndexPath: indexPath) as! PostReplyCollectionViewCell
            
            cell.post = post
            cell.delegate = self
            return cell
        } else if (post.isReview) {
            let cell = self.getCollectionView()!.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.POST_REVIEW_CELL, forIndexPath: indexPath) as! ReviewPostCollectionViewCell
            
            cell.post = post
            cell.delegate = self
            return cell
        }
        else {
            let cell = self.getCollectionView()!.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.POST_CELL, forIndexPath: indexPath) as! PostCollectionViewCell
            
            cell.post = post
            cell.delegate = self
            return cell
        }
    }
    
//    func prototypeCellSize(post p: Post, indexPath : NSIndexPath, width : CGFloat) -> CGFloat {
//        
//        if (!p.threadPost) {
//            replyPrototypeCell.post = p
//            return replyPrototypeCell.preferredHeight(width)
//        } else {
//            postPrototypeCell.post = p
//            return postPrototypeCell.preferredHeight(width)
//            
//        }
//    }
    
    func prototypeCellSize(post p: Post, allowHierarchy : Bool = false) -> CGSize {

        let height : CGFloat
        let frameSize = getCollectionView()!.frame.size
        
        if p.isMovie{
            moviePostPrototypeCell.post = p
            height = moviePostPrototypeCell.preferredHeight(frameSize.width)
        } else if (allowHierarchy && !p.threadPost) {
            replyPrototypeCell.post = p
            height = replyPrototypeCell.preferredHeight(frameSize.width)
        } else if (p.isReview) {
            reviewPostPrototypeCell.post = p
            height = reviewPostPrototypeCell.preferredHeight(frameSize.width)
        }else {
            postPrototypeCell.post = p
            height = postPrototypeCell.preferredHeight(frameSize.width)
        }
        
        return CGSize(width: frameSize.width, height: height)
    }

}
