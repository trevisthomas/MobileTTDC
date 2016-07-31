//
//  ConversationWithReplyViewController.swift
//  MobileTTDC
//
//  Created by Trevis Thomas on 7/17/16.
//  Copyright © 2016 Trevis Thomas. All rights reserved.
//

import UIKit

class ConversationWithReplyViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var replyTextView: UITextView!
    
    
    var postId: String! {
        didSet{
            loadPost(postId)
        }
    }
    var post : Post!
    
    private var replyPrototypeCell : ReplyCollectionViewCell!
    private var sectionHeaderPrototype : PostInHeaderCollectionReusableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        replyPrototypeCell = registerAndCreatePrototypeCellFromNib("ReplyCollectionViewCell", forReuseIdentifier: ReuseIdentifiers.REPLY_POST_CELL) as! ReplyCollectionViewCell
        
        sectionHeaderPrototype = registerAndCreatePrototypeHeaderViewFromNib("PostInHeaderCollectionReusableView", forReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW) as! PostInHeaderCollectionReusableView
        
        let view = NSBundle.mainBundle().loadNibNamed("AccessoryCommentView", owner: replyTextView, options: nil).first as! AccessoryCommentView
        view.delegate = self
        replyTextView.inputAccessoryView = view
        
    }
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
        commentAccessoryBecomeFirstResponder()
    }
  
    func commentAccessoryBecomeFirstResponder() {
        replyTextView.becomeFirstResponder() //This causes the keyboard to open.
        let accessory = replyTextView.inputAccessoryView as! AccessoryCommentView
        
//        accessory.defaultText = replyTextView.attributedText
        
        accessory.becomeFirstResponder() //This puts the accessory view in focus.
        //NOTE:  The actual text view needs to have it's "editibale" flag set to false or else it will get focus after dismssing the keyboard+accessory.
        replyTextView.inputAccessoryView?.hidden = false
        
    }
}

extension ConversationWithReplyViewController {
    
    private func registerAndCreatePrototypeHeaderViewFromNib(withName: String, forReuseIdentifier: String) -> UICollectionReusableView{
        let nib = UINib(nibName: withName, bundle: nil)
        self.collectionView!.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: forReuseIdentifier)
        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionReusableView
    }
    
    private func registerAndCreatePrototypeCellFromNib(withName: String, forReuseIdentifier: String) -> UICollectionViewCell{
        let nib = UINib(nibName: withName, bundle: nil)
        self.collectionView!.registerNib(nib, forCellWithReuseIdentifier: forReuseIdentifier)
        return nib.instantiateWithOwner(nil, options: nil)[0] as! UICollectionViewCell
    }
    
    private func loadPost(postId: String){
//        let cmd = PostCrudCommand(postId: postId)
//        Network.performPostCrudCommand(cmd){
//            (response, message) -> Void in
//            guard (response != nil) else {
//                print(message)
//                self.presentAlert("Error", message: "Failed to load post")
//                return;
//            }
//            
//            self.invokeLater{
//                self.post = response?.post
//                self.collectionView.reloadData()
//            }
//            
//        }
        
        let cmd = TopicCommand(type: .NESTED_THREAD_SUMMARY, postId: postId)
        Network.performPostCommand(cmd){
            (response, message) -> Void in
            guard (response != nil) else {
                print(message)
                self.presentAlert("Error", message: "Failed to load post")
                return;
            }
            
            self.invokeLater{
                self.post = response?.list.first
                self.collectionView.reloadData()
            }
            
        }
    }
}

extension ConversationWithReplyViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        post.posts![indexPath.row]
        let height = replyPrototypeCell.preferredHeight(collectionView.frame.width)
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        sectionHeaderPrototype.post = post
        let height = sectionHeaderPrototype.preferredHeight(collectionView.frame.width)
        return CGSize(width: collectionView.frame.width, height: height)
        
    }
}

extension ConversationWithReplyViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard post != nil else {
            return 0
        }
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if post == nil {
            return 0;
        }
        
        guard let count = post.posts?.count else {
            return 0
        }
        return count
//        return (post.posts?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifiers.REPLY_POST_CELL, forIndexPath: indexPath) as! ReplyCollectionViewCell
        cell.post = post.posts![indexPath.row]
        return cell
    
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                               withReuseIdentifier: ReuseIdentifiers.POST_IN_HEADER_VIEW,
                                                                               forIndexPath: indexPath) as! PostInHeaderCollectionReusableView
        headerView.post = post
        
        return headerView
    }
    
    
}

extension ConversationWithReplyViewController: AccessoryCommentViewDelegate {
    func accessoryCommentView(commentText commentText: String){
        replyTextView.text = commentText
        replyTextView.inputAccessoryView?.hidden = true
    }
}