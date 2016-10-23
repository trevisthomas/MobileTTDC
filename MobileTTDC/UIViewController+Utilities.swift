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
        return appDelegate.applicationContext.token
    }
    
    func getApplicationContext() -> ApplicationContext {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.applicationContext
    }
    
    func invokeLater(completion : () -> ()) {
        dispatch_async(dispatch_get_main_queue()) {
            completion()
        }
    }
    
    func registerAndCreatePrototypeCellFromNib(withName: String, forReuseIdentifier: String) -> UICollectionViewCell{
        let nib = UINib(nibName: withName, bundle: nil)
        self.getCollectionView()!.registerNib(nib, forCellWithReuseIdentifier: forReuseIdentifier)
        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionViewCell
    }
    
    func registerAndCreatePrototypeHeaderViewFromNib(withName: String, forReuseIdentifier: String) -> UICollectionReusableView{
        let nib = UINib(nibName: withName, bundle: nil)
        self.getCollectionView()!.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: forReuseIdentifier)
        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionReusableView
    }
    
    func getCollectionView() -> UICollectionView? {
        return nil
    }
    
    //TODO refactor this dequeue thing out to a common place
//    func dequeueCell(post : Post, indexPath : NSIndexPath) -> UICollectionViewCell {
//        if ((getApplicationContext().displayMode == .LatestGrouped) && !post.threadPost) {
//            let cell =  self.getCollectionView()!.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.POST_REPLY_CELL, forIndexPath: indexPath) as! PostReplyCollectionViewCell
//            
//            cell.post = post
//            cell.delegate = self
//            return cell
//        } else {
//            let cell = self.getCollectionView()!.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.POST_CELL, forIndexPath: indexPath) as! PostCollectionViewCell
//            
//            cell.post = post
//            cell.delegate = self
//            return cell
//        }
//    }
//    
    
}

/*
extension UIViewController : PostViewCellDelegate{
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
}
*/
