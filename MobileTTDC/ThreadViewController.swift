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
        
        sectionHeaderPrototype.post = getApplicationContext().latestPosts()[section]
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
        
    }
    func viewThread(post: Post){
        
    }
    
}


