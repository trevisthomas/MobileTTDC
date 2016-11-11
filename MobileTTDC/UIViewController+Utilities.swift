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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.applicationContext.token
    }
    
    func invokeLater(_ completion : @escaping () -> ()) {
        DispatchQueue.main.async {
            completion()
        }
    }
    
    func registerAndCreatePrototypeCellFromNib(_ withName: String, forReuseIdentifier: String) -> UICollectionViewCell{
        let nib = UINib(nibName: withName, bundle: nil)
        self.getCollectionView()!.register(nib, forCellWithReuseIdentifier: forReuseIdentifier)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! UICollectionViewCell
    }
    
    func registerAndCreatePrototypeHeaderViewFromNib(_ withName: String, forReuseIdentifier: String) -> UICollectionReusableView{
        let nib = UINib(nibName: withName, bundle: nil)
        self.getCollectionView()!.register(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: forReuseIdentifier)
        return nib.instantiate(withOwner: nil, options: nil)[0] as! UICollectionReusableView
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
