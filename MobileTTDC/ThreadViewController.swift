//
//  ThreadViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 8/28/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ThreadViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var replyPrototypeCell : ReplyCollectionViewCell!
    private var sectionHeaderPrototype : PostInHeaderCollectionReusableView!
    
//    var post : Post!{
//        didSet{
//            collectionView.reloadData()
//        }
//    }
    
    var posts : [Post] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    var rootPostId : String! {
        didSet{
            fetchPost(rootPostId)
        }
    }
    
    func fetchPost(postId : String){
        
        
        
//        let cmd = PostCrudCommand(postId: postId, loadRootAncestor: true)
////
//        Network.performPostCrudCommand(cmd){
//            (response, message) -> Void in
//            guard (response != nil) else {
//                print(message)
//                self.presentAlert("Error", message: "Failed to load post")
//                return;
//            }
//            
//            self.invokeLater{
//                self.post = (response?.post)!
//            }
//        };
        let cmd = TopicCommand(type: .NESTED_THREAD_SUMMARY, postId: postId)
        
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                self.presentAlert("Sorry", message: "Webservice request failed.")
                return;
            }
            
            self.invokeLater{
                self.posts = (response?.list)!
            }
            
//            self.posts = (response?.list)!
//
//            self.collectionView.reloadData()
            
        };
    }
    
    override func viewDidLoad() {
        replyPrototypeCell = registerAndCreatePrototypeCellFromNib("ReplyCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.REPLY_POST_CELL) as! ReplyCollectionViewCell
        
        sectionHeaderPrototype = registerAndCreatePrototypeHeaderViewFromNib("PostInHeaderCollectionReusableView", forReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW) as! PostInHeaderCollectionReusableView
        
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func getCollectionView() -> UICollectionView? {
        return collectionView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        guard let indexPath = sender as? NSIndexPath else {
        //            return
        //        }
        
        
        //
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
        //
        //
        //        var threadId : String!
        //        switch (getApplicationContext().displayMode) {
        //            case .LatestFlat:
        //            let post = getApplicationContext().latestPosts()[indexPath.row]
        //            threadId = post.threadId
        //
        //            case .LatestGrouped:
        //            let post = getApplicationContext().latestPosts()[indexPath.section].posts![indexPath.row]
        //            threadId = post.threadId
        //        }
        
        let dict = sender as! [String: String]
        
        //        let threadId = sender as! String
        
        print(dict["threadId"])
        
        //        vc.postId = dict["threadId"]
        
        vc.postId = dict["threadId"]
        if let postId = dict["postId"] {
            vc.replyToPostId = postId
        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        print("Orientation: PostDetailViewController")
        
        coordinator.animateAlongsideTransition({ context in
            // do whatever with your context
            context.viewControllerForKey(UITransitionContextFromViewControllerKey)
            }, completion: {context in
                self.collectionView?.collectionViewLayout.invalidateLayout()
                
            }
        )
    }
}

extension ThreadViewController : UICollectionViewDelegate {
    
}

extension ThreadViewController : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return posts.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (posts[section].posts?.count)!
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.REPLY_POST_CELL, forIndexPath: indexPath) as! ReplyCollectionViewCell
        
        cell.post = posts[indexPath.section].posts![indexPath.row]
        cell.delegate = self
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                               withReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW,
                                                                               forIndexPath: indexPath) as! PostInHeaderCollectionReusableView
        headerView.post = posts[indexPath.section]
       
//        headerView.post = posts[indexPath.section]
        headerView.delegate = self
        
        
        return headerView
    }
}

extension ThreadViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var height : CGFloat
    
        replyPrototypeCell.post = posts[indexPath.section].posts![indexPath.row]
        height = replyPrototypeCell.preferredHeight(collectionView.frame.width)
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        sectionHeaderPrototype.post = posts[section]
        
        let height = sectionHeaderPrototype.preferredHeight(collectionView.frame.width)
        return CGSize(width: collectionView.frame.width, height: height)
    }
}

extension ThreadViewController : PostViewCellDelegate {
    func likePost(post: Post){
        
    }
    func viewComments(post: Post){
        
    }
    func commentOnPost(post: Post){
        print("Comment on Post - ThreadViewController\(post.postId)")
        
        var dict = [String: String]()
        dict["threadId"] = post.threadId
        dict["postId"] = post.postId
        performSegueWithIdentifier("ConversationWithReplyView", sender: dict)

    }
    func viewThread(post: Post){
        
    }
    
}


